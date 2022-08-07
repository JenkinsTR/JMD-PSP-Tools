@ECHO OFF

REM Set master local expansion and command extensions.
REM USE ONCE
@SetLocal enableextensions EnableDelayedExpansion



SET ISOINFO=K:\GitHub\JMD-PSP-Tools\ISO Tools\bin\isoinfo.exe

:: Usage: isoinfo.exe [options] -i filename [-find [[find expr.]]
:: Options:
::         -help,-h        Print this help
::         -version        Print version info and exit
::         -debug          Print additional debug info
::         -ignore-error Ignore errors
::         -d              Print information from the primary volume descriptor
::         -f              Generate output similar to 'find .  -print'
::         -find [find expr.] Option separator: Use find command line to the right
::         -J              Print information from Joliet extensions
::         -j charset      Use charset to display Joliet file names
::         -l              Generate output similar to 'ls -lR'
::         -p              Print Path Table
::         -R              Print information from Rock Ridge extensions
::         -s              Print file size infos in multiples of sector size (2048 bytes).
::         -N sector       Sector number where ISO image should start on CD
::         -T sector       Sector number where actual session starts on CD
::         -i filename     Filename to read ISO-9660 image from
::         dev=target      SCSI target to use as CD/DVD-Recorder
::         -X              Extract all matching files to the filesystem
::         -x pathname     Extract specified file to stdout

ECHO [97m[102m===============================================================[0m
ECHO                     PSP ISO Reporting Tool
ECHO             ^(c^)2022 JMDigital. All Rights Reserved.
ECHO [97m[102m===============================================================[0m
ECHO.

FOR /R %%G IN (*.iso) DO (
	ECHO [33mProcessing %%~nG [0m
	
	ECHO =============================================================== > "%%~nG_info.txt"
	ECHO                     PSP ISO Reporting Tool >> "%%~nG_info.txt"
	ECHO             ^(c^)2022 JMDigital. All Rights Reserved. >> "%%~nG_info.txt"
	ECHO =============================================================== >> "%%~nG_info.txt"
	ECHO.

	REM Do we have a sidecar TXT from umdatabase?
	IF EXIST "%%~dpnG.txt" (
		FINDSTR /I /C:"CreationDate" "%%~dpnG.txt" > "%%~dpnG_date.umd"
		SET /P UMDDATE=<"%%~dpnG_date.umd"
		FINDSTR /c:"FileSize" "%%~dpnG.txt" > "%%~dpnG_size.umd"
		SET /P UMDSIZE=<"%%~dpnG_size.umd"
		
		IF EXIST "%%~dpnG_date.umd" DEL "%%~dpnG_date.umd" /q /s >NUL 2>&1
		IF EXIST "%%~dpnG_size.umd" DEL "%%~dpnG_size.umd" /q /s >NUL 2>&1
		
		FOR /F "tokens=1,2,3" %%G IN ("!UMDDATE!") DO (
			:: UMDDATE 1st Token: CreationDate:
			:: UMDDATE 2nd Token: 2007-07-18
			:: UMDDATE 3rd Token: 14:44:18
			SET VOLDATE2=%%~H
			SET VOLDATE3=%%~I
		)
		FOR /F "tokens=1,2,3,4,5" %%G IN ("!UMDSIZE!") DO (
			:: UMDSIZE 1st Token: FileSize:
			:: UMDSIZE 2nd Token: 863272960
			:: UMDSIZE 3rd Token: bytes
			:: UMDSIZE 4th Token: (823.28
			:: UMDSIZE 5th Token: MB)
			SET VOLSIZE2=%%~H
			
			REM Convert bytes to MB
			SET /A "VOLSIZE2=!VOLSIZE2!/1024"
			SET /A "VOLSIZE2=!VOLSIZE2!/1024"
		)
	) ELSE (
		ECHO [33mA sidecar TXT from umdatabase was not found.[0m
	)

	REM Get UID from input name and set it as VOLID
	FOR /F "tokens=1,2,3 delims=[]" %%G IN ("%%~nG") DO SET VOLID=%%H
	
	REM Print pretty header
	FOR /F "tokens=1,2,3,4 delims=()" %%K IN ("%%~nG") DO (
		ECHO --------------------------------------------------------------- >> "%%~nG_info.txt"
		ECHO Title: %%K >> "%%~nG_info.txt" && SET GAME=%%K
		ECHO Title ID: !VOLID! >> "%%~nG_info.txt"
		ECHO Region: %%L >> "%%~nG_info.txt" && SET REGION=%%L
		ECHO Languages: %%N >> "%%~nG_info.txt" && SET LANG=%%N
		ECHO Volume Creation Date: !VOLDATE2! !VOLDATE3! >> "%%~nG_info.txt"
		ECHO Volume Size: !VOLSIZE2! MB >> "%%~nG_info.txt"
		ECHO --------------------------------------------------------------- >> "%%~nG_info.txt"
		ECHO. >> "%%~nG_info.txt"
	)
	
	ECHO --------------------------------------------------------------- >> "%%~nG_info.txt"
	ECHO ISO Metadata >> "%%~nG_info.txt"
	ECHO --------------------------------------------------------------- >> "%%~nG_info.txt"
	REM Run isoinfo and send output to our info txt
	"%ISOINFO%" -d -i "%%G" >> "%%~nG_info.txt"
	ECHO. >> "%%~nG_info.txt"
	REM ECHO Reported language support: !LANG! >> "%%~nG_info.txt"
	REM ECHO. >> "%%~nG_info.txt"
	
	ECHO --------------------------------------------------------------- >> "%%~nG_info.txt"
	ECHO ISO File List >> "%%~nG_info.txt"
	ECHO --------------------------------------------------------------- >> "%%~nG_info.txt"
	REM Run isoinfo again but this time for a filelist, and send output to our info txt
	"%ISOINFO%" -l -i "%%G" >> "%%~nG_info.txt"
	REM "%ISOINFO%" -p -i "%~1" > iso4p.txt
	
	ECHO =============================================================== >> "%%~nG_info.txt"
	ECHO Generated on !DATE! at !TIME! >> "%%~nG_info.txt"
	ECHO PSP ISO Reporting Tool >> "%%~nG_info.txt"
	ECHO ^(c^)2022 JMDigital. All Rights Reserved. >> "%%~nG_info.txt"
	ECHO =============================================================== >> "%%~nG_info.txt"
	ECHO.
	ECHO [92mDone^^![0m
)

PAUSE

EXIT