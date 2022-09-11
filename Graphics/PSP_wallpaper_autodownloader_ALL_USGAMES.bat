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

SET PSPT=K:\GitHub\JMD-PSP-Tools
SET PSPG=%PSPT%\Graphics
SET GID=%PSPG%\Bin\google-images-download-patch-1\google_images_download\google_images_download.py
SET CHDR=%PSPG%\Bin\chromedriver_win32\chromedriver.exe
SET OUT=%PSPG%\WP_Autodownload_ALLGAMES

IF NOT EXIST "%OUT%" MKDIR "%OUT%"

PUSHD "%OUT%"

REM Run the GID py
ECHO [92m Options set as: [0m
ECHO [92m GID: [0m "%GID%"
ECHO [92m ChromeDriver: -cd "%CHDR%"
ECHO [92m Keyword prefix: [0m --k "PSP"
ECHO [92m Keywords: [0m -sk (all games)
ECHO [92m Number of images (each keyword): [0m -l 10
ECHO [92m Size of images: [0m -es 480,272
ECHO [92m Output file prefix: [0m -pr "PSP_"
ECHO [92m Output dir: [0m -o "%OUT%"

FOR /F "usebackq tokens=* delims=" %%G IN ("%PSPG%\games_keywords.txt") DO (

	python3 "%GID%" --keywords "PSP Wallpaper" -sk "%%G" -l 10 -es 480,272 -pr "PSP_" -o "%OUT%" -cd "%CHDR%"

)

ECHO [92m Done^![0m

ECHO [92mAll files done^![0m

GOTO END

:ERROR

:END

PAUSE

EXIT