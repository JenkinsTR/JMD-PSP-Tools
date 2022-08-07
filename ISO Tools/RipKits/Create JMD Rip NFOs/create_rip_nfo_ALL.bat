@ECHO OFF

REM We need this for our dynamic size variable (DIRSIZE)
@SetLocal enableextensions EnableDelayedExpansion

FOR /F "usebackq tokens=* delims=" %%G IN ("D:\Games\Xbox360\_JMD\_RIPkits\_list.txt") DO (

	REM We HAVE to push into the target directory so that powershell launches from within it
	PUSHD "%%G"
	
	ECHO.
	ECHO --------------------------------------------------
	ECHO Processing %%~nG . . .
	
	ECHO.
	ECHO Copying header . . .
	
	REM Copy header
	COPY "D:\Games\Xbox360\_JMD\_RIPkits\rip_part1.txt" "%%G\Ripped by JMD.nfo" /Y
	
	ECHO.
	ECHO Writing lines . . .
	
	REM Write lines
	ECHO.>>"%%G\Ripped by JMD.nfo"
	ECHO.>>"%%G\Ripped by JMD.nfo"
	ECHO Using RGH Xbox 360 Slim E ^& FreestyleDash v3>>"%%G\Ripped by JMD.nfo"
	ECHO.>>"%%G\Ripped by JMD.nfo"
	ECHO # # # # # # # # # # # # # # # # # # # # # # # #>>"%%G\Ripped by JMD.nfo"
	ECHO.>>"%%G\Ripped by JMD.nfo"
	ECHO Title^: %%~nG >>"%%G\Ripped by JMD.nfo"
	ECHO.>>"%%G\Ripped by JMD.nfo"
	ECHO Format^: PAL>>"%%G\Ripped by JMD.nfo"
	ECHO.>>"%%G\Ripped by JMD.nfo"
	
	ECHO.
	ECHO Copying Powershell size script . . .
	
	REM Copy the powershell script into the target dir
	COPY "D:\Games\Xbox360\_JMD\_ripinfo\getsize.ps1" "%%G\getsize.ps1"
	
	ECHO.
	ECHO Launching powershell script . . .
	
	REM Run the script
	powershell -file "%%G\getsize.ps1"
	
	ECHO.
	ECHO Setting size variable . . .
	
	REM Set the DIRSIZE variable based on the output of the script
	SET /p DIRSIZE=<"%%G\size.txt"
	
	ECHO.
	ECHO Continuing writing lines . . .
	
	REM Continue writing lines
	ECHO Size ^(unpacked^)^: !DIRSIZE! >>"%%G\Ripped by JMD.nfo"
	ECHO.>>"%%G\Ripped by JMD.nfo"
	ECHO What's ripped^:>>"%%G\Ripped by JMD.nfo"
	ECHO.>>"%%G\Ripped by JMD.nfo"
	ECHO - Non-English language files>>"%%G\Ripped by JMD.nfo"
	ECHO.>>"%%G\Ripped by JMD.nfo"
	ECHO # # # # # # # # # # # # # # # # # # # # # # # #>>"%%G\Ripped by JMD.nfo"
	ECHO.>>"%%G\Ripped by JMD.nfo"
	ECHO # # # # # # # # # # # # # # # # # # # # # # # #>>"%%G\Ripped by JMD.nfo"
	ECHO Install instructions^:>>"%%G\Ripped by JMD.nfo"
	ECHO.>>"%%G\Ripped by JMD.nfo"
	ECHO 1. Copy extracted folder to a Games folder on your Xbox 360>>"%%G\Ripped by JMD.nfo"
	ECHO 2. Make sure your custom dash ^(Freestyle, Aurora, etc^) has this location in scan options>>"%%G\Ripped by JMD.nfo"
	ECHO 3. Scan your library to make sure game appears.>>"%%G\Ripped by JMD.nfo"
	ECHO 4. That's it^! Enjoy^! >>"%%G\Ripped by JMD.nfo"
	ECHO.>>"%%G\Ripped by JMD.nfo"
	ECHO Note^: The name of the game folder shouldn't be changed>>"%%G\Ripped by JMD.nfo"
	ECHO.>>"%%G\Ripped by JMD.nfo"
	ECHO # # # # # # # # # # # # # # # # # # # # # # # #>>"%%G\Ripped by JMD.nfo"
	ECHO Contact if any problems^:>>"%%G\Ripped by JMD.nfo"
	ECHO https^:^/^/www.reddit.com^/user^/Jenkins87>>"%%G\Ripped by JMD.nfo"
	ECHO # # # # # # # # # # # # # # # # # # # # # # # #>>"%%G\Ripped by JMD.nfo"
	
	ECHO.
	ECHO Removing temporary files . . .
	
	REM Remove temporary files
	IF EXIST "%%G\getsize.ps1" DEL "%%G\getsize.ps1" /q /s >NUL 2>&1
	IF EXIST "%%G\size.txt" DEL "%%G\size.txt" /q /s >NUL 2>&1
	
	ECHO.
	ECHO Done
	ECHO --------------------------------------------------

	REM We MUST pop out of the target directory
	POPD
	
	REM Temporary pause to test
	REM PAUSE
	
)

PAUSE
EXIT