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

SET 7ZIP=C:\Program Files\7-Zip\7z.exe

REM Note the use of quotes is important in these filters, don't include in the SETs
SET FILTER0=*UMD_DATA.BIN
SET FILTER1=*PIC0.PNG
SET FILTER2=*PIC1.PNG
SET FILTER3=*ICON0.PNG
SET FILTER4=*ICON1.PNG
SET FILTER5=*ICON1.PMF
SET FILTER6=*PARAM.SFO
SET FILTER7=*SND0.AT3

ECHO SET FILTER0 as "%FILTER0%"
ECHO SET FILTER1 as "%FILTER1%"
ECHO SET FILTER2 as "%FILTER2%"
ECHO SET FILTER3 as "%FILTER3%"
ECHO SET FILTER4 as "%FILTER4%"
ECHO SET FILTER5 as "%FILTER5%"
ECHO SET FILTER6 as "%FILTER6%"
ECHO SET FILTER7 as "%FILTER7%"

SET FILTERS="%FILTER0%" "%FILTER1%" "%FILTER2%" "%FILTER3%" "%FILTER4%" "%FILTER5%" "%FILTER6%" "%FILTER7%"
ECHO SET FILTERS as %FILTERS%

ECHO [33mWARNING:[0m Files that contain exclamation marks (^^!) will fail to process.
ECHO This will include a lot of Japan region titles, even when translated.
ECHO.
ECHO [97m[44m---------------------------------------------------------------[0m

FOR /R %%G IN (*.iso) DO (

	REM ECHO FQP - "%%G"
	REM ECHO dpG - "%%~dpG"
	REM ECHO dpn - "%%~dpnG"
	REM ECHO nG - "%%~nG"
	REM ECHO nxG - "%%~nxG"

	PUSHD "%%~dpG"
	
	IF NOT EXIST "%%~dpnG" (
		MKDIR "%%~dpnG"
		ECHO Creating ISO folder
		ECHO ------------------------------------
	)
	
	IF EXIST "%%~dpnG" (
		ECHO We detected an existing output folder^!
		ECHO Checking for existance of meta files...
		IF EXIST "%%~dpnG\PSP_GAME" (
			ECHO We detected a bootable "PSP_GAME" folder^!
			ECHO Checking for any matching %FILTERS%
			SET FXIST=
			FOR /R %%G IN (%FILTER1%) DO ECHO %%~nxG exists^! && SET FXIST=YES && SET FILTERN1=%%~nxG
			FOR /R %%G IN (%FILTER2%) DO ECHO %%~nxG exists^! && SET FXIST=YES && SET FILTERN2=%%~nxG
			FOR /R %%G IN (%FILTER3%) DO ECHO %%~nxG exists^! && SET FXIST=YES && SET FILTERN3=%%~nxG
			FOR /R %%G IN (%FILTER4%) DO ECHO %%~nxG exists^! && SET FXIST=YES && SET FILTERN4=%%~nxG
			FOR /R %%G IN (%FILTER5%) DO ECHO %%~nxG exists^! && SET FXIST=YES && SET FILTERN5=%%~nxG
			FOR /R %%G IN (%FILTER6%) DO ECHO %%~nxG exists^! && SET FXIST=YES && SET FILTERN6=%%~nxG
			FOR /R %%G IN (%FILTER7%) DO ECHO %%~nxG exists^! && SET FXIST=YES && SET FILTERN7=%%~nxG
			
			REM To check for each file individually to make sure we have them all (except FILTER4)
			REM We need to have a complete database of untouched dumps to work from first!
			
		)
	)
	
	REM If we didn't find any meta files in output
	IF NOT DEFINED FXIST (
	
		ECHO Moving target ISO and rename extension as ISOTMP to avoid infinite recursion
		MOVE "%%G" "%%~dpnG\%%~nG.ISOTMP"
		POPD
		
		PUSHD "%%~dpnG"
		
		REM Useful - use 7z x instead of 7z e to keep the directory structure when extracting
		ECHO Processing "%%~nxG"
		SET OUT=%%~dpnG
		SET IN=!OUT!\%%~nG.ISOTMP
		
		"C:\Program Files\7-Zip\7z.exe" x "!IN!" "-o!OUT!" %FILTERS% -r
		
		ECHO [92mDone^^![0m
		POPD
		
		PUSHD "%%~dpnG"
		ECHO Moving target ISOTMP back to where it came from
		MOVE "%%~dpnG\%%~nG.ISOTMP" "%%~dpG%%~nG.ISOTMP"
		POPD
	)
	
)

REM Prevents infinite recursion
FOR /R %%G IN (*.ISOTMP) DO (
	REN "%%G" "%%~nG.iso"
)

POPD
	
PAUSE

EXIT