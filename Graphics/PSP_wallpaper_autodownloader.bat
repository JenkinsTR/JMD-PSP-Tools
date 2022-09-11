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
SET OUT=%PSPG%\WP_Autodownload

IF NOT EXIST "%OUT%" MKDIR "%OUT%"

PUSHD "%OUT%"

REM Run the GID py
ECHO [92m Options set as: [0m
ECHO [92m GID: [0m "%GID%"
ECHO [92m ChromeDriver: -cd "%CHDR%"
ECHO [92m Keyword prefix: [0m --k "PSP"
ECHO [92m Keywords: [0m -sk Wallpaper,Background,Template,Icon
ECHO [92m Number of images (each keyword): [0m -l 100
ECHO [92m Size of images: [0m -es 480,272
ECHO [92m Output file prefix: [0m -pr "PSP_"
ECHO [92m Output dir: [0m -o "%OUT%"

python3 "%GID%" --keywords "PSP" -sk "Wallpaper,Background" -l 100 -es 480,272 -pr "PSP_" -o "%OUT%" -cd "%CHDR%"
python3 "%GID%" --keywords "PSP" -sk "Template" -ct transparent -l 100 -es 480,272 -pr "PSP_" -o "%OUT%" -cd "%CHDR%"
python3 "%GID%" --keywords "PSP" -sk "Icon" -ct transparent -l 100 -es 256,256 -pr "PSP_" -o "%OUT%" -cd "%CHDR%"

ECHO [92m Done^![0m

ECHO [92mAll files done^![0m

GOTO END

:ERROR

:END

PAUSE

EXIT