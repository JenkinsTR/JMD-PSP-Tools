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

SET MCISO=K:\GitHub\JMD-PSP-Tools\ISO Tools\bin\mciso-amd64.exe

SET FILTER1="*PIC0.PNG"
SET FILTER2="*PIC1.PNG"
SET FILTER3="*ICON0.PNG"
SET FILTER4="*ICON1.PNG"
SET FILTER5="*ICON1.PMF"
SET FILTER6="*PARAM.SFO"
SET FILTER7="*SND0.AT3"
SET FILTERS=%FILTER1% %FILTER2% %FILTER3% %FILTER4% %FILTER5% %FILTER6% %FILTER7%

ECHO SET FILTER1 as %FILTER1%
ECHO SET FILTER2 as %FILTER2%
ECHO SET FILTER3 as %FILTER3%
ECHO SET FILTER4 as %FILTER4%
ECHO SET FILTER5 as %FILTER5%
ECHO SET FILTER6 as %FILTER6%
ECHO SET FILTER7 as %FILTER7%
ECHO SET FILTERS as %FILTERS%

ECHO.
ECHO [97m[44m---------------------------------------------------------------[0m

FOR /R %%G IN (*.cso) DO (

	REM ECHO FQP - "%%G"
	REM ECHO dpG - "%%~dpG"
	REM ECHO dpn - "%%~dpnG"
	REM ECHO nG - "%%~nG"
	REM ECHO nxG - "%%~nxG"

	PUSHD "%%~dpG"
	
	IF NOT EXIST "%%~dpnG" (
		MKDIR "%%~dpnG"
		ECHO Creating CSO folder
		ECHO ------------------------------------
	)
	
	
	PUSHD "%%~dpnG"
	
	REM Useful - use 7z x instead of 7z e to keep the directory structure when extracting
	ECHO Processing "%%~nxG"
	SET OUT=%%~dpnG
	SET IN=!OUT!\%%~nG.ISOTMP
	
	REM Convert to ISO first
	"%MCISO%" 0 "%%G" "%%~dpnG\%%~nG.ISOTMP"
	
	ECHO Moving target CSO and rename extension as CSOTMP to avoid infinite recursion
	MOVE "%%G" "%%~dpnG\%%~nG.CSOTMP"
	POPD
	
	PUSHD "%%~dpG"
	
	"C:\Program Files\7-Zip\7z.exe" x "!IN!" "-o!OUT!" %FILTERS% -r
	
	ECHO [92mDone^^![0m
	POPD
	
	PUSHD "%%~dpnG"
	ECHO Moving target CSOTMP back to where it came from
	MOVE "%%~dpnG\%%~nG.CSOTMP" "%%~dpG%%~nG.CSOTMP"
	POPD
	
	REM Delete temporary ISO
	IF EXIST "!IN!" DEL "!IN!" /q /s >NUL 2>&1
	
)

REM Prevents infinite recursion
FOR /R %%G IN (*.CSOTMP) DO (
	REN "%%G" "%%~nG.cso"
)

POPD
	
PAUSE

EXIT