@ECHO OFF

REM # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
REM #
REM # JMPSP MEDIA CONVERTER
REM #
REM # This file is included as part of the JMDigital PSP Media Converter suite (JMPSPMC).
REM # Package Date: 05 Aug 2022
REM # (c)2008-2022 JMDigital/Jenkins Media. All Rights Reserved.
REM #
REM # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
REM # Web:       
REM # Contact:                  
REM # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
REM #
REM # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
REM # OUR TOOL MENUS
REM # USE CTRL + F AFTER DBL CLICKING THESE TO QUICK JUMP TO SECTIONS
REM # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
REM # Video_Tools_menu
REM # Image_Tools_menu
REM # Audio_Tools_menu
REM # About_JenkinsMedia_menu
REM # Toolkit_Changelog_menu
REM # Exit_menu
REM #
REM # OTHER FREQ ACCESSED SECTIONS:
REM # ERRNOTYPE
REM # GOAGAIN
REM # ENDTIME
REM # SUB_ROUTINES
REM # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:: jm_pspmc_v1.bat


SET JMS_Name=%~n0


SET JMS_Version=v1.0.0.1 (2022-08-05)


SET "JMS_Description=JMDigital PSP Media Converter suite"


SET JMSDateofv1=2022-08-05


SET "JMS_Notes=None"


REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

REM # Enable extensions and make sure we're in the Current Directory.
REM # Keep this at the top of any bat file with intricate loops or declarations

REM Set master local expansion and command extensions.
REM USE ONCE
@SetLocal enableextensions EnableDelayedExpansion

@CD /d "%~dp0"

REM Useful for debugging PUSHD level traversal (+) = number of levels, one + for each PUSHD level
@PROMPT $+

PUSHD "%~dp0"

REM # Copyright info & CLI window styling
SET "APPNAME=JMDigital PSP Media Converter [%JMS_Name% - %JMS_Version%]"

SET "CPR=^(c^)2008-2022 JMDigital/Jenkins Media. All Rights Reserved."
COLOR 8F
TITLE %APPNAME%

REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
REM                             # # Let's begin # #
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

REM Set a macro for the current directory
SET "TOPDIR=%~dp0"

REM ----------------------------------------------------------------------------------
REM # UNIQUE TIME MACRO
SET "mm=%DATE:~4,2%"
SET "dd=%DATE:~7,2%"
SET "yy=%DATE:~10,4%"
FOR /f "tokens=1-4 delims=:. " %%A IN ("%time: =0%") DO @SET UNIQUE=%yy%-%dd%-%mm%-%%A%%B-%%C%%D

REM # Now we SET the %UNIQUE% time variable
REM Commented out to avoid conflicts
REM IF "%~1" NEQ "" (SET %~1=%UNIQUE%) ELSE GOTO LOGS
REM ----------------------------------------------------------------------------------

REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
REM # SET the Master Output options
REM -----------------------------------------------------------------------------------

:LOGS
SET "OUTDIR=%~dp0"

REM # SET Log filenames with unique time
REM and stamp our starting time with %STARTTD%
SET "STARTTD=!TIME! - !DATE!"
SET "LOGS=%TOPDIR%logs"
SET "LOGFILE=%LOGS%\%JMS_Name%.%UNIQUE%.log"
SET "DEBUGLOG=%LOGS%\debug.%JMS_Name%.%UNIQUE%.log"
SET "ERRLOG=%LOGS%\%JMS_Name% errors %UNIQUE%.txt"
SET "TMPL=tmplog.tmp"
SET "TMPD=debuglog.tmp"
SET "TMPE=errorlog.tmp"
SET DBGMAC="%TMPD%" ^&^& type "%TMPD%" ^&^& type "%TMPD%" ^>^> "%DEBUGLOG%"
SET LOGMAC="%TMPL%" ^&^& type "%TMPL%" ^&^& type "%TMPL%" ^>^> "%LOGFILE%"
SET ERRMAC="%TMPE%" ^&^& type "%TMPE%" ^&^& type "%TMPE%" ^>^> "%ERRLOG%"
SET LOGnBUG="%TMPL%" ^&^& type "%TMPL%" ^&^& type "%TMPL%" ^>^> "%LOGFILE%" ^&^& type "%TMPL%" ^>^> "%DEBUGLOG%"

IF NOT EXIST "%LOGS%" MD "%LOGS%"

REM SET some macros
SET ACT=Actioning

SET ACT1=Action

SET "ACT2=%ACT1% complete"

REM END of setting the Master Output options
REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

REM -------------------------------------------------------------
REM #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
REM #                                                           #
REM #   Detect bitness                                          #
REM #                                                           #
REM #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
REM old way
REM IF %PROCESSOR_ARCHITECTURE%"=="AMD64" GOTO 64BIT
REM GOTO 32BIT

REM MS approved way
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && SET BITN=32BIT || SET BITN=64BIT
IF %BITN%==32BIT GOTO 32BIT
IF %BITN%==64BIT GOTO 64BIT

REM -------------------------------------------------------------
REM #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
REM -------------------------------------------------------------

REM -------------------------------------------------------------
REM #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
REM #                                                           #
REM #  Detect & SET directory                                   #
REM #                                                           #
REM #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
REM -------------------------------------------------------------
:64BIT

SET "PFILESX86=C:\Program Files (x86)"

GOTO CONTINUE

REM -------------------------------------------------------------

:32BIT

SET "PFILESX86=C:\Program Files"

ECHO 32bit is not supported. Sorry!

GOTO ERROR

REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
REM # SET the master program options
REM -----------------------------------------------------------------------------------

:CONTINUE
REM -----------------------------------------------------------------------------------
REM Set our binary paths
REM -----------------------------------------------------------------------------------
ECHO ===============================================================================>%DBGMAC%
ECHO Setting up our binary paths . . .>%DBGMAC%
ECHO(>%DBGMAC%

REM Main program directories
SET "JMTOOLS=%PFILESX86%\Jenkins Media\JM Tools"
SET "DBTOOLS=%JMTOOLS%\3rdparty"
SET "JMDEV=K:\GitHub\JM-Tools\app_src\PSPMediaConverter_src"

REM Most common redists
SET "IM_MASTER=%JMDEV%\bin\ImageMagick-7.1.0-portable-Q16-HDRI-x64"
SET "LAME=%DBTOOLS%\Lame\lame.exe"
SET "FFMPEG=%JMDEV%\bin\ffmpeg-n5.1-latest-win64-gpl-5.1\bin\ffmpeg.exe"
SET "FNR=%DBTOOLS%\fnr.exe"
SET "HNDBRK=%JMDEV%\bin\HandBrakeCLI-1.5.1-win-x86_64"
SET "HBCLI=HandBrakeCLI.exe"
SET "HBMKV=%HNDBRK%\%HBCLI%"

REM MediaInfo
SET "MINFO64=%DBTOOLS%\MediaInfo17.10_x64\MediaInfo.exe"

REM DONT USE %7Z% -- Possible conflicts with 7-Zip internal env vars
SET "SZ=C:\Program Files\7-Zip\7z.exe"

REM Rob Van Der Woud's batch tools
SET "DDTBEXE=%DBTOOLS%\RVDWTools\DateTimeBox.exe"
SET "DDDBEXE=%DBTOOLS%\RVDWTools\DropDownBox.exe"
SET "DINBEXE=%DBTOOLS%\RVDWTools\InputBox.exe"
SET "DMGBEXE=%DBTOOLS%\RVDWTools\MessageBox.exe"
SET "DOFBEXE=%DBTOOLS%\RVDWTools\OpenFileBox.exe"
SET "DODBEXE=%DBTOOLS%\RVDWTools\OpenFolderBox.exe"
SET "DPRNEXE=%DBTOOLS%\RVDWTools\PrinterSelectBox.exe"
SET "DSVFEXE=%DBTOOLS%\RVDWTools\SaveFileBox.exe"

REM Image Optimisation tools
SET "OPTEXE=%DBTOOLS%\optipng.exe"
SET "CSHEXE=%DBTOOLS%\pngcrush_1_7_87_w64.exe"

REM ImageMagick binaries
SET "IM_COMPARE=compare.exe"
SET "IM_COMPOSITE=composite.exe"
SET "IM_CONJURE=conjure.exe"
SET "IM_CONVERT=convert.exe"
SET "IM_DCRAW=dcraw.exe"
SET "IM_FFMPEG=ffmpeg.exe"
SET "IM_HP2XX=hp2xx.exe"
SET "IM_ID=identify.exe"
SET "IM_IMDISP=IMDisplay.exe"
SET "IM_MAGICK=magick.exe"
SET "IM_MOGRIFY=mogrify.exe"
SET "IM_MONTAGE=montage.exe"
SET "IM_STREAM=stream.exe"

REM Horst Schaeffer's batch tools
SET "HSBT_WINP=%DBTOOLS%\HSBT\winput.exe"
SET "HSBT_WPRO=%DBTOOLS%\HSBT\Wprompt.exe"
SET "HSBT_WSEL=%DBTOOLS%\HSBT\Wselect.exe"
SET "HSBT_FTO=%DBTOOLS%\HSBT\FileToOpen.exe"
SET "HSBT_FTS=%DBTOOLS%\HSBT\FileToSave.exe"
SET "HSBT_WBOX=%DBTOOLS%\HSBT\Wbox.exe"
SET "HSBT_WBUS=%DBTOOLS%\HSBT\Wbusy.exe"
SET "HSBT_WDIR=%DBTOOLS%\HSBT\Wfolder.exe"
SET "HSBT_WDIR2=%DBTOOLS%\HSBT\Wfolder2.exe"

REM Image readmes launched from CLI
REM See https://superuser.com/questions/246825/open-file-from-the-command-line-on-windows
REM for proper usage
SET MKVNOTICE_IMG=explorer "%JMTOOLS%\Readme\mkvnotice.jpg"

REM -----------------------------------------------------------------------------------
REM Echo these SETs out to the debug log
ECHO SET DBTOOLS as "%DBTOOLS%" >NUL 2>&1 >%DBGMAC%

ECHO SET IM_MASTER as "%IM_MASTER%" >NUL 2>&1 >%DBGMAC%
ECHO SET LAME as "%LAME%" >NUL 2>&1 >%DBGMAC%
ECHO SET FFMPEG as "%FFMPEG%" >NUL 2>&1 >%DBGMAC%
ECHO SET HNDBRK as "%HNDBRK%" >NUL 2>&1 >%DBGMAC%
ECHO SET HBCLI as "%HBCLI%" >NUL 2>&1 >%DBGMAC%
ECHO SET HBMKV as "%HBMKV%" >NUL 2>&1 >%DBGMAC%
ECHO SET FNR as "%FNR%" >NUL 2>&1 >%DBGMAC%

ECHO SET SZ as "%SZ%" >NUL 2>&1 >%DBGMAC%

ECHO SET DDTBEXE as "%DDTBEXE%" >NUL 2>&1 >%DBGMAC%
ECHO SET DDDBEXE as "%DDDBEXE%" >NUL 2>&1 >%DBGMAC%
ECHO SET DINBEXE as "%DINBEXE%" >NUL 2>&1 >%DBGMAC%
ECHO SET DMGBEXE as "%DMGBEXE%" >NUL 2>&1 >%DBGMAC%
ECHO SET DOFBEXE as "%DOFBEXE%" >NUL 2>&1 >%DBGMAC%
ECHO SET DODBEXE as "%DODBEXE%" >NUL 2>&1 >%DBGMAC%
ECHO SET DPRNEXE as "%DPRNEXE%" >NUL 2>&1 >%DBGMAC%
ECHO SET DSVFEXE as "%DSVFEXE%" >NUL 2>&1 >%DBGMAC%

ECHO SET OPTEXE as "%OPTEXE%" >NUL 2>&1 >%DBGMAC%
ECHO SET CSHEXE as "%CSHEXE%" >NUL 2>&1 >%DBGMAC%

ECHO SET IM_COMPARE as "%IM_MASTER%\%IM_COMPARE%" >NUL 2>&1 >%DBGMAC%
ECHO SET IM_COMPOSITE as "%IM_MASTER%\%IM_COMPOSITE%" >NUL 2>&1 >%DBGMAC%
ECHO SET IM_CONJURE as "%IM_MASTER%\%IM_CONJURE%" >NUL 2>&1 >%DBGMAC%
ECHO SET IM_CONVERT as "%IM_MASTER%\%IM_CONVERT%" >NUL 2>&1 >%DBGMAC%
ECHO SET IM_DCRAW as "%IM_MASTER%\%IM_DCRAW%" >NUL 2>&1 >%DBGMAC%
ECHO SET IM_FFMPEG as "%IM_MASTER%\%IM_FFMPEG%" >NUL 2>&1 >%DBGMAC%
ECHO SET IM_HP2XX as "%IM_MASTER%\%IM_HP2XX%" >NUL 2>&1 >%DBGMAC%
ECHO SET IM_ID as "%IM_MASTER%\%IM_ID%" >NUL 2>&1 >%DBGMAC%
ECHO SET IM_IMDISP as "%IM_MASTER%\%IM_IMDISP%" >NUL 2>&1 >%DBGMAC%
ECHO SET IM_MAGICK as "%IM_MASTER%\%IM_MAGICK%" >NUL 2>&1 >%DBGMAC%
ECHO SET IM_MOGRIFY as "%IM_MASTER%\%IM_MOGRIFY%" >NUL 2>&1 >%DBGMAC%
ECHO SET IM_MONTAGE as "%IM_MASTER%\%IM_MONTAGE%" >NUL 2>&1 >%DBGMAC%
ECHO SET IM_STREAM as "%IM_MASTER%\%IM_STREAM%" >NUL 2>&1 >%DBGMAC%

ECHO SET HSBT_WINP as %HSBT_WINP% >NUL 2>&1 >%DBGMAC%
ECHO SET HSBT_WPRO as %HSBT_WPRO% >NUL 2>&1 >%DBGMAC%
ECHO SET HSBT_WSEL as %HSBT_WSEL% >NUL 2>&1 >%DBGMAC%
ECHO SET HSBT_FTO as %HSBT_FTO% >NUL 2>&1 >%DBGMAC%
ECHO SET HSBT_FTS as %HSBT_FTS% >NUL 2>&1 >%DBGMAC%
ECHO SET HSBT_WBOX as %HSBT_WBOX% >NUL 2>&1 >%DBGMAC%
ECHO SET HSBT_WBUS as %HSBT_WBUS% >NUL 2>&1 >%DBGMAC%
ECHO SET HSBT_WDIR as %HSBT_WDIR% >NUL 2>&1 >%DBGMAC%
ECHO SET HSBT_WDIR2 as %HSBT_WDIR2% >NUL 2>&1 >%DBGMAC%

ECHO SET MKVNOTICE_IMG as %MKVNOTICE_IMG% >NUL 2>&1 >%DBGMAC%

ECHO(>%DBGMAC%
ECHO Done^! >NUL 2>&1 >%DBGMAC%
ECHO(>%DBGMAC%

REM END of setting the master program options
REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
REM # SET the master database options
REM -----------------------------------------------------------------------------------
SET JMDB=pspmc.database.files
SET VDBNM=%JMDB%.videos.csv
SET ADBNM=%JMDB%.audio.csv
SET IDBNM=%JMDB%.images.csv

IF NOT EXIST "%TOPDIR%%JMDB%" MKDIR "%TOPDIR%%JMDB%"

SET "JMT_VIDEO_DB=%TOPDIR%%JMDB%\%VDBNM%"
SET "JMT_AUDIO_DB=%TOPDIR%%JMDB%\%ADBNM%"
SET "JMT_IMAGE_DB=%TOPDIR%%JMDB%\%IDBNM%"

ECHO SET JMT_VIDEO_DB as "%JMT_VIDEO_DB%" >NUL 2>&1 >%DBGMAC%
ECHO SET JMT_AUDIO_DB as "%JMT_AUDIO_DB%" >NUL 2>&1 >%DBGMAC%
ECHO SET JMT_IMAGE_DB as "%JMT_IMAGE_DB%" >NUL 2>&1 >%DBGMAC%

REM SET Headers ONCE
IF NOT EXIST "%JMT_VIDEO_DB%" ECHO Filename,Duration ^(ms^),FPS,Width,Height,Aspect Ratio,Original Filesize ^(KB^),Output Filesize ^(KB^),Saved Percent,Time to Process,Time,Date,Username >"%JMT_VIDEO_DB%"
IF NOT EXIST "%JMT_AUDIO_DB%" ECHO Filename,Duration ^(ms^),dB,BPM,Original Filesize,Output Filesize,Saved Percent,Time to Process,TimeDate,Username >"%JMT_AUDIO_DB%"
IF NOT EXIST "%JMT_IMAGE_DB%" ECHO Filename,Width,Height,Mean,Mean ^(Rounded Total^),Standard Deviation,Standard Deviation ^(Rounded Total^),Colourfulness,Colourfulness ^(Normalised^),Colourfulness ^(Rounded Total^),Score ^(out of 1 million^),Original Filesize,Output Filesize,Saved Percent,Time to Process,TimeDate,Username >"%JMT_IMAGE_DB%"

REM END of setting the master database options
REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =


GOTO START

:RESTART
ECHO Restarting choice selector >%DBGMAC%
ECHO. >%DBGMAC%

:START
REM Set our starting time for later calcs
SET "STARTTIME=%TIME%"

REM # some fancy formatting for the console window and log file.
CLS
SET "q=^"
ECHO ===============================================================================>%DBGMAC%
ECHO %APPNAME% >%DBGMAC%
ECHO %CPR% >%DBGMAC%
ECHO ===============================================================================>%DBGMAC%
ECHO.>%DBGMAC%
CLS
ECHO ===============================================================================
CALL :c 97 "%APPNAME%" /n
ECHO %CPR%
ECHO ===============================================================================
: Uncomment this to skip message and go straight to program
REM GOTO MAIN

REM -----------------------------------------------------------------------------------
::Usage:	MESSAGEBOX "message" "title" buttons icon default option timeout

::Where:	buttons	"AbortRetryIgnore", "OK", "OKCancel",
::		"RetryCancel", "YesNo" or "YesNoCancel"
::	icon	"Asterisk", "Error", "Exclamation", "Hand",
::		"Information", "None", "Question", "Stop"
::		or "Warning"
::	default	"Button1", "Button2" or "Button3"
::	option	"RightAlign" or "RtlReading"
::	timeout	timeout interval in seconds

::Notes:	Whereas all arguments are optional, each argument requires
::	all preceding arguments, i.e. icon requires "message", "title"
::	and buttons, but not necessarily default, option and timeout.
::	Linefeeds (\n), tabs (\t \t) and doublequotes (\") are
::	allowed in the message string.
::	The (English) caption of the button that was clicked
::	is returned as text to Standard Output (in lower case),
::	or "timeout" if the timeout interval expired.
::	The return code of the program is 0 if a button was clicked,
::	1 in case of (command line) errors, 3 if the timeout expired.
REM -----------------------------------------------------------------------------------

REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
REM -----------------------------------------------------------------------------------
REM Message box
:MESSAGE
"%DMGBEXE%" "%APPNAME% \012 \012 First released: %JMSDateofv1% \012 \012 %JMS_Description% \012 \012 \012 \012 \012 Notes: %JMS_Notes% \012 \012 \012 \012 \012 (c)2008-2020 JMDigital/Jenkins Media" "(c)2008-2020 JMDigital/Jenkins Media" "OK" "Information" "Button1" "NoEscape" "60"
REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:PSPMC_VIDEO

SET "OUTEXT=MP4"

REM ------ FILES ------
REM CALL our supported files SETs
CALL :SUPPORTEDFILES_VIDEOS

REM CALL our file browser selector function based on above SETs
CALL :SUPPORTEDFILES_VIDEOS_EXE

REM CALL our Find N Replace function on the userselectedfiles.tmp file for 1 or more files
CALL :REPLACEUSF_ALL

REM CALL our file line counter
CALL :COUNTLINES

ECHO If we have 1 line, most likely only 1 file was selected>%DBGMAC%
ECHO IF !FILEAMT! EQ 1 GOTO PSPMC_VIDEO_SKIPFNR>%DBGMAC%
ECHO.>%DBGMAC%

IF !FILEAMT! LEQ 1 GOTO PSPMC_VIDEO_SKIPFNR

REM CALL our Find N Replace function on the userselectedfiles.tmp again for multiple detected files
CALL :REPLACEUSF_MULTI

GOTO PSPMC_VIDEO_MULTIFILES

:PSPMC_VIDEO_SKIPFNR
REM CALL our Find N Replace function on the userselectedfiles.tmp again for the single detected file
CALL :REPLACEUSF_SINGLEFILE

REM CALL our Total size function to calculate how many MB our selection was
CALL :TOTALSIZEIN

REM -------------------------------------------------------------
REM main program

:PSPMC_VIDEO_MULTIFILES

REM CALL the console printed notice about the various quality levels based on real world examples
REM We should just use a jpeg image and open it from the CLI...
REM %MKVNOTICE_IMG%
REM CALL :MKVNOTICE

REM Here we added output folder selection
ECHO %Username%, please select your output folder . . . >%DBGMAC%
ECHO.>%DBGMAC%

:: NEW :: We're now grabbing the top level folder from the first file selected instead of %CD%

FOR /F "usebackq tokens=* delims=" %%G IN ("%temp%\userselectedfiles.tmp") DO (
	REM CALL Our standard file constants
	SET "FILE=%%G"
	SET "FILED=%%~dpG"
	SET "FILEN=%%~nG"
	SET "FILEX=%%~xG"
	SET "FILEZ=%%~zG"

)

REM "%DODBEXE%" "%CD%" "%Username%, please select an output folder, or make a new one." /MD >o
REM For some reason the below \ in the FILED output macro is required
"%DODBEXE%" "%FILED%\" "%Username%, please select the root of your memory stick as the output folder, or make a new one." /MD >o
SET /p CHOSENDIROUT=<o

IF EXIST "o" DEL "o" /q /s >NUL 2>&1

IF "%ReturnCode%"=="1" GOTO ERROR
IF "%ReturnCode%"=="2" GOTO CANCELED

ECHO Your chosen output folder is^: >%DBGMAC%
ECHO %CHOSENDIROUT% >%DBGMAC%
ECHO.>%DBGMAC%

REM CALL our main QUALITY input box function for MKV crunching
REM CALL :QUALITY_CRUNCHMKV

REM Make sure our relevant PSP target folder variants exist in the chosen output directory.
IF NOT EXIST "%CHOSENDIROUT%\PSP" MKDIR "%CHOSENDIROUT%\PSP"
IF NOT EXIST "%CHOSENDIROUT%\PSP\MP_ROOT" MKDIR "%CHOSENDIROUT%\PSP\MP_ROOT"
IF NOT EXIST "%CHOSENDIROUT%\PSP\MP_ROOT\100ANV01" MKDIR "%CHOSENDIROUT%\PSP\MP_ROOT\100ANV01"
IF NOT EXIST "%CHOSENDIROUT%\PSP\MP_ROOT\100MNV01" MKDIR "%CHOSENDIROUT%\PSP\MP_ROOT\100MNV01"
REM IF NOT EXIST "%CHOSENDIROUT%\PSP\MUSIC" MKDIR "%CHOSENDIROUT%\PSP\MUSIC"
REM IF NOT EXIST "%CHOSENDIROUT%\PSP\PHOTO" MKDIR "%CHOSENDIROUT%\PSP\PHOTO"
IF NOT EXIST "%CHOSENDIROUT%\PSP\VIDEO" MKDIR "%CHOSENDIROUT%\PSP\VIDEO"

CALL :RESET_COUNTS_PERCS

SET /A NUMFILES=0

FOR /F "usebackq tokens=* delims=" %%G IN ("%temp%\userselectedfiles.tmp") DO (

	REM CALL Our duration start subroutine
	CALL :DURATION_START

	REM CALL Our standard file constants
	SET "FILE=%%G"
	SET "FILED=%%~dpG"
	SET "FILEN=%%~nG"
	SET "FILEX=%%~xG"
	SET "FILEZ=%%~zG"
	CALL :DYNANMICFILE
	
	REM SET /a NUMFILES=NUMFILES+1
	REM SET AUTONAME=MAQ0000!NUMFILES!

	REM Supported files function - now serves as our main extension based conversion code
	PUSHD "!FILED!"
	REM CALL our pre supported files function
	CALL :PRESUPPORTEDFILES

	ECHO Converting !FILEN!!FILEX! to !FILEN!_JMPSPMC.%OUTEXT% . . . >%DBGMAC%
	ECHO. >%DBGMAC%

	REM SET folders
	REM SET DIR1=_CRUNCHED_MKV
	REM MKDIR "!FILED!%DIR1%"
	
	REM We need to get the original audio codec first in order to set correct passthru options for HB
	REM "%MINFO64%" "!FILE!" --Inform=Audio;%%Format%% >"!FILED!!FILEN!_audio.format"
	REM "%MINFO64%" "!FILE!" --Inform=Audio;%%CodecID/Hint%% >"!FILED!!FILEN!_audio.codec"
	"%MINFO64%" "!FILE!" --Inform=Video;%%FrameRate%% >"!FILED!!FILEN!_video.frate"
	"%MINFO64%" "!FILE!" --Inform=Video;%%Height%% >"!FILED!!FILEN!_video.h"
	"%MINFO64%" "!FILE!" --Inform=Video;%%Width%% >"!FILED!!FILEN!_video.w"
	"%MINFO64%" "!FILE!" --Inform=Video;%%DisplayAspectRatio%% >"!FILED!!FILEN!_video.dar"
	"%MINFO64%" "!FILE!" --Inform=Video;%%Duration%% >"!FILED!!FILEN!_video.dur"
	REM SET /p AFORMAT=<"!FILED!!FILEN!_audio.format"
	REM SET /p AFORMAT2=<"!FILED!!FILEN!_audio.codec"
	SET /p VFRATE2=<"!FILED!!FILEN!_video.frate"
	SET /p VHEIGHT=<"!FILED!!FILEN!_video.h"
	SET /p VWIDTH=<"!FILED!!FILEN!_video.w"
	SET /p VDAR=<"!FILED!!FILEN!_video.dar"
	SET /p VDUR=<"!FILED!!FILEN!_video.dur"
	REM IF EXIST "!FILED!!FILEN!_audio.format" DEL "!FILED!!FILEN!_audio.format" /q /s >NUL 2>&1
	REM IF EXIST "!FILED!!FILEN!_audio.codec" DEL "!FILED!!FILEN!_audio.codec" /q /s >NUL 2>&1
	IF EXIST "!FILED!!FILEN!_video.frate" DEL "!FILED!!FILEN!_video.frate" /q /s >NUL 2>&1
	IF EXIST "!FILED!!FILEN!_video.h" DEL "!FILED!!FILEN!_video.h" /q /s >NUL 2>&1
	IF EXIST "!FILED!!FILEN!_video.w" DEL "!FILED!!FILEN!_video.w" /q /s >NUL 2>&1
	IF EXIST "!FILED!!FILEN!_video.dar" DEL "!FILED!!FILEN!_video.dar" /q /s >NUL 2>&1
	IF EXIST "!FILED!!FILEN!_video.dur" DEL "!FILED!!FILEN!_video.dur" /q /s >NUL 2>&1
	
	REM ECHO "AFORMAT" = !AFORMAT! >%DBGMAC%
	REM ECHO "AFORMAT2" = !AFORMAT2! >%DBGMAC%
	ECHO "VFRATE2" = !VFRATE2! >%DBGMAC%
	ECHO "VHEIGHT" = !VHEIGHT! >%DBGMAC%
	ECHO "VWIDTH" = !VWIDTH! >%DBGMAC%
	ECHO "VDAR" = !VDAR! >%DBGMAC%
	ECHO "VDUR" = !VDUR! >%DBGMAC%
	
	REM Hack to get around whole number framerates like 25.000 and return a non-decimal value
	IF "!VFRATE2!"=="999.999" SET VFRATE=999
	IF "!VFRATE2!"=="980.000" SET VFRATE=980
	IF "!VFRATE2!"=="960.000" SET VFRATE=960
	IF "!VFRATE2!"=="940.000" SET VFRATE=940
	IF "!VFRATE2!"=="920.000" SET VFRATE=920
	IF "!VFRATE2!"=="900.000" SET VFRATE=900
	IF "!VFRATE2!"=="860.000" SET VFRATE=860
	IF "!VFRATE2!"=="820.000" SET VFRATE=820
	IF "!VFRATE2!"=="780.000" SET VFRATE=780
	IF "!VFRATE2!"=="720.000" SET VFRATE=720
	IF "!VFRATE2!"=="680.000" SET VFRATE=680
	IF "!VFRATE2!"=="540.000" SET VFRATE=540
	IF "!VFRATE2!"=="480.000" SET VFRATE=480
	IF "!VFRATE2!"=="360.000" SET VFRATE=360
	IF "!VFRATE2!"=="240.000" SET VFRATE=240
	IF "!VFRATE2!"=="120.000" SET VFRATE=120
	IF "!VFRATE2!"=="100.000" SET VFRATE=100
	IF "!VFRATE2!"=="90.000" SET VFRATE=90
	IF "!VFRATE2!"=="75.000" SET VFRATE=75
	IF "!VFRATE2!"=="72.000" SET VFRATE=72
	IF "!VFRATE2!"=="60.000" SET VFRATE=60
	IF "!VFRATE2!"=="59.940" SET VFRATE=59.94
	IF "!VFRATE2!"=="50.000" SET VFRATE=50
	IF "!VFRATE2!"=="48.000" SET VFRATE=48
	IF "!VFRATE2!"=="30.000" SET VFRATE=30
	IF "!VFRATE2!"=="29.970" SET VFRATE=29.97
	IF "!VFRATE2!"=="25.000" SET VFRATE=25
	IF "!VFRATE2!"=="24.000" SET VFRATE=24
	IF "!VFRATE2!"=="20.000" SET VFRATE=20
	IF "!VFRATE2!"=="15.000" SET VFRATE=15
	IF "!VFRATE2!"=="12.000" SET VFRATE=12
	IF "!VFRATE2!"=="10.000" SET VFRATE=10
	IF "!VFRATE2!"=="5.000" SET VFRATE=5
	
	REM VFR possibly detected, setting to 30fps
	IF "!VFRATE2!" == "" SET VFRATE=30 && SET VFR=TRUE
	
	::TOTALPERC
	IF !FILEAMT! GTR 1 (
		SET /A COUNT += 1
		SET FILENUM=!COUNT!
		REM ECHO FILENUM IS !FILENUM! out of !FILEAMT!>%DBGMAC%
		REM ECHO.>%DBGMAC%
		SET /A "FILENUM1=FILENUM*100"
		REM ECHO FILENUM1 = !FILENUM1! >%DBGMAC%
		REM ECHO.>%DBGMAC%
		SET /A "TOTALPERC=FILENUM1/FILEAMT"
		REM ECHO TOTALPERC IS !TOTALPERC!%% >%DBGMAC%
		REM ECHO.>%DBGMAC%
	)

	SET FFOPTS1=-flags +bitexact -vcodec libx264 -profile:v baseline -level 3.0 -s 480x272
	SET FFOPTS2=-b:v 256k -acodec aac -b:a 64k -ar 44100 -f psp -strict -2

	::CFR
	IF NOT "!VFR!"=="TRUE" "%FFMPEG%" -y -i "!FILE!" !FFOPTS1! -r !VFRATE! !FFOPTS2! "%CHOSENDIROUT%\PSP\VIDEO\!FILEN!_JMPSPMC.%OUTEXT%"
	
	::VFR
	IF "!VFR!"=="TRUE" "%FFMPEG%" -y -i "!FILE!" !FFOPTS1! -vsync vfr -r !VFRATE! !FFOPTS2! "%CHOSENDIROUT%\PSP\VIDEO\!FILEN!_JMPSPMC.%OUTEXT%"
	
	
	REM Old auto folder code
	REM ECHO !FILED!%DIR1%\!FILEN!_10bit!HDEF!.%OUTEXT%>tmp.size
	ECHO %CHOSENDIROUT%\PSP\VIDEO\!FILEN!_JMPSPMC.%OUTEXT%>tmp.size

	FOR /F "usebackq tokens=* delims=" %%F IN ("tmp.size") DO (
		SET "OUTFILEZKB=%%~zF"
		CALL :OUTFILESIZEKB
	)

	REM CALL our Total Percentage function
	CALL :TOTALPERC

	REM CALL Our duration end subroutine
	CALL :DURATION_END

	REM CALL our Remaining size function to calculate how many MB is left to process out of our selection
	CALL :REMAINSIZE

	IF !FILEAMT! GTR 1 (
		ECHO Process completed.>%DBGMAC%
		ECHO Files Processed: !FILENUM! out of !FILEAMT! ^(!TOTALPERC!%%^)>%DBGMAC%
		ECHO Conversion took !FANCYDURATION_!>%DBGMAC%
		ECHO.>%DBGMAC%
		ECHO.>%DBGMAC%
		ECHO %CPR%>%DBGMAC%
		ECHO www.jmdigital.net.au>%DBGMAC%
		"%HSBT_WBUS%" "jmt.crunchmkv" "Process completed. ^^ ^^Files Processed: !FILENUM! out of !FILEAMT! ^(!TOTALPERC!%%^) ^^Crunch took $sec seconds ^^ ^^You saved approx. !OUTSIZEKB! KB ^(!OUTPERCKB!%%^). ^^ ^^ ^^ ^^Copyright ^(c^)2008-2022 Jenkins Media. All Rights Reserved. ^^www.jmdigital.net.au" /Stop /sound /timeout=3
	)
	IF !FILEAMT! LEQ 1 (
		ECHO Process completed.>%DBGMAC%
		ECHO File Processed: !FILEN!>%DBGMAC%
		ECHO Conversion took !FANCYDURATION_!>%DBGMAC%
		ECHO.>%DBGMAC%
		ECHO.>%DBGMAC%
		ECHO %CPR%>%DBGMAC%
		ECHO www.jmdigital.net.au>%DBGMAC%
		"%HSBT_WBUS%" "jmt.crunchmkv" "Process completed. ^^ ^^File Processed: !FILEN! ^^Crunch took $sec seconds ^^ ^^You saved approx. !OUTSIZEKB! KB ^(!OUTPERCKB!%%^). ^^ ^^ ^^ ^^Copyright ^(c^)2008-2022 Jenkins Media. All Rights Reserved. ^^www.jmdigital.net.au" /Stop /sound /timeout=3
	)
	
	REN "!FILE!" "!FILEN!!FILEX!ORIG" 2>%ERRMAC%

	REM ECHO "VFRATE2" = !VFRATE2! >%DBGMAC%
	REM ECHO "VHEIGHT" = !VHEIGHT! >%DBGMAC%
	REM ECHO "VWIDTH" = !VWIDTH! >%DBGMAC%
	REM ECHO "VDAR" = !VDAR! >%DBGMAC%
	REM ECHO "VDUR" = !VDUR! >%DBGMAC%
	REM Old auto folder code
	REM IF EXIST "%JMT_VIDEO_DB%" ECHO !FILED!%DIR1%\!FILEN!_10bit!HDEF!.%OUTEXT%,!VDUR!,!VFRATE2!,!VWIDTH!,!VHEIGHT!,!VDAR!,!KBYTES!,!OUTSIZEKB!,!OUTPERCKB!,!FANCYDURATION_!,!TIME!,!DATE!,%Username% >>"%JMT_VIDEO_DB%"
	REM ECHO !FILED!%DIR1%\!FILEN!_10bit!HDEF!.%OUTEXT%>>jmt_files_output.txt
	IF EXIST "%JMT_VIDEO_DB%" ECHO %CHOSENDIROUT%\PSP\VIDEO\!FILEN!_JMPSPMC.%OUTEXT%,!VDUR!,!VFRATE2!,!VWIDTH!,!VHEIGHT!,!VDAR!,!KBYTES!,!OUTSIZEKB!,!OUTPERCKB!,!FANCYDURATION_!,!TIME!,!DATE!,%Username% >>"%JMT_VIDEO_DB%"
	ECHO %CHOSENDIROUT%\PSP\VIDEO\!FILEN!_JMPSPMC.%OUTEXT%>>jmt_files_output.txt
	ECHO. >%DBGMAC%
	ECHO. >%DBGMAC%

	REM Silently erase all of our temporary files
	CALL :ERASETMPFILES

	REM End of master FOR loop

)

REM Finished all %sFileType9%'s, moving to the end
ECHO Finished all files, and finished all supported files. Moving to the end.>%DBGMAC%

CALL :RENAMECRUNCHED

REM Silently erase all of our temporary files
CALL :ERASETMPFILES

POPD

REM Silently erase all of our temporary files
CALL :ERASETMPFILES

GOTO END









REM -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:ERRNOTYPE
ECHO.>%ERRMAC%>%DBGMAC%
ECHO ERROR: Either an error occurred or you cancelled.>%DBGMAC%>%ERRMAC%
ECHO.>%ERRMAC%>%DBGMAC%

GOTO ERREND

:ERRNOEXT
ECHO.>%ERRMAC%>%DBGMAC%
ECHO ERROR: No files of extension type %EXT1% were found, or the file is not supported.>%DBGMAC%>%ERRMAC%
ECHO.>%ERRMAC%>%DBGMAC%

GOTO ERREND

:ERROR
ECHO.>%DBGMAC%
ECHO.>%DBGMAC%
ECHO.>%DBGMAC%
ECHO.>%ERRMAC%>%DBGMAC%
ECHO ERROR: A unspecified error has occurred.>%DBGMAC%>%ERRMAC%
ECHO.>%ERRMAC%>%DBGMAC%
ECHO.>%ERRMAC%>%DBGMAC%
ECHO.>%DBGMAC%
ECHO.>%DBGMAC%
ECHO.>%DBGMAC%

GOTO ERREND

:CANCELLED
ECHO.>%DBGMAC%
ECHO.>%DBGMAC%
ECHO.>%DBGMAC%
ECHO.>%ERRMAC%>%DBGMAC%
ECHO You cancelled.>%DBGMAC%>%ERRMAC%
ECHO.>%ERRMAC%>%DBGMAC%
ECHO.>%ERRMAC%>%DBGMAC%
ECHO.>%DBGMAC%
ECHO.>%DBGMAC%
ECHO.>%DBGMAC%

GOTO ERREND

:ERREND
ECHO This is fired after any error or notice>%DBGMAC%
ECHO.>%DBGMAC%

REM -------------------------------------------------------------
:END
REM Put a new line at the end of the logs to be 150% sure not to prepend to previous ones
ECHO.>%DBGMAC%

:GOAGAIN
:: Wbox displays a window with a message text and a number of buttons. The selected button (number 1..) is returned as Errorlevel.
::
:: The box is displayed in the middle of the command window. If the console window is minimized or hidden, the box will show in the middle of the desktop.
::
:: Window title, message text and button caption are specified as command parameters, for example:
::
::      Wbox "Backup" "Accounting data saved" "Continue;Quit"
::
:: General syntax:
::
::      Wbox title message buttons [options]
::
:: The title will show in the window's title bar. If you leave it empty (""), "Wbox" is inserted.
::
:: The message will be wrapped to several lines if necassary. The caret symbol (^) forces a line feed (alternative token see option /CR). Wbox tries to produce an optimal sizing; however, options are available for adjustments.
::
:: The buttons must be separated by semicolons, for example: "Yes;No;Cancel"
::
:: Each of the three command arguments should be enclosed in (double) quote marks to make sure that each is interpreted as one parameter unit.
::
:: Options (a value requires an equal sign):
::
::      /AL    align left (default: message text centered)
::      /OT    on top: keep window on top
::      /TM=   time-out (seconds), see notes below
::      /DB=   default button (will have the focus at start), default: /DB=1
::      /TL=   forces (space for) the given number of text lines, e.g. /TL=3
::      /FS=   font size; default: /FS=9
::      /FF=   fixed spaced font (Lucida Console)
::      /CR=   sets the line break token, default: /CR=^
::      /BW=   button width (pixels); default: auto
::      /WW=   minimum window width (pixels), default: /WW=200
::             (normally, the width is calculated acc. to the button width)
::      /BG=   background colour, hexadecimal with hash sign (same as for HTML);
::             example: /BG=#FFCCBB
::      /FC=   font colour, same code as for /BG, default: /FC=#000000
::      /DX=   hotizontal window position plus/minus pixels (example /dx=+100)
::      /DY=   vertical window position plus/minus pixels (example /dy=-80)
::
:: Options (case ignored) must be separated by space(s), no commas! No space within an option!
::
:: The exit code (Errorlevel) is the number of the selected button (1..).
:: Zero is returned if the Wbox window is closed by [x] (title bar) or Escape.
::
:: Syntax errors produce a Wbox with error information, erorlevel 255.
:: Once you tested the command sucessfully, this error will not occur, so you need not check it in your regular batch file.
::
::
:: Timer:
::
:: Option /TM starts a timer with the given number of seconds, for example, /TM=6. At time-out the window closes returning the default button number as errorlevel. The timer is halted when a key is pressed (not Escape or Enter), or a mouse mouse button is clicked in the window (not on a button).
::
:: The countdown can be displayed by inserting the "$" token in one of the buttons, for example: "Cancel -$-".
::
::
:: Keyboard handling:
::
:: Change focus with TAB or Shift+TAB. Initially, the focus is set to the button specified by option /DB.
::
:: Enter selects the button with the focus, and closes the window.
:: Escape exits with errorlevel zero.
::
::
:: Special text symbols:
::
:: Caret (^) or alternative token forces a line feed.
:: Two single quote marks ('') are converted to one double quote mark.

POPD

PUSHD "%TOPDIR%"

REM First, reset our RC
SET ReturnCode=

REM Colour looks out of place
REM "%HSBT_WBOX%" "GO AGAIN?" "%Username%, ^^would you like to start over?" "Oath^!;Nah, I'm done ($)" /FS=12 /TM=30 /BG=#333333 /FC=#41AA52 /DB=2 /WW=375 /BW=150
"%HSBT_WBOX%" "GO AGAIN?" "%Username%, ^^would you like to start over?" "Yes;No ($)" /FS=12 /DB=2 /WW=375 /BW=150

SET ReturnCode=%ErrorLevel%
ECHO SET ReturnCode to %ErrorLevel% >%DBGMAC% && ECHO.>%DBGMAC%

IF "%ReturnCode%"=="2" ECHO %Username% selected to definitely git out >%DBGMAC% && ECHO.>%DBGMAC% && GOTO ENDTIME
IF "%ReturnCode%"=="1" ECHO %Username% opted to NOT Exit >%DBGMAC% && ECHO.>%DBGMAC% && GOTO CHOICEKING
IF "%ReturnCode%"=="0" ECHO ReturnCode is 0^! >%DBGMAC% && GOTO ERROR

:ENDTIME
SET "ENDTIME=%TIME%"

REM Change formatting for the start and end times
FOR /F "tokens=1-4 delims=:.," %%a IN ("%STARTTIME%") DO SET /A "start=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"

FOR /F "tokens=1-4 delims=:.," %%a IN ("%ENDTIME%") DO SET /A "end=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"

REM Calculate the elapsed time by subtracting values
SET /A elapsed=end-start

REM Format the results for output
SET /A hh=elapsed/(60*60*100), rest=elapsed%%(60*60*100), mm=rest/(60*100), rest%%=60*100, ss=rest/100, cc=rest%%100
IF %hh% lss 10 SET "hh=0%hh%"
IF %mm% lss 10 SET "mm=0%mm%"
IF %ss% lss 10 SET "ss=0%ss%"
IF %cc% lss 10 SET "cc=0%cc%"

REM SET DURATION=%hh%:%mm%:%ss%,%cc%
SET "DURATION=%hh%hrs %mm%mins %ss%secs"

IF "%hh%"=="00" (
 IF "%mm%"=="00" (
  SET "FANCYDURATION=%ss%secs"
  GOTO TIMINGS
 )
 SET "FANCYDURATION=%mm%mins, %ss%secs"
 GOTO TIMINGS
)

REM Else
SET "FANCYDURATION=%hh%hrs, %mm%mins, %ss%secs"
GOTO TIMINGS


:TIMINGS
REM -----------------------------------------------------------------------------------
REM # Some more fancy Formatting FOR CLI window and logfile to close.
ECHO ------------------------------------------------------------------------------->%DBGMAC%
REM CLS
REM # Display both a start time and end time and log to file.
ECHO %ACT1% started at %STARTTIME% >%DBGMAC%
ECHO %ACT2%d at %ENDTIME% >%DBGMAC%
ECHO Time to complete: %FANCYDURATION% >%DBGMAC%
ECHO.>%DBGMAC%

REM -----------------------------------------------------------------------------------
REM If the error log doesn't exist, skip to the E-end
IF NOT EXIST "%ERRLOG%" GOTO EEND

REM -----------------------------------------------------------------------------------
REM If it does, set it's filesize in bytes as "FSZ"
FOR %%G IN ("%ERRLOG%") DO SET "FSZ=%%~zG"

REM Erase the empty errors file (first check if it's zero bytes)
IF %FSZ% EQU 0 GOTO ERREQU0

REM -----------------------------------------------------------------------------------
REM Then, if the size is GTR than 1, do some more fancy printing, then skip to EEND
IF %FSZ% GTR 1 GOTO ERRGTR1
GOTO ERRLSS1

:ERRGTR1
ECHO The following errors occurred^: >%DBGMAC%
TYPE "%ERRLOG%" >%DBGMAC%
ECHO.>%ERRMAC%
ECHO The error log can be found at "%ERRLOG%" >%DBGMAC%
ECHO.>%DBGMAC%
GOTO EEND

:ERRLSS1
REM -----------------------------------------------------------------------------------
REM We found an error log, but it's size was ID'd as equal to or less-than 1 in above IF statement, so print this to logs
ECHO No known errors occurred. >%DBGMAC%
ECHO.>%DBGMAC%
ECHO However, an error log was found at "%ERRLOG%", >%DBGMAC%
ECHO it is recommended that you check this file if you encounter problems >%DBGMAC%
ECHO.>%DBGMAC%
GOTO EEND

:ERREQU0
DEL "%ERRLOG%" /q >%DBGMAC%
ECHO.>%DBGMAC%
GOTO EEND

REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
REM This is the end of all things
REM -----------------------------------------------------------------------------------
:EEND

ECHO The following logs were generated:>%DBGMAC%
ECHO.>%DBGMAC%
IF EXIST "%LOGFILE%" ECHO - "%LOGFILE%">%DBGMAC%
IF EXIST "%DEBUGLOG%" ECHO - "%DEBUGLOG%">%DBGMAC%
IF EXIST "%ERRLOG%" ECHO - "%ERRLOG%">%DBGMAC%
ECHO.>%DBGMAC%

ECHO.
CALL :c F8 "-----------------------------------------"
ECHO.
CALL :c F8 "| "
CALL :c F0 "Start time   : "
CALL :c 2F "%STARTTIME%           "
CALL :c F8 " |"
ECHO.
CALL :c F8 "| "
CALL :c F0 "Finish time  : "
CALL :c 9F "%ENDTIME%           "
CALL :c F8 " |"
ECHO.
CALL :c F8 "| "
CALL :c F0 "Duration     : "
CALL :c 5F " %DURATION%  "
CALL :c F8 " |"
ECHO.
CALL :c F8 "-----------------------------------------"
ECHO.
ECHO.

CALL :cleanupColorPrint

REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
REM -----------------------------------------------------------------------------------
ECHO Ending local expansion >%DBGMAC%
ECHO. >%DBGMAC%
ECHO %APPNAME%>%DBGMAC%
ECHO %CPR%>%DBGMAC%
ECHO ===============================================================================>%DBGMAC%

REM Silently erase all of our temporary files
CALL :ERASETMPFILES

REM End our master local expansion.
ENDLOCAL

REM Halt output
PAUSE

REM Clear screen
CLS

REM -----------------------------------------------------------------------------------
REM Something witty, wait, I had something for this . . .
REM -----------------------------------------------------------------------------------

REM THE REAL END
EXIT /B

REM Windows CLI colour matrix

REM 0 = Black       8 = Gray
REM 1 = Blue        9 = Light Blue
REM 2 = Green       A = Light Green
REM 3 = Aqua        B = Light Aqua
REM 4 = Red         C = Light Red
REM 5 = Purple      D = Light Purple
REM 6 = Yellow      E = Light Yellow
REM 7 = White       F = Bright White

REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
REM -----------------------------------------------------------------------------------------------------------------------------------------------------------------------

REM          S U B         -         R O U T I N E                  C I T Y

:SUB_ROUTINES
REM -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

REM -----------------------------------------------------------------------------------
REM Colour functions by SO user 'dbenham'

:c
SetLocal enableDelayedExpansion
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:colourPrint Color  Str  [/n]
SetLocal
SET "s=%~2"
CALL :colourPrintVar %1 s %3
EXIT /B

:colourPrintVar  Color  StrVar  [/n]
IF NOT DEFINED DEL CALL :initColorPrint
REM IF NOT DEFINED DEL (
REM 	FOR /f "usebackq" %%A IN (`"FOR %%B IN (1) DO REM"`) DO SET "DEL=%%A %%A"
REM 	<NUL >"%TEMP%\'" SET /p "=."
REM 	SUBST ': "%TEMP%" >NUL
REM )
SetLocal enableDelayedExpansion
PUSHD .
':
CD \
SET "s=!%~2!"
:: The single blank line within the following IN() clause is critical - DO NOT REMOVE
FOR %%n IN (^"^

^") DO (
  SET "s=!s:\=%%~n\%%~n!"
  SET "s=!s:/=%%~n/%%~n!"
  SET "s=!s::=%%~n:%%~n!"
)
FOR /f delims^=^ eol^= %%s IN ("!s!") DO (
  IF "!" EQU "" SetLocal disableDelayedExpansion
  IF %%s==\ (
    FINDSTR /a:%~1 "." "\'" NUL
    <NUL SET /p "=%DEL%%DEL%%DEL%"
  ) ELSE IF %%s==/ (
    FINDSTR /a:%~1 "." "/.\'" NUL
    <NUL SET /p "=%DEL%%DEL%%DEL%%DEL%%DEL%"
  ) ELSE (
    >colourPrint.txt (ECHO %%s\..\')
    FINDSTR /a:%~1 /f:colourPrint.txt "."
    <NUL SET /p "=%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%"
  )
)
IF /i "%~3"=="/n" ECHO.
POPD

EXIT /B

:initColorPrint
FOR /f %%A IN ('"PROMPT $H&FOR %%B IN (1) DO REM"') DO SET "DEL=%%A %%A"
<NUL >"%TEMP%\'" SET /p "=."
SUBST ': "%TEMP%" >NUL
EXIT /B


:cleanupColorPrint
2>NUL DEL "%TEMP%\'"
2>NUL DEL "%TEMP%\colourPrint.txt"
>NUL SUBST ': /d
EXIT /B

REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
REM -----------------------------------------------------------------------------------
:SIZEDIVIDE val_dividend val_divisor [ref_result] [ref_remainder]
REM Divide a huge number exceeding the 32-bit limitation
REM by a 32-bit number in the range from 1 to 1000000000;
REM the result might also exceed the 32-bit limitation.
SETLOCAL EnableDelayedExpansion
SET "DIVIDEND=%~1"
SET "DIVISOR=%~2"
SET "QUOTIENT=%~3"
SET "REMAINDER=%~4"

REM Check whether dividend and divisor are given:
IF NOT DEFINED DIVIDEND (
    >&2 ECHO(Too few arguments, dividend missing^^!
    EXIT /B 2
) ELSE IF NOT DEFINED DIVISOR (
    >&2 ECHO(Too few arguments, divisor missing^^!
    EXIT /B 2
)
REM Check whether dividend is purely numeric:
FOR /F "tokens=* delims=0123456789" %%N IN ("!DIVIDEND!") DO (
    IF NOT "%%N"=="" (
        >&2 ECHO(Dividend must be numeric^^!
        EXIT /B 2
    )
)
REM Convert divisor to numeric value without leading zeros:
FOR /F "tokens=* delims=0" %%N IN ("%DIVISOR%") DO SET "DIVISOR=%%N"
SET /A DIVISOR+=0
REM Check divisor against its range:
IF %DIVISOR% LEQ 0 (
    >&2 ECHO(Divisor value must be positive^^!
    EXIT /B 1
) ELSE IF %DIVISOR% GTR 1000000000 (
    >&2 ECHO(Divisor value exceeds its limit^^!
    EXIT /B 1
)
SET "COLL=" & SET "NEXT=" & SET /A INDEX=0
REM Do a division digit by digit as one would do it on paper:
:SIZELOOP
IF "!DIVIDEND:~%INDEX%,1!"=="" GOTO :SIZECONT
SET "NEXT=!NEXT!!DIVIDEND:~%INDEX%,1!"
REM Remove trailing zeros as such denote octal numbers:
FOR /F "tokens=* delims=0" %%N IN ("!NEXT!") DO SET "NEXT=%%N"
SET /A NEXT+=0
SET /A PART=NEXT/DIVISOR
SET "COLL=!COLL!!PART!"
SET /A NEXT-=PART*DIVISOR
SET /A INDEX+=1
GOTO :SIZELOOP
:SIZECONT
REM Remove trailing zeros as such denote octal numbers:
FOR /F "tokens=* delims=0" %%N IN ("%COLL%") DO SET "COLL=%%N"
IF NOT DEFINED COLL SET "COLL=0"
REM Set return variables or display result if none are given:
IF DEFINED QUOTIENT (
    IF DEFINED REMAINDER (
        ENDLOCAL
        SET "%REMAINDER%=%NEXT%"
    ) ELSE (
        ENDLOCAL
    )
    SET "%QUOTIENT%=%COLL%"
) ELSE (
    ENDLOCAL
    ECHO(%COLL%
)
EXIT /B
REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =


REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
REM -----------------------------------------------------------------------------------

:RESET_COUNTS_PERCS
SET /A PERCOUT=0
SET /A TOTALPERC=0
SET /A TOTALPERC1=0
SET /A COUNT=0
EXIT /B

REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:TOTALPERC
IF !FILEAMT! GTR 1 (
	SET /A COUNT += 1
	SET FILENUM=!COUNT!
	ECHO FILENUM IS !FILENUM! out of !FILEAMT!>%DBGMAC%
	ECHO.>%DBGMAC%
	SET /A "FILENUM1=FILENUM*100"
	ECHO FILENUM1 = !FILENUM1! >%DBGMAC%
	ECHO.>%DBGMAC%
	SET /A "TOTALPERC=FILENUM1/FILEAMT"
	ECHO TOTALPERC IS !TOTALPERC!%% >%DBGMAC%
	ECHO.>%DBGMAC%
)
EXIT /B

REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:TOTALSIZEIN
REM Go through each file, add their rounded MB values up.
ECHO Adding file sizes . . . >%DBGMAC%
ECHO.>%DBGMAC%
FOR /F "usebackq tokens=* delims=" %%G IN ("%temp%\userselectedfiles.tmp") DO (
	REM CALL Our standard file constants
	SET "FILE=%%G"
	SET "FILED=%%~dpG"
	SET "FILEN=%%~nG"
	SET "FILEX=%%~xG"
	SET "FILEZ=%%~zG"
	CALL :TOTALPERC
	CALL :DYNANMICFILE
	SET RUNNINGSIZE=0
	SET /A RUNNINGSIZE += MBYTES
	ECHO !RUNNINGSIZE!>>"runningsize.tmp"
	ECHO Added !RUNNINGSIZE!MB so far... >%DBGMAC%
	ECHO.>%DBGMAC%
)

REM Because the loop is finished (i.e no more files) then RUNNINGSIZE is now more like a total size.
REM Set this.
SET "TOTALSIZEIN=!RUNNINGSIZE!"

EXIT /B

:REMAINSIZE
REM Now, we subtract the current MB size from the total.
REM We also need to add the current files size to the total
REM in order for us to arrive at 0 when there are no files remaining

REM This can go in our main program FOR loop
REM FOR /F "usebackq tokens=* delims=" %%G IN ("%temp%\userselectedfiles.tmp") DO (
	SET /A REMAINSIZE=TOTALSIZEIN+MBYTES
	SET /A REMAINSIZE -= MBYTES
	ECHO !REMAINSIZE!>>"remainsize.tmp"
	ECHO !REMAINSIZE!MB remaining... >%DBGMAC%
	ECHO.>%DBGMAC%
REM )

EXIT /B

REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:DURATION_START
SET "DURATION_START=!TIME!"

EXIT /B
REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:DURATION_END
SET "DURATION_END=!TIME!"

REM Change formatting for the start and end times
FOR /F "tokens=1-4 delims=:.," %%a IN ("%DURATION_START%") DO SET /A "DUR_start=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"

FOR /F "tokens=1-4 delims=:.," %%a IN ("%DURATION_END%") DO SET /A "DUR_end=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"

REM Calculate the elapsed time by subtracting values
SET /A DUR_elapsed=DUR_end-DUR_start

REM Format the results for output
SET /A DUR_hh=DUR_elapsed/(60*60*100), DUR_rest=DUR_elapsed%%(60*60*100), DUR_mm=DUR_rest/(60*100), DUR_rest%%=60*100, DUR_ss=DUR_rest/100, DUR_cc=DUR_rest%%100
IF %DUR_hh% lss 10 SET "DUR_hh=0%DUR_hh%"
IF %DUR_mm% lss 10 SET "DUR_mm=0%DUR_mm%"
IF %DUR_ss% lss 10 SET "DUR_ss=0%DUR_ss%"
IF %DUR_cc% lss 10 SET "DUR_cc=0%DUR_cc%"

REM SET DURATION=%DUR_hh%:%DUR_mm%:%DUR_ss%,%DUR_cc%
SET "DURATION_=%DUR_hh%hrs %DUR_mm%mins %DUR_ss%secs"

SET "FANCYDURATION_=%DUR_hh%hrs %DUR_mm%mins %DUR_ss%secs"
IF "%DUR_hh%"=="00" (
	SET "FANCYDURATION_=%DUR_mm%mins %DUR_ss%secs"
	IF "%DUR_mm%"=="00" (
		SET "FANCYDURATION_=%DUR_ss%secs"
	)
)

EXIT /B
REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:DYNANMICFILE
ECHO FILE EXISTS AS !FILE!>%DBGMAC%
ECHO FILED SET AS !FILED!>%DBGMAC%
ECHO FILEN SET AS !FILEN!>%DBGMAC%
ECHO FILEX SET AS !FILEX!>%DBGMAC%
ECHO FILEZ SET AS !FILEZ!>%DBGMAC%
ECHO.>%DBGMAC%

REM Useless now
REM SET /A FSIZE1=FILEZ/1024
REM ECHO FSIZE1 SET AS !FSIZE1!
REM SET /A FSIZE=FSIZE1/1024
REM ECHO FSIZE SET AS !FSIZE!
REM SET /A FSIZEG=FSIZE/1024
REM ECHO FSIZEG SET AS !FSIZEG!
REM ECHO.

SET "BYTES=!FILEZ!">%DBGMAC%

REM Define constants here:
SET /A DIVISOR=1024 & rem (1024 Bytes = 1 KBytes, 1024 KBytes = 1 MByte,...)
SET "ROUNDUP=#" & rem (SET to non-empty value to round up results)

IF NOT DEFINED BYTES SET "BYTES=0">%DBGMAC%
REM Display result in Bytes and divide it to get KBytes, MBytes, etc.:
CALL :SIZEDIVIDE !BYTES! 1 RESULT>%DBGMAC%
ECHO Bytes:    !RESULT!>%DBGMAC%
CALL :SIZEDIVIDE !RESULT! !DIVISOR! RESULT REST
IF DEFINED ROUNDUP if 0!REST! GTR 0 SET /A RESULT+=1
ECHO KBytes:    !RESULT!>%DBGMAC%
SET KBYTES=!RESULT!
ECHO SET KBYTES AS !KBYTES!>%DBGMAC%
CALL :SIZEDIVIDE !RESULT! !DIVISOR! RESULT REST
IF DEFINED ROUNDUP if 0!REST! GTR 0 SET /A RESULT+=1
ECHO MBytes:    !RESULT!>%DBGMAC%
SET MBYTES=!RESULT!
ECHO SET MBYTES AS !MBYTES!>%DBGMAC%
ECHO.>%DBGMAC%

REM GB is virtually useless without decimals and better rounding.
REM CALL :SIZEDIVIDE !RESULT! !DIVISOR! RESULT REST
REM IF DEFINED ROUNDUP if 0!REST! GTR 0 SET /A RESULT+=1
REM ECHO GBytes:    !RESULT!

EXIT /B

REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:COUNTLINES
ECHO.>%DBGMAC%
ECHO Counting lines... >%DBGMAC%
ECHO.>%DBGMAC%
ECHO Using SET "CMD=findstr /R /N "^^" "%temp%\userselectedfiles.tmp" >%DBGMAC%
ECHO piped with find /C ":"">%DBGMAC%
ECHO.>%DBGMAC%

SET "CMD=findstr /R /N "^^" "%temp%\userselectedfiles.tmp" | find /C ":""

ECHO Running FOR loop on file>%DBGMAC%
ECHO.>%DBGMAC%
FOR /F %%A IN ('!CMD!') DO (
	SET FILEAMT=%%A
	ECHO Number of lines in selection = !FILEAMT!>%DBGMAC%
	ECHO.>%DBGMAC%
)
EXIT /B

REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:OUTFILESIZE
ECHO OUTFILEZ SET AS !OUTFILEZ!>%DBGMAC%
ECHO.>%DBGMAC%

SET "OUTBYTES=!OUTFILEZ!">%DBGMAC%

REM Define constants here:
SET /A DIVISOR=1024 & rem (1024 Bytes = 1 KBytes, 1024 KBytes = 1 MByte,...)
SET "ROUNDUP=#" & rem (SET to non-empty value to round up results)

IF NOT DEFINED OUTBYTES SET "OUTBYTES=0">%DBGMAC%
REM Display result in Bytes and divide it to get KBytes, MBytes, etc.:
CALL :SIZEDIVIDE !OUTBYTES! 1 OUTRESULT>%DBGMAC%
ECHO Bytes:    !OUTRESULT!>%DBGMAC%
CALL :SIZEDIVIDE !OUTRESULT! !DIVISOR! OUTRESULT OUTREST
IF DEFINED ROUNDUP if 0!OUTREST! GTR 0 SET /A OUTRESULT+=1
ECHO KBytes:    !OUTRESULT!>%DBGMAC%
SET OUTKBYTES=!OUTRESULT!
ECHO SET OUTKBYTES AS !OUTKBYTES!>%DBGMAC%
CALL :SIZEDIVIDE !OUTRESULT! !DIVISOR! OUTRESULT OUTREST
IF DEFINED ROUNDUP if 0!OUTREST! GTR 0 SET /A OUTRESULT+=1
ECHO MBytes:    !OUTRESULT!>%DBGMAC%
SET OUTMBYTES=!OUTRESULT!
ECHO SET OUTMBYTES AS !OUTMBYTES!>%DBGMAC%
ECHO.>%DBGMAC%

REM These need to go together
REM EXIT /B

:SAVEDPERCENT
SET INSIZE=!RESULT!
ECHO INSIZE = !INSIZE!>%DBGMAC%
SET /A OUTSIZE=INSIZE-OUTRESULT
ECHO OUTSIZE = !INSIZE!-!OUTRESULT! = !OUTSIZE!>%DBGMAC%
SET /A OUTPERC=OUTSIZE*100
ECHO OUTPERC = !OUTSIZE!*100 = !OUTPERC!>%DBGMAC%
SET /A OUTPERC=OUTPERC/INSIZE
ECHO OUTPERC = !OUTPERC!/!INSIZE! = !OUTPERC!>%DBGMAC%
ECHO.>%DBGMAC%
ECHO You saved approx. !OUTSIZEKB! KB ^(!OUTPERC!%%^). >%DBGMAC%
EXIT /B
REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:OUTFILESIZEKB
ECHO OUTFILEZKB SET AS !OUTFILEZKB!>%DBGMAC%
ECHO.>%DBGMAC%

SET "OUTBYTESKB=!OUTFILEZKB!">%DBGMAC%

REM Define constants here:
SET /A DIVISOR=1024 & rem (1024 Bytes = 1 KBytes, 1024 KBytes = 1 MByte,...)
SET "ROUNDUP=#" & rem (SET to non-empty value to round up results)

IF NOT DEFINED OUTBYTESKB SET "OUTBYTESKB=0">%DBGMAC%
REM Display result in Bytes and divide it to get KBytes, MBytes, etc.:
CALL :SIZEDIVIDE !OUTBYTESKB! 1 OUTRESULTKB>%DBGMAC%
ECHO Bytes:    !OUTRESULTKB!>%DBGMAC%
CALL :SIZEDIVIDE !OUTRESULTKB! !DIVISOR! OUTRESULTKB OUTRESTKB
IF DEFINED ROUNDUP if 0!OUTRESTKB! GTR 0 SET /A OUTRESULTKB+=1
ECHO KBytes:    !OUTRESULTKB!>%DBGMAC%
SET OUTKBYTES=!OUTRESULTKB!
ECHO SET OUTKBYTES AS !OUTKBYTES!>%DBGMAC%
CALL :SIZEDIVIDE !OUTRESULTKB! !DIVISOR! OUTRESULTKB OUTRESTKB
IF DEFINED ROUNDUP if 0!OUTRESTKB! GTR 0 SET /A OUTRESULTKB+=1
ECHO MBytes:    !OUTRESULTKB!>%DBGMAC%
SET OUTMBYTES=!OUTRESULTKB!
ECHO SET OUTMBYTES AS !OUTMBYTES!>%DBGMAC%
ECHO.>%DBGMAC%

REM These need to go together
REM EXIT /B

:SAVEDPERCENTKB
SET INSIZEKB=!KBYTES!
ECHO INSIZEKB = !INSIZEKB!>%DBGMAC%
SET /A OUTSIZEKB=INSIZEKB-OUTKBYTES
ECHO OUTSIZEKB = !INSIZEKB!-!OUTKBYTES! = !OUTSIZEKB!>%DBGMAC%
SET /A OUTPERCKB=OUTSIZEKB*100
ECHO OUTPERCKB = !OUTSIZEKB!*100 = !OUTPERCKB!>%DBGMAC%
SET /A OUTPERCKB=OUTPERCKB/INSIZEKB
ECHO OUTPERCKB = !OUTPERCKB!/!INSIZEKB! = !OUTPERCKB!>%DBGMAC%
ECHO.>%DBGMAC%
ECHO You saved approx. !OUTPERCKB!%% >%DBGMAC%
EXIT /B

REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:REPLACEUSF_ALL
ECHO Replacing data...>%DBGMAC%
ECHO.>%DBGMAC%
"%FNR%" --cl --dir "%temp%" --fileMask "userselectedfiles.tmp" --find """ """ --replace "\n"
SET "q=^"
CLS
ECHO ===============================================================================
CALL :c 97 "%APPNAME%" /n
ECHO %CPR%
ECHO ===============================================================================
EXIT /B

REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:REPLACEUSF_MULTI
ECHO We detected more than 1 line in "%temp%\userselectedfiles.tmp">%DBGMAC%
ECHO.>%DBGMAC%
ECHO Continuing...>%DBGMAC%
ECHO.>%DBGMAC%

ECHO Replacing data...>%DBGMAC%
ECHO.>%DBGMAC%
"%FNR%" --cl --dir "%temp%" --fileMask "userselectedfiles.tmp" --find "REM """ --replace ""
SET "q=^"
CLS
ECHO ===============================================================================
CALL :c 97 "%APPNAME%" /n
ECHO %CPR%
ECHO ===============================================================================

ECHO Replacing data...>%DBGMAC%
ECHO.>%DBGMAC%
"%FNR%" --cl --dir "%temp%" --fileMask "userselectedfiles.tmp" --find """\n" --replace ""
SET "q=^"
CLS
ECHO ===============================================================================
CALL :c 97 "%APPNAME%" /n
ECHO %CPR%
ECHO ===============================================================================
EXIT /B

REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:REPLACEUSF_SINGLEFILE
ECHO Replacing data...>%DBGMAC%
ECHO.>%DBGMAC%
ECHO "%FNR%" --cl --dir "%temp%" --fileMask "userselectedfiles.tmp" --find "REM """ --replace "" >%DBGMAC%
ECHO.>%DBGMAC%
"%FNR%" --cl --dir "%temp%" --fileMask "userselectedfiles.tmp" --find "REM """ --replace ""
SET "q=^"
CLS
ECHO ===============================================================================
CALL :c 97 "%APPNAME%" /n
ECHO %CPR%
ECHO ===============================================================================

ECHO Replacing data...>%DBGMAC%
ECHO.>%DBGMAC%
ECHO "%FNR%" --cl --dir "%temp%" --fileMask "userselectedfiles.tmp" --find """\n" --replace "" >%DBGMAC%
ECHO.>%DBGMAC%
"%FNR%" --cl --dir "%temp%" --fileMask "userselectedfiles.tmp" --find """\n" --replace ""
SET "q=^"
CLS
ECHO ===============================================================================
CALL :c 97 "%APPNAME%" /n
ECHO %CPR%
ECHO ===============================================================================

ECHO IF !FILEAMT! LEQ 1 SET /p SINGLEINPUT=<"%temp%\userselectedfiles.tmp" >%DBGMAC%
ECHO.>%DBGMAC%
IF !FILEAMT! LEQ 1 SET /p SINGLEINPUT=<"%temp%\userselectedfiles.tmp"

EXIT /B

REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:ERASETMPFILES
REM Erase temp log files before popping out of DP1
REM Suppressed output has to be sent to a NUL device
REM Fixed names
IF EXIST "%TMPL%" DEL "%TMPL%" /q /s >NUL 2>&1
IF EXIST "%TMPD%" DEL "%TMPD%" /q /s >NUL 2>&1
IF EXIST "%~dp0_" DEL "%~dp0_" /q /s >NUL 2>&1
IF EXIST "%~dp0o" DEL "%~dp0o" /q /s >NUL 2>&1
IF EXIST "%~dp0i" DEL "%~dp0i" /q /s >NUL 2>&1
IF EXIST "%~dp0y" DEL "%~dp0y" /q /s >NUL 2>&1
IF EXIST "!FILED!debuglog.tmp" DEL "!FILED!debuglog.tmp" /q /s >NUL 2>&1
IF EXIST "!FILED!errorlog.tmp" DEL "!FILED!errorlog.tmp" /q /s >NUL 2>&1
IF EXIST "!FILED!input.temp" DEL "!FILED!input.temp" /q /s >NUL 2>&1
IF EXIST "!FILED!tmplog.tmp" DEL "tmplog.tmp" /q /s >NUL 2>&1
IF EXIST "!FILED!_" DEL "!FILED!_" /q /s >NUL 2>&1
IF EXIST "!FILED!o" DEL "!FILED!o" /q /s >NUL 2>&1
IF EXIST "!FILED!i" DEL "!FILED!i" /q /s >NUL 2>&1
IF EXIST "!FILED!y" DEL "!FILED!y" /q /s >NUL 2>&1
IF EXIST "%TOPDIR%\debuglog.tmp" DEL "%TOPDIR%\debuglog.tmp" /q /s >NUL 2>&1
IF EXIST "%TOPDIR%\errorlog.tmp" DEL "%TOPDIR%\errorlog.tmp" /q /s >NUL 2>&1
IF EXIST "%TOPDIR%\input.temp" DEL "%TOPDIR%\input.temp" /q /s >NUL 2>&1
IF EXIST "%TOPDIR%\tmplog.tmp" DEL "%TOPDIR%\tmplog.tmp" /q /s >NUL 2>&1
IF EXIST "%TOPDIR%\_" DEL "%TOPDIR%\_" /q /s >NUL 2>&1
IF EXIST "%TOPDIR%\o" DEL "%TOPDIR%\o" /q /s >NUL 2>&1
IF EXIST "%TOPDIR%\i" DEL "%TOPDIR%\i" /q /s >NUL 2>&1
IF EXIST "%TOPDIR%\y" DEL "%TOPDIR%\y" /q /s >NUL 2>&1
IF EXIST "debuglog.tmp" DEL "debuglog.tmp" /q /s >NUL 2>&1
IF EXIST "errorlog.tmp" DEL "errorlog.tmp" /q /s >NUL 2>&1
IF EXIST "input.temp" DEL "input.temp" /q /s >NUL 2>&1
IF EXIST "tmplog.tmp" DEL "tmplog.tmp" /q /s >NUL 2>&1
IF EXIST "tmp.size" DEL "tmp.size" /q /s >NUL 2>&1
IF EXIST "remainsize.tmp" DEL "remainsize.tmp" /q /s >NUL 2>&1
REM IF EXIST "%temp%\userselectedfile.tmp" DEL "%temp%\userselectedfile.tmp" /q /s >NUL 2>&1
REM IF EXIST "%temp%\userselectedfiles.tmp" DEL "%temp%\userselectedfiles.tmp" /q /s >NUL 2>&1

REM Wildcard names
DEL "!FILED!*.cache" /q /s >NUL 2>&1
DEL "!FILED!*.mpc" /q /s >NUL 2>&1
DEL "!FILED!*.miff" /q /s >NUL 2>&1
DEL "%TOPDIR%\*.cache" /q /s >NUL 2>&1
DEL "%TOPDIR%\*.mpc" /q /s >NUL 2>&1
DEL "%TOPDIR%\*.miff" /q /s >NUL 2>&1
DEL "*.cache" /q /s >NUL 2>&1
DEL "*.mpc" /q /s >NUL 2>&1
DEL "*.miff" /q /s >NUL 2>&1

EXIT /B

REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:INPUTFOLDERBROWSER
ECHO please select your input folder . . . >%DBGMAC%
ECHO.>%DBGMAC%

"%DODBEXE%" "%CD%" "%Username%, please select your input folder" >i
(
SET /p CHOSENDIR=
) <i

IF EXIST "i" DEL "i" /q /s >NUL 2>&1

ECHO Input folder chosen as^:
ECHO %CHOSENDIR% >%DBGMAC%
ECHO.>%DBGMAC%

REM DIR "%CHOSENDIR%" /s /b /A:-D > %temp%\userselectedfiles.tmp
REM Removed /s switch from these DIR commands to avoid unwanted recursions
PUSHD "%CHOSENDIR%"
IF EXIST "%temp%\userselectedfiles.tmp" DEL "%temp%\userselectedfiles.tmp" /q /s >NUL 2>&1
FOR /R %%G IN (*.%sFileType1%) DO ECHO %%G>> "%temp%\userselectedfiles.tmp"
FOR /R %%G IN (*.%sFileType2%) DO ECHO %%G>> "%temp%\userselectedfiles.tmp"
FOR /R %%G IN (*.%sFileType3%) DO ECHO %%G>> "%temp%\userselectedfiles.tmp"
FOR /R %%G IN (*.%sFileType4%) DO ECHO %%G>> "%temp%\userselectedfiles.tmp"
FOR /R %%G IN (*.%sFileType5%) DO ECHO %%G>> "%temp%\userselectedfiles.tmp"
FOR /R %%G IN (*.%sFileType6%) DO ECHO %%G>> "%temp%\userselectedfiles.tmp"
FOR /R %%G IN (*.%sFileType7%) DO ECHO %%G>> "%temp%\userselectedfiles.tmp"
FOR /R %%G IN (*.%sFileType8%) DO ECHO %%G>> "%temp%\userselectedfiles.tmp"
FOR /R %%G IN (*.%sFileType9%) DO ECHO %%G>> "%temp%\userselectedfiles.tmp"
FOR /R %%G IN (*.%sFileType10%) DO ECHO %%G>> "%temp%\userselectedfiles.tmp"
FOR /R %%G IN (*.%sFileType11%) DO ECHO %%G>> "%temp%\userselectedfiles.tmp"
POPD
ECHO.>%DBGMAC%
EXIT /B

REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:OUTPUTFOLDERBROWSER
ECHO please select your output folder . . . >%DBGMAC%
ECHO.>%DBGMAC%

"%DODBEXE%" "%CD%" "%Username%, please select your output folder" >o
(
SET /p CHOSENDIROUT=
) <o

IF EXIST "o" DEL "o" /q /s >NUL 2>&1

IF "%ReturnCode%"=="1" GOTO ERROR
IF "%ReturnCode%"=="2" GOTO CANCELED

ECHO Output folder chosen as^:
ECHO %CHOSENDIROUT% >%DBGMAC%
ECHO.>%DBGMAC%

EXIT /B

REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:SUPPORTEDFILES_IMAGES
REM New filetype vars
SET "sFileType1=jpg"
SET "sFileType2=jpeg"
SET "sFileType3=png"
SET "sFileType4=tga"
SET "sFileType5=psd"
SET "sFileType6=pdf"
SET "sFileType7=dds"
SET "sFileType8=gif"
SET "sFileType9=psb"
SET "sFileType10=bmp"
SET "sFileType11=tif"

REM Legacy
SET "EXT1=%sFileType1%"
SET "EXT2=%sFileType2%"
SET "EXT3=%sFileType3%"
SET "EXT4=%sFileType4%"
SET "EXT5=%sFileType5%"
SET "EXT6=%sFileType6%"
SET "EXT7=%sFileType7%"
SET "EXT8=%sFileType8%"
SET "EXT9=%sFileType9%"
SET "EXT10=%sFileType10%"
SET "EXT11=%sFileType11%"
EXIT /B

REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:SUPPORTEDFILES_IMAGES_EXE
REM CALL our file browser selector function based on above SETs
"%HSBT_FTO%" "REM" "%CD%\*.%sFileType1%;*.%sFileType2%;*.%sFileType3%;*.%sFileType4%;*.%sFileType5%;*.%sFileType6%;*.%sFileType7%;*.%sFileType8%;*.%sFileType9%;*.%sFileType10%;*.%sFileType11%" "Select source images(s)" /multiselect> "%temp%\userselectedfiles.tmp"
ECHO.>%DBGMAC%
ECHO Errorlevel^: %ERRORLEVEL%>%DBGMAC%
ECHO.>%DBGMAC%
IF ERRORLEVEL 1 ECHO ERROR^! >%DBGMAC% && GOTO END
EXIT /B

REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:SUPPORTEDFILES_SOURCE
REM New filetype vars
SET "sFileType1=vmf"
SET "sFileType2=bsp"
SET "sFileType3=vtf"
SET "sFileType4=vmt"
SET "sFileType5=tga"
SET "sFileType6=mdl"
SET "sFileType7=vmx"
SET "sFileType8=vtx"
SET "sFileType9=txt"


REM Legacy
SET "EXT1=%sFileType1%"
SET "EXT2=%sFileType2%"
SET "EXT3=%sFileType3%"
SET "EXT4=%sFileType4%"
SET "EXT5=%sFileType5%"
SET "EXT6=%sFileType6%"
SET "EXT7=%sFileType7%"
SET "EXT8=%sFileType8%"
SET "EXT9=%sFileType9%"
EXIT /B

REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:SUPPORTEDFILES_SOURCE_EXE
REM CALL our file browser selector function based on above SETs
"%HSBT_FTO%" "REM" "%CD%\*.%sFileType1%;*.%sFileType2%;*.%sFileType3%;*.%sFileType4%;*.%sFileType5%;*.%sFileType6%;*.%sFileType7%;*.%sFileType8%;*.%sFileType9%" "Select source images(s)" /multiselect> "%temp%\userselectedfiles.tmp"
ECHO.>%DBGMAC%
ECHO Errorlevel^: %ERRORLEVEL%>%DBGMAC%
ECHO.>%DBGMAC%
IF ERRORLEVEL 1 ECHO ERROR^! >%DBGMAC% && GOTO END
EXIT /B

:SUPPORTEDFILES_VIDEOS
REM New filetype vars
SET "sFileType1=mkv"
SET "sFileType2=mp4"
SET "sFileType3=avi"
SET "sFileType4=mpg"
SET "sFileType5=mpeg"
SET "sFileType6=flv"
SET "sFileType7=rm"
SET "sFileType8=wmv"
SET "sFileType9=m4v"

REM Legacy
SET "EXT1=%sFileType1%"
SET "EXT2=%sFileType2%"
SET "EXT3=%sFileType3%"
SET "EXT4=%sFileType4%"
SET "EXT5=%sFileType5%"
SET "EXT6=%sFileType6%"
SET "EXT7=%sFileType7%"
SET "EXT8=%sFileType8%"
SET "EXT9=%sFileType9%"
EXIT /B

REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:SUPPORTEDFILES_VIDEOS_EXE
"%HSBT_FTO%" "REM" "%CD%\*.%sFileType1%;*.%sFileType2%;*.%sFileType3%;*.%sFileType4%;*.%sFileType5%;*.%sFileType6%;*.%sFileType7%;*.%sFileType8%;*.%sFileType9%;*.%sFileType10%" "Select source video(s)" /multiselect> "%temp%\userselectedfiles.tmp"
ECHO.>%DBGMAC%
ECHO Errorlevel^: %ERRORLEVEL%>%DBGMAC%
ECHO.>%DBGMAC%
IF ERRORLEVEL 1 ECHO ERROR^! >%DBGMAC% && GOTO END
EXIT /B

REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:SUPPORTEDFILES_SOUNDS
REM New filetype vars
SET "sFileType1=mp3"
SET "sFileType2=wav"
SET "sFileType3=mp4"
SET "sFileType4=aac"
SET "sFileType5=m4a"
SET "sFileType6=rma"
SET "sFileType7=wma"
SET "sFileType8=avi"
SET "sFileType9=mkv"
SET "sFileType10=mov"

REM Legacy
SET "EXT1=%sFileType1%"
SET "EXT2=%sFileType2%"
SET "EXT3=%sFileType3%"
SET "EXT4=%sFileType4%"
SET "EXT5=%sFileType5%"
SET "EXT6=%sFileType6%"
SET "EXT7=%sFileType7%"
SET "EXT8=%sFileType8%"
SET "EXT9=%sFileType9%"
SET "EXT10=%sFileType10%"
EXIT /B

REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:SUPPORTEDFILES_SOUNDS_EXE
"%HSBT_FTO%" "REM" "%CD%\*.%sFileType1%;*.%sFileType2%;*.%sFileType3%;*.%sFileType4%;*.%sFileType5%;*.%sFileType6%;*.%sFileType7%;*.%sFileType8%;*.%sFileType9%" "Select source audio(s)" /multiselect> "%temp%\userselectedfiles.tmp"
ECHO.>%DBGMAC%
ECHO Errorlevel^: %ERRORLEVEL%>%DBGMAC%
ECHO.>%DBGMAC%
IF ERRORLEVEL 1 ECHO ERROR^! >%DBGMAC% && GOTO END

REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:PRESUPPORTEDFILES
IF EXIST "*Thumbs.db" (
	REM Get rid of Windows nonsense before processing anything.
	REM Windows will regenerate them if and when they're needed.
	ECHO We detected Windows thumbnail cache files in this directory, removing. >%DBGMAC%
	ECHO.>%DBGMAC%
	DEL /s /F /A:S *Thumbs.db >%DBGMAC%
	ECHO.>%DBGMAC%
)
IF EXIST "*ehthumbs*.db" (
	REM Get rid of Windows nonsense before processing anything.
	REM Windows will regenerate them if and when they're needed.
	ECHO We detected EH thumbnail cache files in this directory, removing. >%DBGMAC%
	ECHO.>%DBGMAC%
	DEL /s /F /A:S *ehthumbs*.db >%DBGMAC%
	ECHO.>%DBGMAC%
)
IF EXIST "jmt_files_input.txt" ECHO !FILE!>>jmt_files_input.txt ELSE ECHO !FILE!>jmt_files_input.txt
EXIT /B

REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:STRIPSRTCOMMA
IF EXIST "!FILED!*,*.srt" (
	SET "SCHAR1=!FILEN!"
	SET "SCHAR1=!SCHAR1:,=!"
	ECHO Stripped comma name: !SCHAR1! >%DBGMAC%
	ECHO. >%DBGMAC%
	REN "%TOPDIR%!FILEN!.srt" "!SCHAR1!.srt"
	SET "FILEN=!SCHAR1!"
)
EXIT /B

REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:STRIPEXCLAIM
REM UNTESTED
IF EXIST "!FILED!*!*!FILEX!" (
	SET "XCHAR1=!FILEN!"
	SET "XCHAR1=!XCHAR1:!=!"
	ECHO Stripped exclamation name: !XCHAR1! >%DBGMAC%
	ECHO. >%DBGMAC%
	REN "!FILE!" "!FILED!!XCHAR1!!FILEX!"
	SET "FILEN=!XCHAR1!"
)
EXIT /B

REM -----------------------------------------------------------------------------------
REM = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

:RENAMECRUNCHED
REM Rename all of our .CRUNCHED files back to their proper names
REM This rename block MUST come last
ECHO Renaming files back to their original extension >%DBGMAC%
FOR /r %%x IN (*.CRUNCHED) DO REN "%%x" "*.%OUTEXT%"
FOR /r %%x IN (*.%sFileType1%ORIG) DO REN "%%x" "*.%sFileType1%"
FOR /r %%x IN (*.%sFileType2%ORIG) DO REN "%%x" "*.%sFileType2%"
FOR /r %%x IN (*.%sFileType3%ORIG) DO REN "%%x" "*.%sFileType3%"
FOR /r %%x IN (*.%sFileType4%ORIG) DO REN "%%x" "*.%sFileType4%"
FOR /r %%x IN (*.%sFileType5%ORIG) DO REN "%%x" "*.%sFileType5%"
FOR /r %%x IN (*.%sFileType6%ORIG) DO REN "%%x" "*.%sFileType6%"
FOR /r %%x IN (*.%sFileType7%ORIG) DO REN "%%x" "*.%sFileType7%"
FOR /r %%x IN (*.%sFileType8%ORIG) DO REN "%%x" "*.%sFileType8%"
FOR /r %%x IN (*.%sFileType9%ORIG) DO REN "%%x" "*.%sFileType9%"
EXIT /B