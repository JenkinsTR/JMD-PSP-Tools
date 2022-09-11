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
SET OUT=K:\GitHub\JMD-PSP-Tools\Graphics\Covers
SET META=K:\GitHub\JMD-PSP-Tools\ISO Tools\Metadata\Games
SET CHDR=K:\GitHub\JMD-PSP-Tools\Graphics\Bin\chromedriver_win32\chromedriver.exe

IF NOT EXIST "%OUT%" MKDIR "%OUT%"

PUSHD "%OUT%"

FOR /R %%G IN (*.*) DO (

	PUSHD "%%~dpG"
	
	ECHO [93m Finding Volume ID[0m
	IF NOT EXIST "%%~dpG\auotcrop" MKDIR "%%~dpG\auotcrop" && ECHO [93m Making output dir[0m
	
	REM Run the GID py
	ECHO [92m Options set as: [0m
		
	::::::::::::::::::::::::
	:: SET DEFAULT VALUES ::
	::::::::::::::::::::::::
	:: radii (large,small)
	SET "radiiA=60"
	SET "radiiB=3"
	:: transparencies
	SET "alphaA=40"
	SET "alphaB=50"
	:: image - blurredimage weights
	SET "weightA=1"
	SET "weightB=1"
	:: filter bias
	SET "bias=50"
	:: compose methods
	SET "composeA=hardlight"
	SET "composeB=overlay"
	
	ECHO radiiA set as [92m!radiiA! [0m
	ECHO radiiB set as [92m!radiiB! [0m
	ECHO alphaA set as [92m!alphaA! [0m
	ECHO alphaB set as [92m!alphaB! [0m
	ECHO weightA set as [92m!weightA! [0m
	ECHO weightB set as [92m!weightB! [0m
	ECHO bias set as [92m!bias! [0m
	ECHO composeA set as [92m!composeA! [0m
	ECHO composeB set as [92m!composeB! [0m
		
	:: -r)    :: get radii
	:: 	radii=`expr "$1" : '\([,.0-9]*\)'`
	:: 	[ "$radii" = "" ] && errMsg "--- RADII=$radii MUST BE TWO COMMA SEPARATED NON-NEGATIVE FLOAT ---"
	:: 	
	:: -t)    :: get transparency alphas
	:: 	alphas=`expr "$1" : '\([,.0-9]*\)'`
	:: 	[ "$alphas" = "" ] && errMsg "--- TRANSPARENCY=$alphas MUST BE TWO COMMA SEPARATED NON-NEGATIVE FLOAT ---"
	:: 	
	:: -w)    :: get weights
	:: 	weights=`expr "$1" : '\([,.0-9]*\)'`
	:: 	[ "$weights" = "" ] && errMsg "--- WEIGHTS=$weights MUST BE TWO COMMA SEPARATED NON-NEGATIVE FLOAT ---"
	:: 	
	:: -b)    :: get bias
	:: 	bias=`expr "$1" : '\([.0-9]*\)'`
	:: 	[ "$bias" = "" ] && errMsg "--- BIAS=$bias MUST BE A NON-NEGATIVE FLOAT ---"
	:: 	test1=`echo "$bias <= 0" | bc`
	:: 	test2=`echo "$bias >= 100" | bc`
	:: 	[ $test1 -eq 1 -o $test2 -eq 1 ] && errMsg "--- BIAS=$bias MUST BE FLOAT GREATER THAN 0 AND LESS THAN 100 ---"
	:: -c)    :: get compose
	:: 	compose=`expr "$1" : '\([-_,a-z,A-Z]*\)'`
	:: 	[ "$compose" = "" ] && errMsg "--- COMPOSE=$compose MUST BE TWO COMMA DELIMITED COMPOSE METHODS ---"
	
	:: get infile and outfile
	SET "INFILE=%%G"
	SET "OUTFILE=%%~dpG\auotcrop\%%~nxG"
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
	
	:: test that two values specified from arguments
	REM [ "!rad1!" = "" -o "!rad2!" = "" ] && errMsg "--- TWO RADII MUST BE SPECIFIED ---"
	REM [ "!alpha1!" = "" -o "!alpha2!" = "" ] && errMsg "--- TWO TRANSPARENCIES MUST BE SPECIFIED ---"
	REM [ "!wt1!" = "" -o "!wt2!" = "" ] && errMsg "--- TWO WEIGHTS MUST BE SPECIFIED ---"
	REM [ "!compose1!" = "" -o "!compose2!" = "" ] && errMsg "--- TWO COMPOSE METHODS MUST BE SPECIFIED ---"
	
	:: set up temp files
	SET "tmpA1=%%~dpG\enrich_A_$$.mpc"
	SET "tmpA2=%%~dpG\enrich_A_$$.cache"
	
	:: read the input image into the temp files and test validity.
	"%IM%\convert.exe" -quiet "!INFILE!" -alpha off +repage "!tmpA1!"
	
	:: change sign on wt2
	SET wt2=-!wt2!
	
	:: change bias from percent to range 0 to 1
	SET /A bias=!bias!/100
	ECHO bias float [92m!bias! [0m
	
	:: speed up larger radius blur by resizing down, using smaller blur and resizing back up
	
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
	ECHO rad1 20% = [92m!rad1! [0m
	
	SET ww=!WIDTH!
	SET hh=!HEIGHT!
	
	"%IM%\convert.exe" "!tmpA1!" -clone 0 -resize 20%% -blur 0x!rad1! -resize !ww!x!hh!^!
	"%IM%\convert.exe" "!tmpA1!" -clone 0 -clone 1 +swap -compose mathematics -set option:compose:args "0,!wt1!,!wt2!,!bias!" -composite -alpha on -channel A negate -evaluate set !alpha1!%% +channel
	"%IM%\convert.exe" "!tmpA1!" -clone 0 -blur 0x!rad2!
	"%IM%\convert.exe" "!tmpA1!" -clone 0 -clone 3 +swap -compose mathematics -set option:compose:args "0,!wt1!,!wt2!,!bias!" -composite -alpha on -channel A negate -evaluate set !alpha2!%% +channel
	"%IM%\convert.exe" "!tmpA1!" -clone 0 -clone 2 -compose !compose1! -composite -clone 4 -compose !compose2! -composite -delete 0-4 "!OUTFILE!"
	
	IF EXIST "!tmpA1!" DEL "!tmpA1!" /q /s >NUL 2>&1
	
	ECHO [92m Done^![0m
	
)


ECHO [92mAll files done^![0m

GOTO END

:ERROR

:END

PAUSE

EXIT