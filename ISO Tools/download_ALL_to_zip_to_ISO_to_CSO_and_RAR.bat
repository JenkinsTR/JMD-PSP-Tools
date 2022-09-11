@ECHO OFF

:: ------------------------------------------------------------------------------------------------------------------------------
:: 
:: Download all PSP games using wget
:: 
:: ------------------------------------------------------------------------------------------------------------------------------

SET TITLE=%~n0
TITLE %TITLE%
CLS

ECHO [92m===================================================================================[0m
ECHO                 %~nx0                                          
ECHO             (c)2022 JMDigital. All Rights Reserved.      
ECHO.
ECHO [92m         Downloads all PSP games using wget[0m
ECHO.
ECHO Info:
ECHO - Using wget we download the ZIP off archive.org to a new sub folder called [93m"%~dp0_ISO_DL"[0m
ECHO - Extracts the ISO from the ZIP using 7z
ECHO - Get the name, ID and region of the game from the ISO and rename it
ECHO - Extracts the metadata from the ISO and builds the audit [94m"*_info.txt"[0m files
ECHO - Converts the ISO to CSO
ECHO - RARs the original ISO with maximum compression, 5% recovery record,
ECHO    and injects the diagnostic info txt as a "rar comment" into the RAR file
ECHO - [31mDeletes[0m the original ISO
ECHO - Downloads top 10 related wallpapers for each game from Google Images,
ECHO    and saves them into the [93m[GameName]\Wallpapers[0m directory
ECHO [92m===================================================================================[0m
ECHO.

SET "PSPT=K:\GitHub\JMD-PSP-Tools"
SET "PSPG=%PSPT%\Graphics"
SET "PSPI=%PSPT%\ISO Tools"
SET "GID=%PSPG%\Bin\google-images-download-patch-1\google_images_download\google_images_download.py"
SET "CHDR=%PSPG%\Bin\chromedriver_win32\chromedriver.exe"
SET "WGET=%PSPI%\bin\wget.exe"
SET "MCISO=%PSPI%\bin\mciso-amd64.exe"
SET "UMDB=%PSPI%\bin\umdatabase.exe"

SET OUT=_ISO_DL
SET CSO=_CSO
SET RAR=_RAR

PUSHD "%~dp0"

IF NOT EXIST "%~dp0%OUT%" MKDIR "%~dp0%OUT%"

PUSHD "%~dp0%OUT%"

FOR /F "usebackq tokens=* delims=" %%G IN ("U:\Games\PSP\redump.psp.txt") DO (
	::WGET
	"%WGET%" --directory-prefix="%~dp0%OUT%" %%G
	
	::EXTRACTZIP
	
	ECHO [37mExtracting %%~nG [0m && ECHO ------------------------------------
	
	"C:\Program Files\7-Zip\7z.exe" e "%%G"
	
	::GETISONAME
	
	FOR /R %%G IN (*.iso) DO (
	
		PUSHD "%%~dpG"
		
		IF NOT EXIST "%%~dpG_ISO_TEMP" MKDIR "%%~dpG_ISO_TEMP" && ECHO Creating temporary ISO folder && ECHO ------------------------------------
		
		ECHO Moving target ISO && MOVE "%%G" "%%~dpG_ISO_TEMP\%%~nxG"
		
		ECHO temp > "%%~dpG_ISO_TEMP\%%~nG.txt"
	
		PUSHD "%%~dpG_ISO_TEMP"
		ECHO Processing "%%~nxG" && "%UMDB%" "%%~dpG_ISO_TEMP\%%~nxG" > "%%~dpG_ISO_TEMP\%%~nG.txt" && ECHO [92mDone^^![0m
		POPD
		
		PUSHD "%%~dpG"
		
		SET UID=
		SET NAME=
		FOR /R %%G IN (_ISO_TEMP\*.iso) DO SET UID=%%~nG
		FOR /R %%G IN (_ISO_TEMP\*.txt) DO SET NAME=%%~nG
		
		ECHO Moving and renaming ISO && MOVE "%%~dpG_ISO_TEMP\!UID!.iso" "%%~dpG!NAME! [!UID!].iso"
		ECHO Moving and renaming txt && MOVE "%%~dpG_ISO_TEMP\!NAME!.txt" "%%~dpG!NAME! [!UID!].txt" && ECHO [92mDone^^![0m && ECHO [97m[44m---------------------------------------------------------------[0m
		
		POPD
	)
	
	PUSHD "%~dp0%OUT%"

	::EXTRACTISO
	
	REM Note the use of quotes is important in these filters, don't include in the SETs
	SET FILTER0=*UMD_DATA.BIN
	SET FILTER1=*PIC0.PNG
	SET FILTER2=*PIC1.PNG
	SET FILTER3=*ICON0.PNG
	SET FILTER4=*ICON1.PNG
	SET FILTER5=*ICON1.PMF
	SET FILTER6=*PARAM.SFO
	SET FILTER7=*SND0.AT3
	
	ECHO SET FILTER0 as "!FILTER0!"
	ECHO SET FILTER1 as "!FILTER1!"
	ECHO SET FILTER2 as "!FILTER2!"
	ECHO SET FILTER3 as "!FILTER3!"
	ECHO SET FILTER4 as "!FILTER4!"
	ECHO SET FILTER5 as "!FILTER5!"
	ECHO SET FILTER6 as "!FILTER6!"
	ECHO SET FILTER7 as "!FILTER7!"
	
	SET FILTERS="!FILTER0!" "!FILTER1!" "!FILTER2!" "!FILTER3!" "!FILTER4!" "!FILTER5!" "!FILTER6!" "!FILTER7!"
	ECHO SET FILTERS as !FILTERS!
	
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
			SET GAMEDIR=%%~dpnG
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

	::ISO2CSO
	FOR /R %%G IN (*.iso) DO (
		ECHO [37mCompressing ISO to CSO [0m
		ECHO.
		"%MCISO%" 9 "%~dp0%OUT%\%%~nG.iso" "%~dp0%OUT%\%%~nG.cso"
		ECHO [92mDone^^! [0m && ECHO --------------------------------------
		ECHO.
	)
	
	::ISO2RAR
	SET "WRAR=C:\Program Files\WinRAR\Rar.exe"
	
	SET "OUTPUT=%~dp0"
	SET "OPTS=-m5 -s -rr5p -ma -md128
	
	FOR /R %%G IN (*.iso) DO (
		ECHO [37mArchiving ISO to RAR [0m
		ECHO.
		PUSHD "%%~dpG"
		
		REM Look for info txt to add as comment
		IF EXIST "%%~dpnG_info.txt" (
			"%WRAR%" !OPTS! a "%%~nG.rar" -z"%%~dpnG_info.txt" "%%~nG*"
		) ELSE (
			"%WRAR%" !OPTS! a  "%%~nG.rar" "%%~nG*"
		)
		
		REM WARNING THE BELOW REMOVES THE ORIGINAL ISO IF MATCHING RAR IS FOUND. MAKE SURE YOU ARE AWARE
		IF EXIST "%OUTPUT%%%~nG.rar" DEL "%OUTPUT%%%~nG.iso" /q /s >NUL 2>&1
		POPD
	)
	
	::WALLPAPERDOWNLOADER
	
	REM Run the GID py
	ECHO [92m Options set as: [0m
	ECHO [92m GID: [0m "%GID%"
	ECHO [92m ChromeDriver: -cd "%CHDR%"
	ECHO [92m Keyword prefix: [0m --k "PSP"
	ECHO [92m Keywords: [0m -sk "!NAME!"
	ECHO [92m Number of images (each keyword): [0m -l 10
	ECHO [92m Size of images: [0m -es 480,272
	ECHO [92m Output file prefix: [0m -pr "PSP_"
	ECHO [92m Output dir: [0m -o "!GAMEDIR!\Wallpapers"
	
	python3 "%GID%" --keywords "PSP Wallpaper" -sk "!NAME!" -l 10 -es 480,272 -pr "PSP_" -o "!GAMEDIR!\Wallpapers" -cd "%CHDR%"

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
