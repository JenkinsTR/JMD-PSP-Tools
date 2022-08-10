@ECHO OFF


ECHO [32m =============================================================== [0m
ECHO [32m              %~nx0                                              [0m
ECHO [32m             (c)2022 JMDigital. All Rights Reserved.             [0m
ECHO [32m =============================================================== [0m
ECHO.

:------------------------------------------------------------------------------------------------------
:video_to_avi by JMD
REM Main program directories
REM Make this relative later
SET "JPSPMC=K:\GitHub\JMD-PSP-Tools\PSPMediaConverter_src"
ECHO SET JPSPMC as %JPSPMC%

SET "INPUT=%JPSPMC%\input"
ECHO SET INPUT as %INPUT%

SET ICON=YES
ECHO SET ICON as %ICON%

SET "DBTOOLS=%JPSPMC%\bin"
SET "OBJ=%JPSPMC%\workdir"
SET "PMFT=%DBTOOLS%\pmftools"
SET "FF=%PMFT%\tools\ffmpeg"

ECHO SET DBTOOLS as %DBTOOLS%
ECHO SET OBJ as %OBJ%
ECHO SET PMFT as %PMFT%
ECHO SET FF as %FF%

SET "FFFLAGS=-hide_banner -loglevel error -y"
ECHO SET FFFLAGS as %FFFLAGS%

REM MediaInfo
SET "MINFO64=%DBTOOLS%\MediaInfo17.10_x64\MediaInfo.exe"
ECHO SET MINFO64 as %MINFO64%

:: IF EXIST "%INPUT%\other" (
PUSHD "%INPUT%\other"
FOR /R %%F IN (*.*) DO (
	IF "%%~xF"==".mp4" (
		SET EXT=mp4
		CALL :VIDEO2AVI "%%F"
	)
	IF "%%~xF"==".mkv" (
		SET EXT=mkv
		CALL :VIDEO2AVI "%%F"
	)
	IF "%%~xF"==".wmv" (
		SET EXT=wmv
		CALL :VIDEO2AVI "%%F"
	)
	IF "%%~xF"==".mpg" (
		SET EXT=mpg
		CALL :VIDEO2AVI "%%F"
	)
	IF "%%~xF"==".vob" (
		SET EXT=vob
		CALL :VIDEO2AVI "%%F"
	)
	IF "%%~xF"==".3gp" (
		SET EXT=3gp
		CALL :VIDEO2AVI "%%F"
	)
	IF "%%~xF"==".mjpeg" (
		SET EXT=mjpeg
		CALL :VIDEO2AVI "%%F"
	)
	IF "%%~xF"==".mts" (
		SET EXT=mts
		CALL :VIDEO2AVI "%%F"
	)
	IF "%%~xF"==".ts" (
		SET EXT=ts
		CALL :VIDEO2AVI "%%F"
	)
)
POPD

:: ) ELSE (
::   ECHO [33m Please put your non-avi files into input\other [0m
:: )

REM IF EXIST "%OBJ%" RD /s /q "%OBJ%"

REM This takes us to the end and doesn't process beyond the end of :VIDEO2AVI
REM GOTO :END

REM Proceed to avi_to_pmf to convert to PMF
GOTO :METHOD1

:VIDEO2AVI
ECHO ----------------------------------------------------------------------
ECHO Processing file [92m %~nx1...[0m

REM Our standard file constants
SET "FILE=%~dpnx1"
SET "FILED=%~dp1"
SET "FILEN=%~n1"
SET "FILEX=%~x1"
SET "FILEZ=%~z1"

ECHO FILE EXISTS AS %FILE%
ECHO FILED SET AS %FILED%
ECHO FILEN SET AS %FILEN%
ECHO FILEX SET AS %FILEX%
ECHO FILEZ SET AS %FILEZ%
ECHO.

REM IF EXIST "%OBJ%" RD /s /q "%OBJ%"
MD "%OBJ%" 2>NUL
IF NOT EXIST "%INPUT%\avi" MD "%INPUT%\avi" 2>NUL

IF EXIST "%INPUT%\avi\%FILEN%.avi" (
	ECHO [91m We detected matching AVI in the target folder^! [0m
	ECHO [91m File: [0m "%INPUT%\avi\%FILEN%.avi"
	ECHO [91m Skipping conversion [0m
	GOTO :POSTCONVERT
)

REM Supported files function - now serves as our main extension based conversion code
PUSHD "%FILED%"

REM Run MediaInfo first to grab input meta
"%MINFO64%" "%FILE%" --Inform=Video;%%FrameRate%% >"%FILED%%FILEN%_video.frate"
"%MINFO64%" "%FILE%" --Inform=Video;%%Height%% >"%FILED%%FILEN%_video.h"
"%MINFO64%" "%FILE%" --Inform=Video;%%Width%% >"%FILED%%FILEN%_video.w"
REM "%MINFO64%" "%FILE%" --Inform=Video;%%DisplayAspectRatio%% >"%FILED%%FILEN%_video.dar"
"%MINFO64%" "%FILE%" --Inform=Video;%%Duration%% >"%FILED%%FILEN%_video.dur"
REM SET /p AFORMAT=<"%FILED%%FILEN%_audio.format"
REM SET /p AFORMAT2=<"%FILED%%FILEN%_audio.codec"
SET /p VFRATE2=<"%FILED%%FILEN%_video.frate"
SET /p VHEIGHT=<"%FILED%%FILEN%_video.h"
SET /p VWIDTH=<"%FILED%%FILEN%_video.w"
REM SET /p VDAR=<"%FILED%%FILEN%_video.dar"
SET /p VDUR=<"%FILED%%FILEN%_video.dur"
REM IF EXIST "%FILED%%FILEN%_audio.format" DEL "%FILED%%FILEN%_audio.format" /q /s >NUL 2>&1
REM IF EXIST "%FILED%%FILEN%_audio.codec" DEL "%FILED%%FILEN%_audio.codec" /q /s >NUL 2>&1
IF EXIST "%FILED%%FILEN%_video.frate" DEL "%FILED%%FILEN%_video.frate" /q /s >NUL 2>&1
IF EXIST "%FILED%%FILEN%_video.h" DEL "%FILED%%FILEN%_video.h" /q /s >NUL 2>&1
IF EXIST "%FILED%%FILEN%_video.w" DEL "%FILED%%FILEN%_video.w" /q /s >NUL 2>&1
IF EXIST "%FILED%%FILEN%_video.dar" DEL "%FILED%%FILEN%_video.dar" /q /s >NUL 2>&1
IF EXIST "%FILED%%FILEN%_video.dur" DEL "%FILED%%FILEN%_video.dur" /q /s >NUL 2>&1

REM ECHO "AFORMAT" = %AFORMAT%
REM ECHO "AFORMAT2" = %AFORMAT2%
ECHO [95m Framerate = %VFRATE2% [0m
ECHO [95m Video Height = %VHEIGHT% [0m
ECHO [95m Video Width = %VWIDTH% [0m
ECHO [95m Duration = %VDUR% [0m
REM ECHO Display Aspect Ratio = %VDAR%

REM Catch videos smaller than XMB icon size and upscale
IF %VHEIGHT% LEQ 80 SET "VHEIGHT=80"
IF %VWIDTH% LEQ 144 SET "VWIDTH=144"

REM Catch videos larger than PSP screen size and downscale
IF %VHEIGHT% GEQ 272 SET "VHEIGHT=272"
IF %VWIDTH% GEQ 480 SET "VWIDTH=480"

REM Throw warning if video over 300s
IF %VDUR% GEQ 300000 ECHO [97m[41m Warning: Video is over 5 minutes long. Results may be unexpected.[0m

REM Hack to get around whole number framerates like 25.000 and return a non-decimal value
REM We can't trim right of the decimal because of odd NTSC values
IF "%VFRATE2%"=="999.999" SET VFRATE=999
IF "%VFRATE2%"=="980.000" SET VFRATE=980
IF "%VFRATE2%"=="960.000" SET VFRATE=960
IF "%VFRATE2%"=="940.000" SET VFRATE=940
IF "%VFRATE2%"=="920.000" SET VFRATE=920
IF "%VFRATE2%"=="900.000" SET VFRATE=900
IF "%VFRATE2%"=="860.000" SET VFRATE=860
IF "%VFRATE2%"=="820.000" SET VFRATE=820
IF "%VFRATE2%"=="780.000" SET VFRATE=780
IF "%VFRATE2%"=="720.000" SET VFRATE=720
IF "%VFRATE2%"=="680.000" SET VFRATE=680
IF "%VFRATE2%"=="540.000" SET VFRATE=540
IF "%VFRATE2%"=="480.000" SET VFRATE=480
IF "%VFRATE2%"=="360.000" SET VFRATE=360
IF "%VFRATE2%"=="240.000" SET VFRATE=240
IF "%VFRATE2%"=="120.000" SET VFRATE=120
IF "%VFRATE2%"=="100.000" SET VFRATE=100
IF "%VFRATE2%"=="90.000" SET VFRATE=90
IF "%VFRATE2%"=="75.000" SET VFRATE=75
IF "%VFRATE2%"=="72.000" SET VFRATE=72
IF "%VFRATE2%"=="60.000" SET VFRATE=60
IF "%VFRATE2%"=="59.940" SET VFRATE=59.94
IF "%VFRATE2%"=="50.000" SET VFRATE=50
IF "%VFRATE2%"=="48.000" SET VFRATE=48
IF "%VFRATE2%"=="30.000" SET VFRATE=30
IF "%VFRATE2%"=="29.970" SET VFRATE=29.97
IF "%VFRATE2%"=="25.000" SET VFRATE=25
IF "%VFRATE2%"=="24.000" SET VFRATE=24
IF "%VFRATE2%"=="23.976" SET VFRATE=23.98
IF "%VFRATE2%"=="20.000" SET VFRATE=20
IF "%VFRATE2%"=="15.000" SET VFRATE=15
IF "%VFRATE2%"=="12.000" SET VFRATE=12
IF "%VFRATE2%"=="10.000" SET VFRATE=10
IF "%VFRATE2%"=="5.000" SET VFRATE=5

REM VFR possibly detected, setting to 30fps
IF "%VFRATE2%" == "" SET VFRATE=30 && SET VFR=TRUE

REM 29fps Hack because we're using B-Frames and specifying GOP size (-bf 2 -g 300)
IF "%VFRATE%"=="29.97" SET VFRATE=30

SET /A VFRATE=%VFRATE%*10

REM Are we an icon?
IF "%ICON%"=="YES" (
	SET "BRATE=96k"
	SET "ABRATE=64k"
	SET "VWIDTH=144"
	SET "VHEIGHT=80"
) ELSE (
	SET "BRATE=512k"
	SET "ABRATE=128k"
	SET "VWIDTH=480"
	SET "VHEIGHT=272"
)

REM Run 2 pass conversion on avi to XVID
ECHO [91m First pass command: "%FF%" -i "%FILE%" -vcodec mpeg4 -vtag XVID -b:v %BRATE% -bf 2 -g %VFRATE%0 -s %VWIDTH%x%VHEIGHT% -pass 1 -an -threads 0 -f rawvideo -y NUL [0m
ECHO [91m Second pass command: "%FF%" -i "%FILE%" -vcodec mpeg4 -vtag XVID -b:v %BRATE% -bf 2 -g %VFRATE%0 -s %VWIDTH%x%VHEIGHT% -acodec libmp3lame -ab %ABRATE% -ar 48000 -ac 2 -pass 2 -threads 0 -f avi "%INPUT%\avi\%FILEN%.avi" [0m
REM Pass 1 write to NULL and generate pass2 settings
"%FF%" -i "%FILE%" -vcodec mpeg4 -vtag XVID -b:v %BRATE% -bf 2 -g %VFRATE%0 -s %VWIDTH%x%VHEIGHT% -pass 1 -an -threads 0 -f rawvideo -y NUL
REM Pass 2
"%FF%" -i "%FILE%" -vcodec mpeg4 -vtag XVID -b:v %BRATE% -bf 2 -g %VFRATE%0 -s %VWIDTH%x%VHEIGHT% -acodec libmp3lame -ab %ABRATE% -ar 48000 -ac 2 -pass 2 -threads 0 -f avi "%INPUT%\avi\%FILEN%.avi"

:POSTCONVERT
EXIT /b

:-------------------------------------------------------------------------------------------------------
:METHOD1
:: Using TeamPBCN's pmftools library

:avi_to_pmf.bat
SET PMFT=%DBTOOLS%\pmftools
SET OUTPUT=%PMFT%\output
SET AC=%PMFT%\tools\autousc

SET FF=%PMFT%\tools\ffmpeg
SET FFFLAGS=-hide_banner -loglevel error -y

SET MP=%PMFT%\tools\mps2pmf
SET PSPSC=%DBTOOLS%\PSP Stream Composer\bin\PSPStreamComposer.exe

IF EXIST "%INPUT%\avi" PUSHD "%INPUT%\avi"
  FOR /R %%F IN (*.avi) DO CALL :AVI2PMF "%%F"
) ELSE (
  ECHO Please put your *.avi files into input\avi
)
REM RD /s /q "%OBJ%"
GOTO :END

:AVI2PMF
ECHO Processing file %~nx1...

REM Our standard file constants
SET "FILE=%~dpnx1"
SET "FILED=%~dp1"
SET "FILEN=%~n1"
SET "FILEX=%~x1"
SET "FILEZ=%~z1"

ECHO FILE EXISTS AS %FILE%
ECHO FILED SET AS %FILED%
ECHO FILEN SET AS %FILEN%
ECHO FILEX SET AS %FILEX%
ECHO FILEZ SET AS %FILEZ%
ECHO.

SET BACKUPNAME=%FILEN%
SET FILEN=JPSPMC_TEMP

REM IF EXIST "%OBJ%" RD /s /q "%OBJ%"

MD "%OBJ%" 2>NUL
MD "%OUTPUT%\pmf" 2>NUL

ECHO FF command: "%FF%" %FFFLAGS% -i "%FILE%" -ar 44100 "%OBJ%\%FILEN%.wav"
"%FF%" %FFFLAGS% -i "%FILE%" -ar 44100 "%OBJ%\%FILEN%.wav"

ECHO AC command: "%AC%" --cn "%FILEN%" --pn "%FILEN%" -a "%OBJ%\%FILEN%.wav" -v "%FILE%" -o "%OBJ%\%FILEN%.MPS" -x "%PSPSC%" 
"%AC%" --cn "%FILEN%" --pn "%FILEN%" -a "%OBJ%\%FILEN%.wav" -v "%FILE%" -o "%OBJ%\%FILEN%.MPS" -x "%PSPSC%" 

REM "%FF%" -i "%OBJ%\%FILEN%.MPS" 2> "%OBJ%\output.tmp"

rem search "  Duration: HH:MM:SS.mm, start: NNNN.NNNN, bitrate: xxxx kb/s"
REM FOR /F "tokens=1,2,3,4,5,6 delims=:., " %%i IN ("%OBJ%\output.tmp") DO (
    REM IF "%%i"=="Duration" (
        REM SET /A min=%%k+%%j*60
        REM SET sec=%%l
    REM )
REM )


ECHO MINFO64 command: "%MINFO64%" "%FILE%" --Inform=Video;%%Duration%% "%FILED%%FILEN%_video.dur"
"%MINFO64%" "%FILE%" --Inform=Video;%%Duration%% >"%FILED%%FILEN%_video.dur"
SET /p VDUR=<"%FILED%%FILEN%_video.dur"
IF EXIST "%FILED%%FILEN%_video.dur" DEL "%FILED%%FILEN%_video.dur" /q /s >NUL 2>&1
ECHO VDUR = %VDUR%
SET /A sec=%VDUR%/1000
ECHO secs = %sec%
SET /A min=%sec%/60
ECHO mins = %min%

SET MPOPTS=-m %min% -s %sec%

REM Are we an icon?
IF "%ICON%"=="YES" SET MPOPTS=-m %min% -s %sec% -c

ECHO MP command: "%MP%" -i "%OBJ%\%FILEN%.MPS" -o "%OUTPUT%\pmf\%FILEN%.PMF" %MPOPTS%
"%MP%" -i "%OBJ%\%FILEN%.MPS" -o "%OUTPUT%\pmf\%FILEN%.PMF" %MPOPTS%

REN "%OBJ%\%FILEN%.MPS" "%BACKUPNAME%.MPS"
REN "%OBJ%\%FILEN%.wav" "%BACKUPNAME%.wav"
REN "%OUTPUT%\pmf\%FILEN%.PMF" "%BACKUPNAME%.PMF"

EXIT /b

:pmf_to_mp4.bat
set FF=%PMFT%\tools\ffmpeg
set FFFLAGS=-hide_banner -loglevel error -y
set PD=%PMFT%\tools\psmfdump

if exist "%INPUT%\pmf" (
  for %%f in ("%INPUT%\pmf\*.pmf") do call :PMF2MP4 %%f
) else (
  echo Please put your *.pmf files into input\pmf
)
REM rd /s /q "%OBJ%"
goto :END

:PMF2MP4
echo Processing file "%FILE%"...
REM if exist "%OBJ%" (
  REM rd /s /q "%OBJ%"
REM )
md "%OBJ%" 2>NUL
md "%OUTPUT%\mp4" 2>NUL
"%PD%" "%FILE%" -a "%OBJ%\%~n1.oma" -v "%OBJ%\%~n1.264"
"%FF%" %FFFLAGS% -i "%OBJ%\%~n1.264" -i "%OBJ%\%~n1.oma" -map 0 -map 1 -s %VWIDTH%x%VHEIGHT% "%OUTPUT%\mp4\%~n1.mp4
exit /b

:-------------------------------------------------------------------------------------------------------
:METHOD2
REM Using ikskoks's MediEvil tutorial - Relies on interacting with PSP Stream Composer UI
REM so the following can't be fully automated :(

:PMF to AVI conversion
REM mplayer -dumpvideo <pmf_file_path>

REM mencoder.exe stream.dump -ovc raw -noskip -ofps 29.97 -o done.avi

REM OMA Audio from PMF file using vgm toolbox

REM Convert OMA to WAV

REM Use virtualdub to merge audio and video to AVI file.

REM [optionally] Use AVI ReComp to add subtitles to AVI and decrease file size.

:AVI to PMF conversion:
REM 1. Run PSP Stream Composer
REM 2. Create new project in PSP Stream Composer. Remember to check option "PSP Movie".
REM 3. Drag your AVI and WAV files to PSP Stream Composer window.
REM 4. Compile MPS file in PSP Stream Composer using option "Encode+Multiplex".

REM 5. Create PMF using MPStoPMF or PmfCreator tools.

:-------------------------------------------------------------------------------------------------------
:METHOD3
REM Using PSLover14's joined guide from "Converting Guide.txt" in the MPS to PMF Converter Zip
REM Also relies on interacting with PSP Stream Composer UI
REM so the following can't be fully automated :(

:END

PAUSE

EXIT