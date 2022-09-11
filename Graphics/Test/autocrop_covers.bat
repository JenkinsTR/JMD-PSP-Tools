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

SET IM=K:\GitHub\JMD-PSP-Tools\PSPMediaConverter_src\bin\ImageMagick-7.1.0-portable-Q16-HDRI-x64
SET OUT=K:\GitHub\JMD-PSP-Tools\Graphics\Test

IF NOT EXIST "%OUT%" MKDIR "%OUT%"

PUSHD "%OUT%"

FOR /R %%G IN (*.jpg) DO (

	PUSHD "%%~dpG"
	
	IF NOT EXIST "%%~dpG\autocrop" MKDIR "%%~dpG\autocrop" && ECHO [93m Making output dir[0m
	
	REM SET DEFAULT VALUES
	REM radii (large,small)
	SET "radiiA=60"
	SET "radiiB=3"
	REM transparencies
	SET "alphaA=40"
	SET "alphaB=50"
	REM image - blurredimage weights
	SET "weightA=1"
	SET "weightB=1"
	REM filter bias
	SET "bias=50"
	REM compose methods
	SET "composeA=hardlight"
	SET "composeB=overlay"
	
	ECHO [92m Options set as: [0m
	ECHO radiiA set as [92m!radiiA! [0m
	ECHO radiiB set as [92m!radiiB! [0m
	ECHO alphaA set as [92m!alphaA! [0m
	ECHO alphaB set as [92m!alphaB! [0m
	ECHO weightA set as [92m!weightA! [0m
	ECHO weightB set as [92m!weightB! [0m
	ECHO bias set as [92m!bias! [0m
	ECHO composeA set as [92m!composeA! [0m
	ECHO composeB set as [92m!composeB! [0m
	
	REM get infile and outfile
	SET "INFILE=%%G"
	SET "OUTFILE=%%~dpGautocrop\%%~nxG"
	ECHO INFILE set as [92m!INFILE! [0m
	ECHO OUTFILE set as [92m!OUTFILE! [0m
	
	SET rad1=!radiiA!
	SET rad2=!radiiB!
	SET alpha1=!alphaA!
	SET alpha2=!alphaB!
	SET wt1=!weightA!
	SET wt2=!weightB!
	SET compose1=!composeA!
	SET compose2=!composeB!
	
	REM set up temp files
	SET "tmpA1=%%~dpGenrich_A.mpc"
	SET "tmpA2=%%~dpGenrich_A.cache"
	
	REM read the input image into the temp files and test validity.
	"%IM%\convert.exe" -quiet "!INFILE!" -alpha off +repage "!tmpA1!"
	
	REM change sign on wt2
	SET wt2=-!wt2!
	
	REM change bias from percent to range 0 to 1
	SET /A bias=!bias!/100
	ECHO bias float [92m!bias! [0m
	
	REM speed up larger radius blur by resizing down, using smaller blur and resizing back up
	
	REM - - - - - - - - - - - - - - - - - - - - - - - - - -
	REM Do the identify
	ECHO Running Identify . . .
	REM MAIN IDENTIFY LOOP

	ECHO Identifying [92m%%~nG [0m. . .
	
	ECHO.

	"%IM%\identify.exe" -ping -format "%%[width]" "%%G" > "w_%%~nG.dim"
	SET /p WIDTH=<w_%%~nG.dim

	"%IM%\identify.exe" -ping -format "%%[height]" "%%G" > "h_%%~nG.dim"
	SET /p HEIGHT=<h_%%~nG.dim

	REM Delete the width and height files quietly
	DEL "w_%%~nG.dim" /q /s >NUL 2>&1
	DEL "h_%%~nG.dim" /q /s >NUL 2>&1

	REM Reset size var
	SET SIZEF=!WIDTH!x!HEIGHT!
	SET "SIZEDIR=!FILED!!FILEN!"
	SET "SIZEN=%%~nG"

	ECHO Filename: [92m%%~nG [0m
	ECHO Width: [92m!WIDTH! [0m
	ECHO Height: [92m!HEIGHT! [0m
	
	ECHO.
	
	SET /A rad1=!rad1!/5
	ECHO rad1 20^% = [92m!rad1! [0m
	
	SET ww=!WIDTH!
	SET hh=!HEIGHT!
	
	"%IM%\convert.exe" "!tmpA1!" ^( -clone 0 -resize 20%% -blur 0x!rad1! -resize !ww!x!hh!^! ^) ^(-clone 0 -clone 1 +swap -compose mathematics -define compose:args="0,!wt1!,!wt2!,!bias!" -composite -alpha on -channel A negate -evaluate set !alpha1!%% +channel ^) ^( -clone 0 -blur 0x!rad2! ^) ^( -clone 0 -clone 3 +swap -compose mathematics -define compose:args="0,!wt1!,!wt2!,!bias!" -composite -alpha on -channel A negate -evaluate set !alpha2!%% +channel ^) ^( -clone 0 -clone 2 -compose !compose1! -composite -clone 4 -compose !compose2! -composite ^) -delete 0-4 "!OUTFILE!"
	
	IF EXIST "!tmpA1!" DEL "!tmpA1!" /q /s >NUL 2>&1
	IF EXIST "!tmpA2!" DEL "!tmpA2!" /q /s >NUL 2>&1
	
	ECHO [92m Done^![0m
	
	POPD
	
)

POPD

ECHO [92mAll files done^![0m

GOTO END

:ERROR

:END

PAUSE

EXIT