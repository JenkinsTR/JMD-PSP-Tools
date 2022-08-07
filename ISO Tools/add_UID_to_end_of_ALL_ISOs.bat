@ECHO OFF

REM Set master local expansion and command extensions.
REM USE ONCE
@SetLocal enableextensions EnableDelayedExpansion

CLS

ECHO [97m[102m===============================================================[0m
ECHO                 %~nx0                                          
ECHO             (c)2022 JMDigital. All Rights Reserved.            
ECHO [97m[102m===============================================================[0m
ECHO.

SET "UMDB=K:\GitHub\JMD-PSP-Tools\ISO Tools\bin\umdatabase.exe"

ECHO [33mWARNING:[0m Files that contain exclamation marks (^^!) will fail to process.
ECHO This will include a lot of Japan region titles, even when translated.
ECHO.
ECHO You must press any key when this process looks stuck
ECHO [97m[44m---------------------------------------------------------------[0m

FOR /R %%G IN (*.iso) DO (

	PUSHD "%%~dpG"
	
	IF NOT EXIST "%%~dpG_ISO_TEMP" MKDIR "%%~dpG_ISO_TEMP" && ECHO Creating temporary ISO folder && ECHO ------------------------------------
	
	ECHO Moving target ISO && MOVE "%%G" "%%~dpG_ISO_TEMP\%%~nxG"
	
	ECHO temp > "%%~dpG_ISO_TEMP\%%~nG.txt"
	
	PUSHD "%%~dpG_ISO_TEMP"
	ECHO Processing "%%~nxG" && "%UMDB%" "%%~dpG_ISO_TEMP\%%~nxG" > "%%~dpG_ISO_TEMP\%%~nG.txt" && ECHO [92mDone^^![0m
	POPD
	
	PUSHD "%%~dpG"
	
	SET UID=
	SET NAME=
	FOR /R %%G IN (_ISO_TEMP\*.iso) DO SET UID=%%~nG
	FOR /R %%G IN (_ISO_TEMP\*.txt) DO SET NAME=%%~nG
	
	ECHO Moving and renaming ISO && MOVE "%%~dpG_ISO_TEMP\!UID!.iso" "%%~dpG!NAME! [!UID!].iso"
	ECHO Moving and renaming txt && MOVE "%%~dpG_ISO_TEMP\!NAME!.txt" "%%~dpG!NAME! [!UID!].txt" && ECHO [92mDone^^![0m && ECHO [97m[44m---------------------------------------------------------------[0m
	

)

FOR /R %%G IN (*.txt) DO (
	FINDSTR /M /c:"Error" "%%G" >> errors.log
)

SET LOG="errors.log"
SET MAXBYTESIZE=0
FOR /F "usebackq" %%A IN ('%LOG%') DO SET LOGSIZE=%%~zA
IF %LOGSIZE% EQU %MAXBYTESIZE% (
	REM ECHO.File is ^< %MAXBYTESIZE% bytes
	IF EXIST "errors.log" DEL "errors.log" /q /s >NUL 2>&1
	GOTO END
) ELSE (
	REM ECHO.File is ^>= %MAXBYTESIZE% bytes
	GOTO ERRORS
)

:ERRORS
IF EXIST errors.log ECHO [31mThe following files have errors:[0m
IF EXIST errors.log ECHO.
IF EXIST errors.log TYPE errors.log
IF EXIST errors.log ECHO.

:END
POPD
	
PAUSE

EXIT