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

SET "WORKDIR=K:\GitHub\JMD-PSP-Tools\ISO Tools\bin"

SET "OUTPUT=%~dp0"

REM Setup macro paths
SET "CDRTOOLS=%WORKDIR%"
SET "MKISOFS=%CDRTOOLS%\mkisofs.exe"
SET "MKISOFS_LOG=%CDRTOOLS%\mkisofs.log"
SET "ISOINFO=%CDRTOOLS%\isoinfo.exe"
SET "MCISO=%WORKDIR%\mciso-amd64.exe"
SET "NIRCMD=%WORKDIR%\nircmd.exe"

FOR /R %%G IN (*.rar) DO (

	PUSHD "%%~dpG"
	
	REM Get UID from input folder name and set it as VOLID
	FOR /F "tokens=1,2,3 delims=[]" %%G IN ("%%~nG") DO SET VOLID=%%H
	
	FOR /F "tokens=1,2,3,4 delims=()" %%K IN ("%%~nG") DO (
		ECHO --------------------------------------
		ECHO [96mTitle:[0m %%K && SET GAME=%%K
		ECHO [94mTitle ID:[0m !VOLID!
		ECHO [36mRegion:[0m %%L && SET REGION=%%L
		ECHO [34mLanguages:[0m %%N && SET LANG=%%N
		ECHO --------------------------------------
		ECHO.
	)

	ECHO [37mExtracting !GAME! [0m && ECHO ------------------------------------
	
	REM IF EXIST "%%~dpnG.txt" MOVE "%%~dpnG.txt" "%%~dpG%%~nG\%%~nG.txt" && IF EXIST "%%~dpnG_info.txt" MOVE "%%~dpnG_info.txt" "%%~dpG%%~nG\%%~nG_info.txt"	
	
	"C:\Program Files\7-Zip\7z.exe" e "%%G"
	
	ECHO [92mDone^^! [0m && ECHO --------------------------------------
	
	REM Compress to CSO
	ECHO [37mCompressing ISO to CSO [0m
	ECHO.
	"%MCISO%" 9 "%OUTPUT%%%~nG.iso" "%OUTPUT%%%~nG.cso"
	ECHO [92mDone^^! [0m && ECHO --------------------------------------
	ECHO.
	
	IF EXIST "%OUTPUT%%%~nG.iso" DEL "%OUTPUT%%%~nG.iso" /q /s >NUL 2>&1
	IF EXIST "%OUTPUT%%%~nG" @RD /S /Q "%OUTPUT%%%~nG" >NUL 2>&1
	
	ECHO [92mDone^^! [0m
)


ECHO [92mAll done^^! [0m

PAUSE
EXIT

:: Usage: 7z <command> [<switches>...] <archive_name> [<file_names>...] [@listfile]
:: 
:: <Commands>
::   a : Add files to archive
::   b : Benchmark
::   d : Delete files from archive
::   e : Extract files from archive (without using directory names)
::   h : Calculate hash values for files
::   i : Show information about supported formats
::   l : List contents of archive
::   rn : Rename files in archive
::   t : Test integrity of archive
::   u : Update files to archive
::   x : eXtract files with full paths
:: 
:: <Switches>
::   -- : Stop switches and @listfile parsing
::   -ai[r[-|0]]{@listfile|!wildcard} : Include archives
::   -ax[r[-|0]]{@listfile|!wildcard} : eXclude archives
::   -ao{a|s|t|u} : set Overwrite mode
::   -an : disable archive_name field
::   -bb[0-3] : set output log level
::   -bd : disable progress indicator
::   -bs{o|e|p}{0|1|2} : set output stream for output/error/progress line
::   -bt : show execution time statistics
::   -i[r[-|0]]{@listfile|!wildcard} : Include filenames
::   -m{Parameters} : set compression Method
::     -mmt[N] : set number of CPU threads
::     -mx[N] : set compression level: -mx1 (fastest) ... -mx9 (ultra)
::   -o{Directory} : set Output directory
::   -p{Password} : set Password
::   -r[-|0] : Recurse subdirectories
::   -sa{a|e|s} : set Archive name mode
::   -scc{UTF-8|WIN|DOS} : set charset for for console input/output
::   -scs{UTF-8|UTF-16LE|UTF-16BE|WIN|DOS|{id}} : set charset for list files
::   -scrc[CRC32|CRC64|SHA1|SHA256|*] : set hash function for x, e, h commands
::   -sdel : delete files after compression
::   -seml[.] : send archive by email
::   -sfx[{name}] : Create SFX archive
::   -si[{name}] : read data from stdin
::   -slp : set Large Pages mode
::   -slt : show technical information for l (List) command
::   -snh : store hard links as links
::   -snl : store symbolic links as links
::   -sni : store NT security information
::   -sns[-] : store NTFS alternate streams
::   -so : write data to stdout
::   -spd : disable wildcard matching for file names
::   -spe : eliminate duplication of root folder for extract command
::   -spf : use fully qualified file paths
::   -ssc[-] : set sensitive case mode
::   -sse : stop archive creating, if it can't open some input file
::   -ssw : compress shared files
::   -stl : set archive timestamp from the most recently modified file
::   -stm{HexMask} : set CPU thread affinity mask (hexadecimal number)
::   -stx{Type} : exclude archive type
::   -t{Type} : Set type of archive
::   -u[-][p#][q#][r#][x#][y#][z#][!newArchiveName] : Update options
::   -v{Size}[b|k|m|g] : Create volumes
::   -w[{path}] : assign Work directory. Empty path means a temporary directory
::   -x[r[-|0]]{@listfile|!wildcard} : eXclude filenames
::   -y : assume Yes on all queries