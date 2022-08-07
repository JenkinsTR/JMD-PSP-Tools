@ECHO OFF

REM # Enable extensions and make sure we're in the Current Directory.
REM # Keep this at the top of any bat file with intricate loops or declarations

@SETLOCAL enableextensions
@CD /d "%~dp0"

REM -------------------------------------------------------------
REM #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
REM #                                                           #
REM #              ISO Extractor Tool using 7-zip               #
REM #                                                           #
REM #      ©2008-2016 Jenkins Media. All Rights Reserved.       #
REM #                                                           #
REM #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
REM -------------------------------------------------------------

REM # Copyright info & CLI window styling
SET TTL=ISO Extractor Tool using 7-zip
SET CPR=(c)2008-2016 Jenkins Media. All Rights Reserved.
COLOR 8F
TITLE %TTL%
REM -------------------------------------------------------------
REM                      # # Let's begin # #
REM -------------------------------------------------------------

REM - - - - - - - - - - - - - - - - - - - - - - - - - - 
REM # UNIQUE TIME MACRO

REM # This SET is not needed anymore, instead we are using a function to create a string'd unique time
REM SET STARTTD=%TIME% - %DATE%
REM Broken algor
REM SET /a "yy=10000%yy% %%10000,mm=100%mm% %% 100,dd=100%dd% %% 100"

SET mm=%DATE:~4,2%
SET dd=%DATE:~7,2%
SET yy=%DATE:~10,4%
FOR /f "tokens=1-4 delims=:. " %%A IN ("%time: =0%") DO @SET UNIQUE=%yy%%mm%%dd%%%A%%B%%C%%D

REM # Now we SET the %UNIQUE% time variable, and stamp our starting time with %STARTTD%
IF "%~1" NEQ "" (SET %~1=%UNIQUE%) ELSE SET STARTTD=%TIME% - %DATE%
REM - - - - - - - - - - - - - - - - - - - - - - - - - - 
REM # Enable delayed variable expansions
SETLOCAL EnableDelayedExpansion

REM -------------------------------------------------------------
REM # SET a Log filename with unique time
SET LDIR=%CD%
SET LOGFILE=%LDIR%\extractISO_log_%UNIQUE%

REM SET some macros
SET CNV=Extracting
SET CNX=Extraction
SET MC1=Extraction complete

REM SET a time - date macro
SET TD1=Current time:

REM # some fancy formatting for the console window and the log file.
ECHO ------------------------------------------------ ># && type # && type # >> "%LOGFILE%.log"
ECHO %TTL% ># && type # && type # >> "%LOGFILE%.log"
ECHO. ># && type # && type # >> "%LOGFILE%.log"
ECHO %CPR% ># && type # && type # >> "%LOGFILE%.log"
ECHO ------------------------------------------------ ># && type # && type # >> "%LOGFILE%.log"
ECHO %TD1% %TIME%
ECHO. ># && type # && type # >> "%LOGFILE%.log"
REM -------------------------------------------------------------

REM -------------------------------------------------------------
REM             /!\ /!\    MAIN function    /!\ /!\ 
REM -------------------------------------------------------------
:ISOSTART

SET OPTS=x -y
SET SZ=C:\Program Files\7-Zip\7z.exe
REM -------------------------------------------------------------
REM Usage:
REM    7z x archive.iso -oc:\Doc
REM    extracts all files from the archive.iso archive to the c:\Doc directory.
       
REM    7z x *.iso -o*
REM    extracts all *.iso archives to subfolders with names of these archives.
REM -------------------------------------------------------------

REM # The function below will recursively seek out all .ISO files and extract them to a folder of the same name as the ISO.
REM # If none are found, ELSE skip the main function entirely, and GOTO the NOISO code block.
REM # For 7-zip, we don't need to specify an output folder, or even create one. -o* handles all of that
REM # We also use the FOR loop to grab the input file and use it's FQP as the 7-zip input.

REM -------------------------------------------------------------
REM Much more rigorous and functional way to check first.
REM Search for ISO files in the Tree
Set "ThisFolder=%CD%"
Set "sFileType=ISO"
PUSHD "%ThisFolder%" &&(
  FOR /R "." %%i IN (*) DO (
    If /i "%%~xi"==".%sFileType%" (
      Set ISOEXIST=TRUE & GoTo:EndSearch)
  )
)
:EndSearch
POPD

REM ISOEXIST will only be defined if one is found in a sub folder of the one where this batch was launched.
REM Otherwise, it will skip our main JUICE function and goto NOISO block
If Defined ISOEXIST (GOTO JUICE) else (
   GOTO NOISO)
REM -------------------------------------------------------------

REM -------------------------------------------------------------
REM The juice
:JUICE
PUSHD %CD%
FOR /r %%f IN (*.ISO) DO (
	SET ISO="%%f"
	IF EXIST !ISO! ( 
		SET ISOD=%%~dpf
		SET ISON=%%~nxf
		ECHO !ISO!
		ECHO !ISOD!
		ECHO !ISON!
	
		REM We found an .ISO, continue
		ECHO Found ISO in !ISOD! ># && type # && type # >> "%LOGFILE%.log"
		ECHO. ># && type # && type # >> "%LOGFILE%.log"
		ECHO Starting ISO %CNX%. ># && type # && type # >> "%LOGFILE%.log"
		ECHO. ># && type # && type # >> "%LOGFILE%.log"
		ECHO %CNV% !ISON! . . . ># && type # && type # >> "%LOGFILE%.log"
		ECHO. ># && type # && type # >> "%LOGFILE%.log"
		REM our main program
		"%SZ%" %OPTS% !ISO! -aoa -o"!ISOD!\*" ># && type # && type # >> "%LOGFILE%.log"
		ECHO. ># && type # && type # >> "%LOGFILE%.log"
		ECHO. ># && type # && type # >> "%LOGFILE%.log"
		)
)
POPD
REM -------------------------------------------------------------

GOTO END

:NOISO
ECHO No ISOs were found in all of "%CD%" ># && type # && type # >> "%LOGFILE%.log"
ECHO. ># && type # && type # >> "%LOGFILE%.log"
ECHO Exiting . . .

GOTO FANCY

REM -------------------------------------------------------------
REM #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
REM #                                                           #
REM #   EOF                                                     #
REM #                                                           #
REM #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
REM -------------------------------------------------------------

:END
REM # Here we are calling the %STARTTD% variable, to display both a start time and end time.
ECHO %CNX% started at %STARTTD% ># && type # && type # >> "%LOGFILE%.log"
ECHO. ># && type # && type # >> "%LOGFILE%.log"

REM # It is important to note that calling %TIME% and %DATE% will process the time and date exactly of the time it is called.
REM # The useful part is, if you use SET to create a %TIME% or %DATE% variable, Windows will STORE the data at the time the SET is called. (!)
REM # This %STARTTD% time is written near the start of this batch file,
REM # and stored inside the computers memory until we recall it again, but only while this batch file is open.
REM # Cool huh?

REM # So now we can display the actual %TIME% and %DATE% as of right now, logically after we have displayed the batch's starting time just a few lines above here.
ECHO %CNX% completed at %TIME% - %DATE% ># && type # && type # >> "%LOGFILE%.log"
ECHO. ># && type # && type # >> "%LOGFILE%.log"
REM -------------------------------------------------------------

:FANCY
REM # Some more fancy Formatting FOR CLI window and logfile to close.
ECHO. ># && type # && type # >> "%LOGFILE%.log"
ECHO ------------------------------------------------ ># && type # && type # >> "%LOGFILE%.log"
ECHO %TTL% ># && type # && type # >> "%LOGFILE%.log"
ECHO. ># && type # && type # >> "%LOGFILE%.log"
ECHO %CPR% ># && type # && type # >> "%LOGFILE%.log"
ECHO ------------------------------------------------ ># && type # && type # >> "%LOGFILE%.log"
ECHO. ># && type # && type # >> "%LOGFILE%.log"

REM -------------------------------------------------------------
:EEND
ECHO. ># && type # && type # >> "%LOGFILE%.log"

REM Delete temp log file
DEL "#"

REM Must come last
ENDLOCAL

REM Pause output
PAUSE

REM -------------------------------------------------------------
REM Git outta 'ere!
EXIT

