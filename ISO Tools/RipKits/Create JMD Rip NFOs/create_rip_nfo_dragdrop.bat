@ECHO OFF

REM Change to unicode
REM chcp 437

REM Push into target directory
PUSHD "%1"

REM Copy header
COPY "..\rip_part1.txt" "Ripped by JMD.nfo"

REM Write lines
ECHO.>>"Ripped by JMD.nfo"
ECHO.>>"Ripped by JMD.nfo"
ECHO Using RGH Xbox 360 Slim E ^& FreestyleDash v3>>"Ripped by JMD.nfo"
ECHO.>>"Ripped by JMD.nfo"
ECHO # # # # # # # # # # # # # # # # # # # # # # # #>>"Ripped by JMD.nfo"
ECHO.>>"Ripped by JMD.nfo"
ECHO Title^: %~n1 >>"Ripped by JMD.nfo"
ECHO.>>"Ripped by JMD.nfo"
ECHO Format^: PAL>>"Ripped by JMD.nfo"
ECHO.>>"Ripped by JMD.nfo"

REM Copy the powershell script into the target dir
COPY "..\getsize.ps1" "%~dpn1\getsize.ps1"

REM Run the script
powershell -file "%~dpn1\getsize.ps1"

REM Set the DIRSIZE variable based on the output of the script
SET /p DIRSIZE=<size.txt

REM Continue writing lines
ECHO Size (unpacked)^: %DIRSIZE% >>"Ripped by JMD.nfo"
ECHO.>>"Ripped by JMD.nfo"
ECHO What's ripped^:>>"Ripped by JMD.nfo"
ECHO.>>"Ripped by JMD.nfo"
ECHO - NOTHING>>"Ripped by JMD.nfo"
ECHO.>>"Ripped by JMD.nfo"
ECHO # # # # # # # # # # # # # # # # # # # # # # # #>>"Ripped by JMD.nfo"
ECHO.>>"Ripped by JMD.nfo"
ECHO # # # # # # # # # # # # # # # # # # # # # # # #>>"Ripped by JMD.nfo"
ECHO Install instructions^:>>"Ripped by JMD.nfo"
ECHO.>>"Ripped by JMD.nfo"
ECHO 1. Copy extracted folder to a Games folder on your Xbox 360>>"Ripped by JMD.nfo"
ECHO 2. Make sure your custom dash (Freestyle, Aurora, etc) has this location in scan options>>"Ripped by JMD.nfo"
ECHO 3. Scan your library to make sure game appears.>>"Ripped by JMD.nfo"
ECHO 4. That's it^! Enjoy^! >>"Ripped by JMD.nfo"
ECHO.>>"Ripped by JMD.nfo"
ECHO Note^: The name of the game folder shouldn't be changed>>"Ripped by JMD.nfo"
ECHO.>>"Ripped by JMD.nfo"
ECHO # # # # # # # # # # # # # # # # # # # # # # # #>>"Ripped by JMD.nfo"
ECHO Contact if any problems^:>>"Ripped by JMD.nfo"
ECHO https://www.reddit.com/user/Jenkins87>>"Ripped by JMD.nfo"
ECHO # # # # # # # # # # # # # # # # # # # # # # # #>>"Ripped by JMD.nfo"

REM Remove temporary files
IF EXIST "%~dpn1\getsize.ps1" DEL "%~dpn1\getsize.ps1" /q /s >NUL 2>&1
IF EXIST "%~dpn1\size.txt" DEL "%~dpn1\size.txt" /q /s >NUL 2>&1

POPD

REM PAUSE
EXIT