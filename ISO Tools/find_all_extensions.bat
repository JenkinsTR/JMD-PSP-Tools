@ECHO OFF

:: ------------------------------------------------------------------------------------------------------------------------------
:: 
:: Find all unique extensions in all sub folders
:: 
:: - Writes only unique extensions found to "ext_list.txt"
:: - Results are printed to console as found.
:: - Works for files without extensions also, but will appear as 'FileWithNoExtension'
:: - Takes a long time to search folders with vast amounts of files
:: ------------------------------------------------------------------------------------------------------------------------------
:: Thanks to PSEUDO https://stackoverflow.com/questions/44072096/windows-command-to-get-list-of-file-extensions
:: ------------------------------------------------------------------------------------------------------------------------------

SET TITLE=%~n0
TITLE %TITLE%
CLS

ECHO [92m===================================================================================[0m
ECHO                 %~nx0                                          
ECHO             (c)2022 JMDigital. All Rights Reserved.      
ECHO.
ECHO [92m         Finds all unique extensions in all sub folders[0m
ECHO.
ECHO Info:
ECHO - Writes only unique extensions found to [93m"%~dp0ext_list.txt"[0m
ECHO - Results are printed to console as found.
ECHO - Works for files without extensions also, but will appear as 'FileWithNoExtension'
ECHO [92m===================================================================================[0m
ECHO.

SET target=%~1
IF "%target%"=="" SET target=%cd%

SETLOCAL EnableDelayedExpansion

SET LF=^


REM Previous two lines deliberately left blank for LF to work.
ECHO Auditing CASe SEnSItiVE extensions in [94m"%target%"[0m . . .
ECHO.
ECHO NOTE: This can take a very long time depending on the amount of files in EACH sub folder
ECHO No output will be displayed if existing extensions are found^^!
ECHO.
ECHO [33m ^/^^!^\[0m [31m B E   P A T I E N T[0m [33m ^/^^!^\[0m
ECHO.

FOR /F "tokens=*" %%i IN ('DIR /b /s /a:-d "%target%"') DO (
    SET ext=%%~xi
    IF "!ext!"=="" SET ext=FileWithNoExtension
    REM ECHO !extlist! [pipe] find "!ext!:" > NUL
    ECHO !extlist! | find "!ext!:" > NUL
    IF NOT !ERRORLEVEL! == 0 (
		SET extlist=!extlist!!ext!:
		ECHO [95mFound new[0m   !ext!  [95m from file [0m  [93m"%%~nxi"[0m  [95m in [0m  "%%~dpi"  
	)
)

REM CLS

ECHO [95m-----------------------------------------------------------------------------------[0m
ECHO [95mUnique Extensions:                                                                 [0m
ECHO [95m-----------------------------------------------------------------------------------[0m
ECHO [93m%extlist::=!LF!%[0m && ECHO %extlist::=!LF!% > ext_list.txt
ECHO.
ECHO [95m-----------------------------------------------------------------------------------[0m
ECHO All found extensions were printed to [93m"%~dp0ext_list.txt"[0m
ECHO.
ECHO [92m===================================================================================[0m
ECHO            [93mCompleted on %DATE% - %TIME%[0m
ECHO                 [95m%~nx0[0m
ECHO             [92m(c)2022 JMDigital. All Rights Reserved.[0m
ECHO [92m===================================================================================[0m
ECHO.

ENDLOCAL

PAUSE

EXIT
