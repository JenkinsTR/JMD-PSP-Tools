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

SET GID=K:\GitHub\JMD-PSP-Tools\Graphics\Bin\google-images-download-patch-1\google_images_download\google_images_download.py
SET OUT=K:\GitHub\JMD-PSP-Tools\Graphics\Covers
SET META=K:\GitHub\JMD-PSP-Tools\ISO Tools\Metadata\Games
SET CHDR=K:\GitHub\JMD-PSP-Tools\Graphics\Bin\chromedriver_win32\chromedriver.exe

IF NOT EXIST "%OUT%" MKDIR "%OUT%"

PUSHD "%META%"

FOR /R %%G IN (*_info.txt) DO (

	PUSHD "%%~dpG"
	
	ECHO [93m Finding Volume ID[0m
	FOR /F "tokens=1,2,3 delims=[]" %%G IN ("%%~nG") DO SET VOLID=%%H
	
	ECHO [93m Finding Title[0m
	FINDSTR /c:"Title" "%%G" > ttl.tmp
	
	SET /P TITLE=< ttl.tmp
	IF EXIST "ttl.tmp" DEL "ttl.tmp" /q /s >NUL 2>&1
	
	REM Strip trailing spaces from Title
	FOR /F "tokens=1,2 delims=:" %%G IN ("!TITLE!") DO SET TITLE=%%H
	REM SET ^"ORIG=!TITLE!^"
	REM CALL :trimAll RES2 ORIG
	REM SET TITLE=!RES2!
	
	
	IF NOT EXIST "%OUT%\!VOLID! - !TITLE!" MKDIR "%OUT%\!VOLID!" && ECHO [93m Making output dir[0m
	
	REM Run the GID py
	ECHO [92m Options set as: [0m
	ECHO "%GID%"
	ECHO [92m Keyword prefix: --k "PSP" [0m
	ECHO [92m Keywords: -sk !VOLID!,!TITLE! [0m
	ECHO [92m Number of images: -l 32 [0m
	ECHO [92m Output file prefix: -pr "!VOLID!_" [0m
	ECHO [92m Output dir: -o "%OUT%\!VOLID!" [0m
	
	python3 "%GID%" --keywords "PSP" -sk "!VOLID!,!TITLE!,!TITLE! disc,!TITLE! UMD" -l 32 -pr "!VOLID!_" -o "%OUT%\!VOLID!" -cd "%CHDR%"
	
	ECHO [92m Done^![0m
	
)


ECHO [92mAll files done^![0m

GOTO END

:ERROR

:END

PAUSE

EXIT


:trimAll result= original=
:: trims leading and trailing whitespace from a string
:: special thanks to Jeb for
:: https://stackoverflow.com/a/8257951
setLocal
set "ddx=!" %= is delayed expansion enabled or disabled? =%
setLocal enableDelayedExpansion
set "die=" & if not defined %2 (
    >&2 echo(  ERROR: var "%2" not defined & set "die=1"
) else set "str=!%2!" %= if =%

if not defined die for %%L in ("!lf!") ^
do if "!str!" neq "!str:%%~L=!" (
    >&2 echo(  ERROR: var "%2" contains linefeeds & set "die=1"
) %= if =%

if not defined die for %%C in ("!cr!") ^
do if "!str!" neq "!str:%%~C=!" (
    >&2 echo(  ERROR: var "%2" contains carriage returns
    set "die=1"
) %= if =%

if defined die goto die

(for /f eol^= %%A in ("!str!") do rem nop
) || (
    >&2 echo(WARNING: var "%2" consists entirely of whitespace
    endLocal & endLocal & set "%1=" & exit /b 0
) %= cond exec =%

:: prepare string for trimming...
:: double carets
set "str=!str:^=^^^^!"
:: double quotes
set "str=!str:"=""!"
:: escape exclaims
set "str=%str:!=^^^!%" !

:: act of CALLing subfunction with
:: expanded string trims trailing whitespace
call :_trimAll "%%str%%

:: prepare string to be passed over endLocal boundary...
:: double carets again if delayed expansion enabled
if not defined ddx set "str=!str:^=^^^^!"
:: escape exclaims again if delayed expansion enabled
if not defined ddx set "str=%str:!=^^^!%" !
:: restore quotes
set "str=!str:""="!"

:: pass string over endLocal boundary and trim leading whitespace
for /f tokens^=*^ eol^= %%a in ("!str!") do (
    endLocal & endLocal & set "%1=%%a" !
) %= for /f =%
exit /b 0

:die
endLocal & endLocal & set "%1=" & exit /b 1

:_trimAll
:: subfunction
:: trailing exclaim is required as explained by Jeb at
:: https://www.dostips.com/forum/viewtopic.php?p=6933#p6933
set "str=%~1" !
exit /b 0
