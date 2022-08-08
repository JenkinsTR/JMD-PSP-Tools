@ECHO OFF

REM Set master local expansion and command extensions.
REM USE ONCE
@SetLocal enableextensions EnableDelayedExpansion

CLS

REM @echo off & REM setLocal enableExtensions disableDelayedExpansion

:: https://www.dostips.com/forum/viewtopic.php?t=4308
(call;) %= sets errorLevel to 0 =%
(set lf=^
%= BLANK LINE REQUIRED =%
)
:: kudos to Carlos for superior method of capturing CR
:: https://www.dostips.com/forum/viewtopic.php?p=40757#p40757
set "cr=" & if not defined cr for /f "skip=1" %%C in (
    'echo(^|replace ? . /w /u'
) do set "cr=%%C"


ECHO [97m[102m===============================================================[0m
ECHO                 %~nx0                                          
ECHO             (c)2022 JMDigital. All Rights Reserved.            
ECHO [97m[102m===============================================================[0m
ECHO.

SET "PSPDB=K:\GitHub\JMD-PSP-Tools\ISO Tools\db\pspdb.xml"
SET "GLIST=K:\GitHub\JMD-PSP-Tools\ISO Tools\Metadata\games_list.txt"

IF EXIST "%PSPDB%" GOTO ERROR

ECHO ^<^?xml version="1.0" encoding="UTF-8"^?^> > "%PSPDB%"
ECHO ^<PSPDB^> >> "%PSPDB%"

FOR /F "usebackq tokens=* delims=" %%G IN ("%GLIST%") DO (
REM FOR /R %%G IN (*_info.txt) DO (

	PUSHD "%%~dpG"
	
	REM Bomberman (EUR) (En,Fr,De,Es,It) (v1.02) [ULES-00469].iso
	REM	<GAME>
	REM		<TITLE>Bomberman</TITLE>
	REM		<TITLEID>ULES-00469</TITLEID>
	REM		<REGION>EUR</REGION>
	REM		<LANG>En,Fr,De,Es,It</LANG>
	REM		<UMDDATE>2006-10-13 10:46:32</UMDDATE>
	REM		<UMDSIZE>148 MB</UMDSIZE>
	REM	</GAME>
	
	
	REM Get UID from input name and set it as VOLID
	FOR /F "tokens=1,2,3 delims=[]" %%G IN ("%%~nG") DO SET VOLID=%%H
	
	FINDSTR /c:"Volume Creation Date" "%%G" > vcd.tmp
	FINDSTR /c:"Volume Size" "%%G" > vsz.tmp
	FINDSTR /c:"Publisher id" "%%G" > pid.tmp
	
	SET /P UMDDATE=< vcd.tmp
	SET /P UMDSIZE=< vsz.tmp
	SET /P PUBL=< pid.tmp
	
	FOR /F "tokens=1,2,3,4,5 delims= " %%G IN ("!UMDDATE!") DO SET UMDDATE=%%J %%K
	FOR /F "tokens=1,2,3,4 delims= " %%G IN ("!UMDSIZE!") DO SET UMDSIZE=%%I %%J
	FOR /F "tokens=1,2 delims=:" %%G IN ("!PUBL!") DO SET PUBL=%%H
	
	IF EXIST "vcd.tmp" DEL "vcd.tmp" /q /s >NUL 2>&1
	IF EXIST "vsz.tmp" DEL "vsz.tmp" /q /s >NUL 2>&1
	IF EXIST "pid.tmp" DEL "pid.tmp" /q /s >NUL 2>&1
	
	
	set ^"orig=!PUBL!^"
	
	call :trimAll res2 orig
	REM echo(orig: [!orig!]
	REM echo(res1: [!res1!]
	REM echo(res2: [!res2!]
	
	FOR /F "tokens=1,2,3,4 delims=()" %%K IN ("%%~nG") DO (
		ECHO --------------------------------------
		ECHO Title: %%K && SET TITLE=%%K
		ECHO Title ID: !VOLID!
		ECHO Publisher: !res2!
		ECHO Region: %%L && SET REGION=%%L
		ECHO Languages: %%N && SET LANG=%%N
		ECHO UMD Date: !UMDDATE!
		ECHO UMD Size: !UMDSIZE!
		ECHO --------------------------------------
		ECHO.
	)
	
	ECHO 	^<GAME^> >> "%PSPDB%"
	ECHO 		^<TITLE^>!TITLE!^<^/TITLE^> >> "%PSPDB%"
	ECHO 		^<TITLEID^>!VOLID!^<^/TITLEID^> >> "%PSPDB%"
	ECHO 		^<PUBL^>!res2!^<^/PUBL^> >> "%PSPDB%"
	ECHO 		^<REGION^>!REGION!^<^/REGION^> >> "%PSPDB%"
	ECHO 		^<LANG^>!LANG!^<^/LANG^> >> "%PSPDB%"
	ECHO 		^<UMDDATE^>!UMDDATE!^<^/UMDDATE^> >> "%PSPDB%"
	ECHO 		^<UMDSIZE^>!UMDSIZE!^<^/UMDSIZE^> >> "%PSPDB%"
	ECHO 	^<^/GAME^> >> "%PSPDB%"
	
)

ECHO ^<^/PSPDB^> >> "%PSPDB%"


ECHO [97mAll done^![0m

GOTO END

:ERROR
ECHO Database already exists^! Running this file will destroy it's contents. Back it up and go again

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
