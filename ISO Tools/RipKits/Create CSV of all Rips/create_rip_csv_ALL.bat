@ECHO OFF

REM We need this for our dynamic size variable (DIRSIZE)
@SetLocal enableextensions EnableDelayedExpansion

ECHO Name	size>"D:\Games\Xbox360\_JMD\_RIPkits\_sizes_ripped.csv"

FOR /F "usebackq tokens=* delims=" %%G IN ("D:\Games\Xbox360\_JMD\_RIPkits\_list.txt") DO (

	REM We HAVE to push into the target directory so that powershell launches from within it
	PUSHD "%%G"
	
	REM Copy the powershell script into the target dir
	COPY "D:\Games\Xbox360\_JMD\_ripinfo\getsize.ps1" "%%G\getsize.ps1"
	
	REM Run the script
	powershell -file "%%G\getsize.ps1"
	
	REM Set the DIRSIZE variable based on the output of the script
	SET /p DIRSIZE=<"%%G\size.txt"
		
	REM Continue writing lines
	ECHO %%~nG	!DIRSIZE! >>"D:\Games\Xbox360\_JMD\_RIPkits\_sizes_ripped.csv"
	
	REM Remove temporary files
	IF EXIST "%%G\getsize.ps1" DEL "%%G\getsize.ps1" /q /s >NUL 2>&1
	IF EXIST "%%G\size.txt" DEL "%%G\size.txt" /q /s >NUL 2>&1
	
	REM We MUST pop out of the target directory
	POPD
	
	REM Temporary pause to test
	REM PAUSE
	
)

PAUSE
EXIT