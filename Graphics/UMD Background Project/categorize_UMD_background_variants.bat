@ECHO OFF

REM Set master local expansion and command extensions.
REM USE ONCE
@SetLocal enableextensions EnableDelayedExpansion

CLS

ECHO [32m =============================================================== [0m
ECHO [32m              %~nx0                                              [0m
ECHO [32m             (c)2022 JMDigital. All Rights Reserved.             [0m
ECHO [32m =============================================================== [0m
ECHO.

SET UMDBKG=%~dp0umd_background_master_db.csv
SET UMDBKGF=%~dp0umd_background_master_files
IF NOT EXIST "%UMDBKG%" ECHO Group	Title	ICON0.PNG	PIC1.PNG	ICON1.PMF	PIC0.PNG	SND0.AT3	Path > "%UMDBKG%"

REM We need to have already extracted ISOs to a folder.

REM Searching for UMD_DATA.BIN is the only way to capture the master folder with 100% accuracy
FOR /R %%G IN (*UMD_DATA.BIN) DO (
	SET GAME=%%~dpG
	SET PSP_GAME=!GAME!PSP_GAME
	PUSHD "!PSP_GAME!"
	
	SET ParentDir=%%~pG
	REM Replace space with colon
	SET ParentDir=!ParentDir: =:!
	REM Replace backslash with space
	SET ParentDir=!ParentDir:\= !
	REM Replace comma with $
	SET ParentDir=!ParentDir:,=$!
	REM Call getparentdir 
	CALL :getparentdir !ParentDir!
	REM Replace colon back to space
	SET ParentDir=!ParentDir::= !
	REM Replace $ back to comma
	SET ParentDir=!ParentDir:$=,!
	
	ECHO ------------------------------------------------------------------
	ECHO Title: [94m !ParentDir! [0m
	
	IF EXIST "!PSP_GAME!\SND0.AT3" (
		ECHO [92m Found background music, continuing . . . [0m
		ECHO !PSP_GAME!\SND0.AT3 >> "%UMDBKGF%_SND0.txt"
		ECHO !PSP_GAME!\SND0.AT3 >> "!PSP_GAME!\umd_background.txt"
		
		SET SND0=Yes
	) ELSE (
		ECHO [33m Background music not found .[0m
		
		
		SET SND0=No
	)
	
	IF EXIST "!PSP_GAME!\ICON0.PNG" (
		ECHO [92m Found game icon, continuing . . . [0m
		ECHO !PSP_GAME!\ICON0.PNG > "!PSP_GAME!\umd_background.txt"
		
		SET ICON0=Yes
		
		:: GROUP B-D CHECKER
		IF EXIST "!PSP_GAME!\PIC1.PNG" (
			ECHO [92m Found game background, continuing . . . [0m
			ECHO !PSP_GAME!\PIC1.PNG >> "!PSP_GAME!\umd_background.txt"
			
			SET PIC1=Yes
			
			IF EXIST "!PSP_GAME!\ICON1.PMF" (
				ECHO [92m Found aniamted icon, continuing . . . [0m
				ECHO !PSP_GAME!\ICON1.PMF >> "!PSP_GAME!\umd_background.txt"
				
				SET ICON1=Yes
				
				IF EXIST "!PSP_GAME!\PIC0.PNG" (
					SET GROUP=E
					
					ECHO !PSP_GAME!\PIC0.PNG >> "%UMDBKGF%_!GROUP!_PIC0.txt"
					ECHO [92m All elements found[0m
					ECHO Setting Group !GROUP! active.
					ECHO [95m --------------------------------------------------------------- [0m
					ECHO [95m !ParentDir! is part of GROUP E                                  [0m
					ECHO [95m Game has icon, background, animated icon and large icon         [0m
					ECHO [95m --------------------------------------------------------------- [0m
					ECHO !PSP_GAME!\PIC0.PNG >> "!PSP_GAME!\umd_background.txt"
					
					SET PIC0=Yes
					
				) ELSE (
					SET GROUP=C
					
					ECHO !PSP_GAME!\ICON1.PMF >> "%UMDBKGF%_!GROUP!_ICON1.txt"
					ECHO [33m Large icon not found.[0m
					ECHO Setting Group !GROUP! active.
					ECHO [95m --------------------------------------------------------------- [0m
					ECHO [95m !ParentDir! is part of GROUP C                                  [0m
					ECHO [95m Game has icon, background and animated icon                     [0m
					ECHO [95m --------------------------------------------------------------- [0m
					
					SET PIC0=No
				)				
				
			) ELSE (
				SET GROUP=B
				
				ECHO !PSP_GAME!\PIC1.PNG >> "%UMDBKGF%_!GROUP!_PIC1.txt"
				ECHO [33m Animated icon not found. continuing . . .[0m
				
				SET ICON1=No
				
				IF EXIST "!PSP_GAME!\PIC0.PNG" (
					SET GROUP=D
					
					ECHO !PSP_GAME!\PIC0.PNG >> "%UMDBKGF%_!GROUP!_PIC0.txt"
					ECHO [92m Found large icon.[0m 
					ECHO Setting Group !GROUP! active.
					ECHO [95m --------------------------------------------------------------- [0m
					ECHO [95m !ParentDir! is part of GROUP D                                  [0m
					ECHO [95m Game has icon, background and large icon                        [0m
					ECHO [95m --------------------------------------------------------------- [0m
					ECHO !PSP_GAME!\PIC0.PNG >> "!PSP_GAME!\umd_background.txt"
					
					SET PIC0=Yes
					
				) ELSE (
					SET GROUP=B
					
					ECHO [33m Large icon not found.[0m 
					ECHO Setting Group !GROUP! active.
					ECHO [95m --------------------------------------------------------------- [0m
					ECHO [95m !ParentDir! is part of GROUP B                                  [0m
					ECHO [95m Game has only icon and background                               [0m
					ECHO [95m --------------------------------------------------------------- [0m
					
					SET PIC0=No
				)
			
			)
			
		) ELSE (
			SET GROUP=A
			
			ECHO [33m Game background not found. [0m
			ECHO Setting Group !GROUP! active.
			ECHO [95m --------------------------------------------------------------- [0m
			ECHO [95m !ParentDir! is part of GROUP A                                  [0m
			ECHO [95m Game has only an icon                                           [0m
			ECHO [95m --------------------------------------------------------------- [0m
			
			SET PIC1=No
		)
				
	) ELSE (
		ECHO [97m[41m --------------------------------------------------------------- [0m
		ECHO [97m[41m WARNING: Game icon not found.                                   [0m
		ECHO [97m[41m Please check the "!ParentDir!" folder                           [0m
		ECHO [97m[41m Make sure PNG/PMF/AT3 files are stored within PSP_GAME          [0m
		ECHO [97m[42m =============================================================== [0m
		
		SET ICON0=No
	)
	
	
	REM Now that we have a list 'umd_background.txt' inside of each 'PSP_GAME' folder for each game, we can process them accordingly.
	REM FOR /F "usebackq tokens=* delims=" %%G IN ("!PSP_GAME!\umd_background.txt") DO (
		REM IF "%%~nxG"=="PIC0.PNG" ECHO %%G
		REM IF "%%~nxG"=="PIC1.PNG" ECHO %%G
		REM IF "%%~nxG"=="ICON0.PNG" ECHO %%G
		REM IF "%%~nxG"=="ICON1.PMF" ECHO %%G
		REM IF "%%~nxG"=="SND0.AT3" ECHO %%G
	REM )
	
	ECHO !GROUP!	!ParentDir!	!ICON0!	!PIC1!	!ICON1!	!PIC0!	!SND0!	!GAME! >> "%UMDBKG%"
	
	REM Remove the temp text file for now
	IF EXIST "!PSP_GAME!\umd_background.txt" DEL "!PSP_GAME!\umd_background.txt" /q /s >NUL 2>&1
	
)

PAUSE

EXIT

goto :EOF

:getparentdir
if "%~1" EQU "" goto :EOF
Set "ParentDir=%~1"
shift
goto :getparentdir