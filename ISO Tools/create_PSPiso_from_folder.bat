@ECHO OFF

REM Set master local expansion and command extensions.
REM USE ONCE
@SetLocal enableextensions EnableDelayedExpansion

SET "WORKDIR=K:\GitHub\JMD-PSP-Tools\ISO Tools\bin"

SET INDIR=%~1
SET LSTFILE1=%~dp0\%~n1_files.txt
SET LSTFILE2=%~dp0\%~n1_timestamps.txt
SET LSTFILE3=%~dp0\%~n1_timestamps_sorted.txt

PUSHD "%INDIR%"

ECHO ------------------------- > "%LSTFILE1%"
ECHO File timestamp query tool >> "%LSTFILE1%"
ECHO ------------------------- >> "%LSTFILE1%"
ECHO. >> "%LSTFILE1%"
ECHO -------------------------
ECHO File timestamp query tool
ECHO -------------------------
ECHO.

FOR /R %%G IN (*) DO (

	PUSHD "%%~dpG"
		REM We need to wrap the FORFILES in a FOR /F loop to strip the quotes from the output
		REM NOTE: DOES NOT SUPPORT FILENAMES WITH SPACES
		
		FOR /F "tokens=1,2,3,4 delims= " %%J IN ('FORFILES /M "*%%~nxG" /C "cmd /c ECHO @file @fdate @ftime"') DO (
		
			ECHO ------------------------- >> "%LSTFILE1%"
			ECHO Filename: %%~J >> "%LSTFILE1%"
			
			REM ECHO Date: %%~K
			FOR /F "tokens=1,2,3 delims=/" %%N IN ("%%~K") DO (
			
				REM Zero padded
				SET "FDD=00%%N"
				SET "DAY=!FDD:~-2!
				
				REM Zero padded
				SET "FMM=00%%O"
				SET "MONTH=!FMM:~-2!
				
				SET FYYYY=%%P
				SET YEAR=%%P
			)
			
			REM ECHO Time: %%~L
			FOR /F "tokens=1,2,3 delims=:" %%Q IN ("%%~L") DO (
			
				REM Zero padded
				SET "FHH=00%%Q"
				SET "HOUR=!FHH:~-2!
				
				REM Zero padded
				SET "FMIN=00%%R"
				SET "MINUTE=!FMIN:~-2!
				
				REM Zero padded
				SET "FSEC=00%%S"
				SET "SECOND=!FSEC:~-2!
				
			)
			
			REM ECHO AM^/PM: %%~M
			SET AMPM=%%~M
			
			REM 24HR conversion
			IF "!AMPM!"=="PM" (
				IF "!HOUR!"=="01" SET HOUR=13
				IF "!HOUR!"=="02" SET HOUR=14
				IF "!HOUR!"=="03" SET HOUR=15
				IF "!HOUR!"=="04" SET HOUR=16
				IF "!HOUR!"=="05" SET HOUR=17
				IF "!HOUR!"=="06" SET HOUR=18
				IF "!HOUR!"=="07" SET HOUR=19
				IF "!HOUR!"=="08" SET HOUR=20
				IF "!HOUR!"=="09" SET HOUR=21
				IF "!HOUR!"=="10" SET HOUR=22
				IF "!HOUR!"=="11" SET HOUR=23
			)
			IF "!AMPM!"=="AM" (
				IF "!HOUR!"=="12" SET HOUR=00
			)
			
			ECHO Last Modified: !YEAR!-!MONTH!-!DAY! at !HOUR!:!MINUTE!:!SECOND! in the !AMPM! >> "%LSTFILE1%"
			ECHO ------------------------- >> "%LSTFILE1%"
			ECHO. >> "%LSTFILE1%"
			
			ECHO !YEAR!-!MONTH!-!DAY!;!HOUR!-!MINUTE!-!SECOND!;"%%~J" >> "%LSTFILE2%"
		)
	POPD
	
	PUSHD "%INDIR%"
)


rem Separate list elements into an array, use X as a dummy value for array elements
FOR /F %%a IN ('TYPE "%LSTFILE2%"') DO (
   set elem[%%a]=X
)
rem Process the elements in sorted order:
FOR /F "tokens=2 delims=[]" %%a IN ('SET elem[') DO ECHO %%a >> "%LSTFILE3%"

REM Grab the last line from the sorted list (most recent file)
FOR /F "usebackq delims==" %%A IN ("%LSTFILE3%") DO SET "lastline=%%A"
REM ECHO %lastline%

SET /P firstline=<"%LSTFILE3%"
REM ECHO %firstline%

IF EXIST "%LSTFILE1%" DEL "%LSTFILE1%" /q /s >NUL 2>&1
IF EXIST "%LSTFILE2%" DEL "%LSTFILE2%" /q /s >NUL 2>&1
IF EXIST "%LSTFILE3%" DEL "%LSTFILE3%" /q /s >NUL 2>&1

REM ECHO Oldest file is: %firstline%
REM ECHO Newest file is: %lastline%

ECHO.

:OLDEST

::2016-03-08_06-30-02_"jmt.rcheader.reg.old" 
FOR /F "tokens=1-3 delims=;" %%G IN ("%firstline%") DO (
	REM ECHO Oldest date: %%~G
	REM ECHO Oldest time: %%~H
	REM ECHO Oldest filename: %%I
	
	REM 24HR reverse conversion
	FOR /F "tokens=1-3 delims=-" %%K IN ("%%~H") DO SET "HOUR=%%~K" && SET "MINUTE=%%~L" && SET "SECOND=%%~M" && SET "NIRTIME=%%K:%%L:%%M"
	SET AMPM=AM
	IF "!HOUR!"=="13" SET "HOUR=1" && SET AMPM=PM
	IF "!HOUR!"=="14" SET "HOUR=2" && SET AMPM=PM
	IF "!HOUR!"=="15" SET "HOUR=3" && SET AMPM=PM
	IF "!HOUR!"=="16" SET "HOUR=4" && SET AMPM=PM
	IF "!HOUR!"=="17" SET "HOUR=5" && SET AMPM=PM
	IF "!HOUR!"=="18" SET "HOUR=6" && SET AMPM=PM
	IF "!HOUR!"=="19" SET "HOUR=7" && SET AMPM=PM
	IF "!HOUR!"=="20" SET "HOUR=8" && SET AMPM=PM
	IF "!HOUR!"=="21" SET "HOUR=9" && SET AMPM=PM
	IF "!HOUR!"=="22" SET "HOUR=10" && SET AMPM=PM
	IF "!HOUR!"=="23" SET "HOUR=11" && SET AMPM=PM
	IF "!HOUR!"=="00" SET "HOUR=12"
	
	REM Strip leading zeros
	IF "!HOUR!"=="01" SET "SMM=!HOUR!" && SET "SMMOLD=!SMM:~-1! && SET "HOUR=!SMMOLD!"
	IF "!HOUR!"=="02" SET "SMM=!HOUR!" && SET "SMMOLD=!SMM:~-1! && SET "HOUR=!SMMOLD!"
	IF "!HOUR!"=="03" SET "SMM=!HOUR!" && SET "SMMOLD=!SMM:~-1! && SET "HOUR=!SMMOLD!"
	IF "!HOUR!"=="04" SET "SMM=!HOUR!" && SET "SMMOLD=!SMM:~-1! && SET "HOUR=!SMMOLD!"
	IF "!HOUR!"=="05" SET "SMM=!HOUR!" && SET "SMMOLD=!SMM:~-1! && SET "HOUR=!SMMOLD!"
	IF "!HOUR!"=="06" SET "SMM=!HOUR!" && SET "SMMOLD=!SMM:~-1! && SET "HOUR=!SMMOLD!"
	IF "!HOUR!"=="07" SET "SMM=!HOUR!" && SET "SMMOLD=!SMM:~-1! && SET "HOUR=!SMMOLD!"
	IF "!HOUR!"=="08" SET "SMM=!HOUR!" && SET "SMMOLD=!SMM:~-1! && SET "HOUR=!SMMOLD!"
	IF "!HOUR!"=="09" SET "SMM=!HOUR!" && SET "SMMOLD=!SMM:~-1! && SET "HOUR=!SMMOLD!"
	
	FOR /F "tokens=1-3 delims=-" %%K IN ("%%~G") DO (
		IF "%%L"=="01" SET LONGMMOLD=January
		IF "%%L"=="02" SET LONGMMOLD=February
		IF "%%L"=="03" SET LONGMMOLD=March
		IF "%%L"=="04" SET LONGMMOLD=April
		IF "%%L"=="05" SET LONGMMOLD=May
		IF "%%L"=="06" SET LONGMMOLD=June
		IF "%%L"=="07" SET LONGMMOLD=July
		IF "%%L"=="08" SET LONGMMOLD=August
		IF "%%L"=="09" SET LONGMMOLD=September
		IF "%%L"=="10" SET LONGMMOLD=October
		IF "%%L"=="11" SET LONGMMOLD=November
		IF "%%L"=="12" SET LONGMMOLD=December
		
		REM We have to do some IF nonsense to strip the zero padding on the date we added earlier
		SET "WINDATEOLD=%%M !LONGMMOLD! %%K"
		IF "%%M"=="01" SET SDD=%%M && SET "SDDOLD=!SDD:~-1! && SET "WINDATEOLD=!SDDOLD! !LONGMMOLD! %%K"
		IF "%%M"=="02" SET SDD=%%M && SET "SDDOLD=!SDD:~-1! && SET "WINDATEOLD=!SDDOLD! !LONGMMOLD! %%K"
		IF "%%M"=="03" SET SDD=%%M && SET "SDDOLD=!SDD:~-1! && SET "WINDATEOLD=!SDDOLD! !LONGMMOLD! %%K"
		IF "%%M"=="04" SET SDD=%%M && SET "SDDOLD=!SDD:~-1! && SET "WINDATEOLD=!SDDOLD! !LONGMMOLD! %%K"
		IF "%%M"=="05" SET SDD=%%M && SET "SDDOLD=!SDD:~-1! && SET "WINDATEOLD=!SDDOLD! !LONGMMOLD! %%K"
		IF "%%M"=="06" SET SDD=%%M && SET "SDDOLD=!SDD:~-1! && SET "WINDATEOLD=!SDDOLD! !LONGMMOLD! %%K"
		IF "%%M"=="07" SET SDD=%%M && SET "SDDOLD=!SDD:~-1! && SET "WINDATEOLD=!SDDOLD! !LONGMMOLD! %%K"
		IF "%%M"=="08" SET SDD=%%M && SET "SDDOLD=!SDD:~-1! && SET "WINDATEOLD=!SDDOLD! !LONGMMOLD! %%K"
		IF "%%M"=="09" SET SDD=%%M && SET "SDDOLD=!SDD:~-1! && SET "WINDATEOLD=!SDDOLD! !LONGMMOLD! %%K"
		
		SET "WINDATETIMEOLD=%%M^/%%L^/%%K !HOUR!^:!MINUTE!^:!SECOND! !AMPM!"
		SET "NIRDATETIMEOLD=%%M^/%%L^/%%K !NIRTIME!"
		
	)
	
	FOR /F "tokens=1-3 delims=-" %%K IN ("%%~H") DO SET "WINTIMEOLD=%%K:%%L:%%M"
	
)

ECHO.

:NEWEST

FOR /F "tokens=1-3 delims=;" %%G IN ("%lastline%") DO (
	REM ECHO Newest date: %%~G
	REM ECHO Newest time: %%~H
	REM ECHO Newest filename: %%I
		
	REM 24HR reverse conversion
	FOR /F "tokens=1-3 delims=-" %%K IN ("%%~H") DO SET "HOUR=%%~K" && SET "MINUTE=%%~L" && SET "SECOND=%%~M" && SET "NIRTIME=%%K:%%L:%%M"
	SET AMPM=AM
	IF "!HOUR!"=="13" SET "HOUR=1" && SET AMPM=PM
	IF "!HOUR!"=="14" SET "HOUR=2" && SET AMPM=PM
	IF "!HOUR!"=="15" SET "HOUR=3" && SET AMPM=PM
	IF "!HOUR!"=="16" SET "HOUR=4" && SET AMPM=PM
	IF "!HOUR!"=="17" SET "HOUR=5" && SET AMPM=PM
	IF "!HOUR!"=="18" SET "HOUR=6" && SET AMPM=PM
	IF "!HOUR!"=="19" SET "HOUR=7" && SET AMPM=PM
	IF "!HOUR!"=="20" SET "HOUR=8" && SET AMPM=PM
	IF "!HOUR!"=="21" SET "HOUR=9" && SET AMPM=PM
	IF "!HOUR!"=="22" SET "HOUR=10" && SET AMPM=PM
	IF "!HOUR!"=="23" SET "HOUR=11" && SET AMPM=PM
	IF "!HOUR!"=="00" SET "HOUR=12"
	
	REM Strip leading zeros
	IF "!HOUR!"=="01" SET "SMM=!HOUR!" && SET "SMMNEW=!SMM:~-1! && SET "HOUR=!SMMNEW!"
	IF "!HOUR!"=="02" SET "SMM=!HOUR!" && SET "SMMNEW=!SMM:~-1! && SET "HOUR=!SMMNEW!"
	IF "!HOUR!"=="03" SET "SMM=!HOUR!" && SET "SMMNEW=!SMM:~-1! && SET "HOUR=!SMMNEW!"
	IF "!HOUR!"=="04" SET "SMM=!HOUR!" && SET "SMMNEW=!SMM:~-1! && SET "HOUR=!SMMNEW!"
	IF "!HOUR!"=="05" SET "SMM=!HOUR!" && SET "SMMNEW=!SMM:~-1! && SET "HOUR=!SMMNEW!"
	IF "!HOUR!"=="06" SET "SMM=!HOUR!" && SET "SMMNEW=!SMM:~-1! && SET "HOUR=!SMMNEW!"
	IF "!HOUR!"=="07" SET "SMM=!HOUR!" && SET "SMMNEW=!SMM:~-1! && SET "HOUR=!SMMNEW!"
	IF "!HOUR!"=="08" SET "SMM=!HOUR!" && SET "SMMNEW=!SMM:~-1! && SET "HOUR=!SMMNEW!"
	IF "!HOUR!"=="09" SET "SMM=!HOUR!" && SET "SMMNEW=!SMM:~-1! && SET "HOUR=!SMMNEW!"
	
	FOR /F "tokens=1-3 delims=-" %%K IN ("%%~G") DO (
		SET "MODDATE=%%K%%L%%M"
		SET "CPYDATE=%%M/%%L/%%K"
		
		IF "%%L"=="01" SET LONGMMNEW=January
		IF "%%L"=="02" SET LONGMMNEW=February
		IF "%%L"=="03" SET LONGMMNEW=March
		IF "%%L"=="04" SET LONGMMNEW=April
		IF "%%L"=="05" SET LONGMMNEW=May
		IF "%%L"=="06" SET LONGMMNEW=June
		IF "%%L"=="07" SET LONGMMNEW=July
		IF "%%L"=="08" SET LONGMMNEW=August
		IF "%%L"=="09" SET LONGMMNEW=September
		IF "%%L"=="10" SET LONGMMNEW=October
		IF "%%L"=="11" SET LONGMMNEW=November
		IF "%%L"=="12" SET LONGMMNEW=December
		
		REM We have to do some IF nonsense to strip the zero padding on the date we added earlier
		SET "WINDATENEW=%%M !LONGMMNEW! %%K"
		IF "%%M"=="01" SET SDD=%%M && SET "SDDNEW=!SDD:~-1! && SET "WINDATENEW=!SDDNEW! !LONGMMNEW! %%K"
		IF "%%M"=="02" SET SDD=%%M && SET "SDDNEW=!SDD:~-1! && SET "WINDATENEW=!SDDNEW! !LONGMMNEW! %%K"
		IF "%%M"=="03" SET SDD=%%M && SET "SDDNEW=!SDD:~-1! && SET "WINDATENEW=!SDDNEW! !LONGMMNEW! %%K"
		IF "%%M"=="04" SET SDD=%%M && SET "SDDNEW=!SDD:~-1! && SET "WINDATENEW=!SDDNEW! !LONGMMNEW! %%K"
		IF "%%M"=="05" SET SDD=%%M && SET "SDDNEW=!SDD:~-1! && SET "WINDATENEW=!SDDNEW! !LONGMMNEW! %%K"
		IF "%%M"=="06" SET SDD=%%M && SET "SDDNEW=!SDD:~-1! && SET "WINDATENEW=!SDDNEW! !LONGMMNEW! %%K"
		IF "%%M"=="07" SET SDD=%%M && SET "SDDNEW=!SDD:~-1! && SET "WINDATENEW=!SDDNEW! !LONGMMNEW! %%K"
		IF "%%M"=="08" SET SDD=%%M && SET "SDDNEW=!SDD:~-1! && SET "WINDATENEW=!SDDNEW! !LONGMMNEW! %%K"
		IF "%%M"=="09" SET SDD=%%M && SET "SDDNEW=!SDD:~-1! && SET "WINDATENEW=!SDDNEW! !LONGMMNEW! %%K"
		
		SET "WINDATETIMENEW=%%M^/%%L^/%%K !HOUR!^:!MINUTE!^:!SECOND! !AMPM!"
		SET "NIRDATETIMENEW=%%M^/%%L^/%%K !NIRTIME!"
		
	)
	
	FOR /F "tokens=1-3 delims=-" %%K IN ("%%~H") DO SET "WINTIMENEW=%%K:%%L:%%M"
	
)

ECHO.
ECHO.

REM ECHO Windows compliant datetime for oldest file: "%WINDATEOLD% %WINTIMEOLD%"
REM ECHO Windows compliant datetime for newest file: "%WINDATENEW% %WINTIMENEW%"

REM ECHO.
REM ECHO.

POPD
POPD


CLS

ECHO ===============================================================
ECHO                     %~nx0
ECHO             (c)2022 JMDigital. All Rights Reserved.
ECHO ===============================================================
ECHO.

REM Setup macro paths
SET "CDRTOOLS=%WORKDIR%"
SET "MKISOFS=%CDRTOOLS%\mkisofs.exe"
SET "MKISOFS_LOG=%CDRTOOLS%\mkisofs.log"
SET "ISOINFO=%CDRTOOLS%\isoinfo.exe"
SET "MCISO=%WORKDIR%\mciso-amd64.exe"
SET "NIRCMD=%WORKDIR%\nircmd.exe"

ECHO Processing:
ECHO.

REM Get UID from input folder name and set it as VOLID
FOR /F "tokens=1,2,3 delims=[]" %%G IN ("%~n1") DO SET VOLID=%%H

FOR /F "tokens=1,2,3,4 delims=()" %%K IN ("%~n1") DO (
	ECHO --------------------------------------
	ECHO Title: %%K && SET GAME=%%K
	ECHO Title ID: %VOLID%
	ECHO Region: %%L && SET REGION=%%L
	ECHO Languages: %%N && SET LANG=%%N
	ECHO --------------------------------------
	ECHO.
)

SET OPTS=-A "PSP GAME" -p "JENKINS" -publisher "JMDIGITAL" -sysid "PSP GAME" -V "%VOLID%" -volset "%REGION%" -iso-level 4 -modification-date "%MODDATE%" -copyright "%CPYDATE%" -ignore-error -U

SET "OUTPUT=%~dp0"

::   -o FILE, -output FILE       Set output file name
::   -path-list FILE             File with list of pathnames to process
::   -modification-date DATE     Set the modification date field of the PVD

REM DIR "%~dpn1\*.*" /S /S /B /A:-D > "%~n1_files.txt"

:: nircmd.exe setfiletime [filename or wildcard] [Created Date] {Modified Date} {Accessed Date}
:: dd-mm-yyyy hh:mm:ss
REM This only works on XP
REM "%NIRCMD%" setfilefoldertime "%~1" "%NIRDATETIMEOLD%" "" ""
REM "%NIRCMD%" setfilefoldertime "%~1\PSP_GAME" "%NIRDATETIMEOLD%" "" ""
REM "%NIRCMD%" setfilefoldertime "%~1\PSP_GAME\SYSDIR" "%NIRDATETIMEOLD%" "" ""
REM "%NIRCMD%" setfilefoldertime "%~1\PSP_GAME\SYSDIR\UPDATE" "%NIRDATETIMEOLD%" "" ""
REM "%NIRCMD%" setfilefoldertime "%~1\PSP_GAME\USRDIR" "%NIRDATETIMEOLD%" "" ""

REM "%MKISOFS%" %OPTS% -path-list "%~n1_files.txt" -o "%OUTPUT%%~n1.iso"
ECHO Creating PSP Compliant ISO
ECHO.
"%MKISOFS%" %OPTS% -o "%OUTPUT%%~n1.iso" "%~1"
ECHO Done
ECHO --------------------------------------
ECHO.

REM Compress to CSO
ECHO Compressing ISO to CSO
ECHO.
"%MCISO%" 9 "%OUTPUT%%~n1.iso" "%OUTPUT%%~n1.cso"
ECHO Done
ECHO --------------------------------------
ECHO.

REM Create an ISO info txt
ECHO Creating %~n1_info.txt
ECHO.
"%ISOINFO%" -d -i "%OUTPUT%%~n1.iso" > "%OUTPUT%%~n1_info.txt"
ECHO. >> "%OUTPUT%%~n1_info.txt"
ECHO Reported language support: %LANG% >> "%OUTPUT%%~n1_info.txt"
ECHO. >> "%OUTPUT%%~n1_info.txt"
"%ISOINFO%" -l -i "%OUTPUT%%~n1.iso" >> "%OUTPUT%%~n1_info.txt"
ECHO Done
ECHO --------------------------------------
ECHO.

:---------------------------------------------------------------------
:DATE CHANGER
:---------------------------------------------------------------------
REM Date created
REM Best to leave it as the present

REM Date modified
:: changedate.ps1
:: # Change the last write date/timestamp of our disc files
:: (Get-Item "%OUTPUT%%~n1.iso").LastWriteTime=("%WINDATENEW% %WINTIMENEW%")
:: (Get-Item "%OUTPUT%%~n1.cso").LastWriteTime=("%WINDATENEW% %WINTIMENEW%")
REM ECHO # Change the last write date/timestamp of our disc files > "%OUTPUT%changedate.ps1"
REM ECHO (Get-Item "%OUTPUT%%~n1.iso").LastWriteTime=("%WINDATENEW% %WINTIMENEW%") >> "%OUTPUT%changedate.ps1"
REM ECHO (Get-Item "%OUTPUT%%~n1.cso").LastWriteTime=("%WINDATENEW% %WINTIMENEW%") >> "%OUTPUT%changedate.ps1"

REM ECHO # Change the last write date/timestamp of %~n1.iso > "%OUTPUT%changedate_iso.ps1"
REM ECHO $a = Get-Date "%WINDATETIMENEW%" >> "%OUTPUT%changedate_iso.ps1"
REM ECHO $d = get-item "%OUTPUT%%~n1.iso" >> "%OUTPUT%changedate_iso.ps1"
REM ECHO $d.LastWriteTime = $a >> "%OUTPUT%changedate_iso.ps1"

REM ECHO # Change the last write date/timestamp of %~n1.cso > "%OUTPUT%changedate_cso.ps1"
REM ECHO $a = Get-Date "%WINDATETIMENEW%" >> "%OUTPUT%changedate_cso.ps1"
REM ECHO $d = get-item "%OUTPUT%%~n1.cso" >> "%OUTPUT%changedate_cso.ps1"
REM ECHO $d.LastWriteTime = $a >> "%OUTPUT%changedate_cso.ps1"

REM REN "%OUTPUT%%~n1.iso" "temp.iso"
REM REN "%OUTPUT%%~n1.cso" "temp.cso"
REM ECHO # Change the last write date/timestamp of %~n1.iso > "%OUTPUT%changedate_iso.ps1"
REM ECHO $(Get-Item temp.iso).lastwritetime=$(Get-Date "%WINDATETIMENEW%") >> "%OUTPUT%changedate_iso.ps1"

REM ECHO # Change the last write date/timestamp of %~n1.cso > "%OUTPUT%changedate_cso.ps1"
REM ECHO $(Get-Item temp.cso).lastwritetime=$(Get-Date "%WINDATETIMENEW%") >> "%OUTPUT%changedate_cso.ps1"

REM Execute above as admin
REM PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%OUTPUT%changedate_iso.ps1""' -Verb RunAs}"
REM PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%OUTPUT%changedate_cso.ps1""' -Verb RunAs}"

REM REN "%OUTPUT%temp.iso" "%~n1.iso"
REM REN "%OUTPUT%temp.cso" "%~n1.cso"



REM None of the above works for whatever reason. Now using nircmd 3rd party tool to achieve the above

:: nircmd.exe setfiletime [filename or wildcard] [Created Date] {Modified Date} {Accessed Date}
:: dd-mm-yyyy hh:mm:ss
"%NIRCMD%" setfiletime "%OUTPUT%%~n1.iso" "%NIRDATETIMEOLD%" "%NIRDATETIMENEW%" now
"%NIRCMD%" setfiletime "%OUTPUT%%~n1.cso" "%NIRDATETIMEOLD%" "%NIRDATETIMENEW%" now

:---------------------------------------------------------------------

REM Remove the generated ISO
ECHO Removing generated ISO
ECHO.
IF EXIST "%OUTPUT%%~n1.iso" DEL "%OUTPUT%%~n1.iso" /q /s >NUL 2>&1
ECHO Done
ECHO.
ECHO.
ECHO ===============================================================
ECHO If you would like to remove the folder you can do so now manually via File Explorer.
ECHO.

PAUSE

EXIT

:: Usage: mciso <level> <infile> <outfile>
:: 
::         level:  1-9     compression level for ISO to CSO
::                         from 1=large/fast to 9=small/slow
::                 0       decompress CSO to ISO
::         infile:         Input file, ISO for levels 1-9, CSO for level 0
::         outfile:        Output file, opposite format of input file
:: 
:: Example compression:    mciso 3 game.iso game.cso
:: Example decompression:  mciso 0 game.cso game.iso

:: Usage: mkisofs [options] [-find] file... [find expression]
:: Options:
::   -find file... [find expr.]  Option separator: Use find command line to the right
::   -posix-H                    Follow symbolic links encountered on command line
::   -posix-L                    Follow all symbolic links
::   -posix-P                    Do not follow symbolic links (default)
::   -abstract FILE              Set Abstract filename
::   -A ID, -appid ID            Set Application ID
::   -biblio FILE                Set Bibliographic filename
::   -cache-inodes               Cache inodes (needed to detect hard links)
::   -no-cache-inodes            Do not cache inodes (if filesystem has no unique inodes)
::   -rrip110                    Create old Rock Ridge V 1.10
::   -rrip112                    Create new Rock Ridge V 1.12 (default)
::   -check-oldnames             Check all imported ISO9660 names from old session
::   -check-session FILE         Check all ISO9660 names from previous session
::   -copyright FILE             Set Copyright filename
::   -debug                      Set debug flag
::   -ignore-error               Ignore errors
::   -b FILE, -eltorito-boot FILE
::                               Set El Torito boot image name
::   -eltorito-alt-boot          Start specifying alternative El Torito boot parameters
::   -eltorito-platform ID       Set El Torito platform id for the next boot entry
::   -B FILES, -sparc-boot FILES Set sparc boot image names
::   -sunx86-boot FILES          Set sunx86 boot image names
::   -G FILE, -generic-boot FILE Set generic boot image name
::   -sparc-label label text     Set sparc boot disk label
::   -sunx86-label label text    Set sunx86 boot disk label
::   -c FILE, -eltorito-catalog FILE
::                               Set El Torito boot catalog name
::   -C PARAMS, -cdrecord-params PARAMS
::                               Magic paramters from cdrecord
::   -d, -omit-period            Omit trailing periods from filenames (violates ISO9660)
::   -data-change-warn           Treat data/size changes as warning only
::   -dir-mode mode              Make the mode of all directories this mode.
::   -D, -disable-deep-relocation
::                               Disable deep directory relocation (violates ISO9660)
::   -file-mode mode             Make the mode of all plain files this mode.
::   -errctl name                Read error control defs from file or inline.
::   -f, -follow-links           Follow symbolic links
::   -gid gid                    Make the group owner of all files this gid.
::   -graft-points               Allow to use graft points for filenames
::   -root DIR                   Set root directory for all new files and directories
::   -old-root DIR               Set root directory in previous session that is searched for files
::   -help                       Print option help
::   -hide GLOBFILE              Hide ISO9660/RR file
::   -hide-list FILE             File with list of ISO9660/RR files to hide
::   -hidden GLOBFILE            Set hidden attribute on ISO9660 file
::   -hidden-list FILE           File with list of ISO9660 files with hidden attribute
::   -hide-joliet GLOBFILE       Hide Joliet file
::   -hide-joliet-list FILE      File with list of Joliet files to hide
::   -hide-udf GLOBFILE          Hide UDF file
::   -hide-udf-list FILE         File with list of UDF files to hide
::   -hide-joliet-trans-tbl      Hide TRANS.TBL from Joliet tree
::   -hide-rr-moved              Rename RR_MOVED to .rr_moved in Rock Ridge tree
::   -gui                        Switch behaviour for GUI
::   -input-charset CHARSET      Local input charset for file name conversion
::   -output-charset CHARSET     Output charset for file name conversion
::   -iso-level LEVEL            Set ISO9660 conformance level (1..3) or 4 for ISO9660 version 2
::   -J, -joliet                 Generate Joliet directory information
::   -joliet-long                Allow Joliet file names to be 103 Unicode characters
::   -jcharset CHARSET           Local charset for Joliet directory information
::   -l, -full-iso9660-filenames Allow full 31 character filenames for ISO9660 names
::   -max-iso9660-filenames      Allow 37 character filenames for ISO9660 names (violates ISO9660)
::   -allow-leading-dots         Allow ISO9660 filenames to start with '.' (violates ISO9660)
::   -ldots                      Allow ISO9660 filenames to start with '.' (violates ISO9660)
::   -log-file LOG_FILE          Re-direct messages to LOG_FILE
::   -long-rr-time               Use long Rock Ridge time format
::   -m GLOBFILE, -exclude GLOBFILE
::                               Exclude file name
::   -exclude-list FILE          File with list of file names to exclude
::   -modification-date DATE     Set the modification date field of the PVD
::   -nobak                      Do not include backup files
::   -no-bak                     Do not include backup files
::   -pad                        Pad output to a multiple of 32k (default)
::   -no-pad                     Do not pad output to a multiple of 32k
::   -no-limit-pathtables        Allow more than 65535 parent directories (violates ISO9660)
::   -no-long-rr-time            Use short Rock Ridge time format
::   -M FILE, -prev-session FILE Set path to previous session to merge
::   -dev SCSIdev                Set path to previous session to merge
::   -N, -omit-version-number    Omit version number from ISO9660 filename (violates ISO9660)
::   -new-dir-mode mode          Mode used when creating new directories.
::   -force-rr                   Inhibit automatic Rock Ridge detection for previous session
::   -no-rr                      Inhibit reading of Rock Ridge attributes from previous session
::   -no-split-symlink-components
::                               Inhibit splitting symlink components
::   -no-split-symlink-fields    Inhibit splitting symlink fields
::   -o FILE, -output FILE       Set output file name
::   -path-list FILE             File with list of pathnames to process
::   -p PREP, -preparer PREP     Set Volume preparer
::   -print-size                 Print estimated filesystem size and exit
::   -publisher PUB              Set Volume publisher
::   -quiet                      Run quietly
::   -r, -rational-rock          Generate rationalized Rock Ridge directory information
::   -R, -rock                   Generate Rock Ridge directory information
::   -s TYPE, -sectype TYPE      Set output sector type to e.g. data/xa1/raw
::   -short-rr-time              Use short Rock Ridge time format
::   -sort FILE                  Sort file content locations according to rules in FILE
::   -split-output               Split output into files of approx. 1GB size
::   -stream-file-name FILE_NAME Set the stream file ISO9660 name (incl. version)
::   -stream-media-size #        Set the size of your CD media in sectors
::   -sysid ID                   Set System ID
::   -T, -translation-table      Generate translation tables for systems that don't understand long filenames
::   -table-name TABLE_NAME      Translation table file name
::   -ucs-level LEVEL            Set Joliet UCS level (1..3)
::   -udf                        Generate rationalized UDF file system
::   -UDF                        Generate UDF file system
::   -udf-symlinks               Create symbolic links on UDF image (default)
::   -no-udf-symlinks            Do not reate symbolic links on UDF image
::   -dvd-audio                  Generate DVD-Audio compliant UDF file system
::   -dvd-hybrid                 Generate a hybrid (DVD-Audio and DVD-Video) compliant UDF file system
::   -dvd-video                  Generate DVD-Video compliant UDF file system
::   -uid uid                    Make the owner of all files this uid.
::   -U, -untranslated-filenames Allow Untranslated filenames (for HPUX & AIX - violates ISO9660). Forces -l, -d, -N, -allow-leading-dots, -relaxed-filenames, -allow-lowercase, -allow-multidot
::   -relaxed-filenames          Allow 7 bit ASCII except lower case characters (violates ISO9660)
::   -no-iso-translate           Do not translate illegal ISO characters '~', '-' and '#' (violates ISO9660)
::   -allow-lowercase            Allow lower case characters in addition to the current character set (violates ISO9660)
::   -allow-multidot             Allow more than one dot in filenames (e.g. .tar.gz) (violates ISO9660)
::   -use-fileversion LEVEL      Use file version # from filesystem
::   -v, -verbose                Verbose
::   -version                    Print the current version
::   -V ID, -volid ID            Set Volume ID
::   -volset ID                  Set Volume set ID
::   -volset-size #              Set Volume set size
::   -volset-seqno #             Set Volume set sequence number
::   -x FILE, -old-exclude FILE  Exclude file name(depreciated)
::   -hard-disk-boot             Boot image is a hard disk image
::   -no-emul-boot               Boot image is 'no emulation' image
::   -no-boot                    Boot image is not bootable
::   -boot-load-seg #            Set load segment for boot image
::   -boot-load-size #           Set numbers of load sectors
::   -boot-info-table            Patch boot image with info table
::   -XA                         Generate XA directory attributes
::   -xa                         Generate rationalized XA directory attributes
::   -z, -transparent-compression
::                               Enable transparent compression of files
::   -hfs-type TYPE              Set HFS default TYPE
::   -hfs-creator CREATOR        Set HFS default CREATOR
::   -g, -apple                  Add Apple ISO9660 extensions
::   -h, -hfs                    Create ISO9660/HFS hybrid
::   -map MAPPING_FILE           Map file extensions to HFS TYPE/CREATOR
::   -magic FILE                 Magic file for HFS TYPE/CREATOR
::   -probe                      Probe all files for Apple/Unix file types
::   -mac-name                   Use Macintosh name for ISO9660/Joliet/RockRidge file name
::   -no-mac-files               Do not look for Unix/Mac files (depreciated)
::   -boot-hfs-file FILE         Set HFS boot image name
::   -part                       Generate HFS partition table
::   -cluster-size SIZE          Cluster size for PC Exchange Macintosh files
::   -auto FILE                  Set HFS AutoStart file name
::   -no-desktop                 Do not create the HFS (empty) Desktop files
::   -hide-hfs GLOBFILE          Hide HFS file
::   -hide-hfs-list FILE         List of HFS files to hide
::   -hfs-volid HFS_VOLID        Volume name for the HFS partition
::   -icon-position              Keep HFS icon position
::   -root-info FILE             finderinfo for root folder
::   -input-hfs-charset CHARSET  Local input charset for HFS file name conversion
::   -output-hfs-charset CHARSET Output charset for HFS file name conversion
::   -hfs-unlock                 Leave HFS Volume unlocked
::   -hfs-bless FOLDER_NAME      Name of Folder to be blessed
::   -hfs-parms PARAMETERS       Comma separated list of HFS parameters
::   -prep-boot FILE             PReP boot image file -- up to 4 are allowed
::   -chrp-boot                  Add CHRP boot header
::   --cap                       Look for AUFS CAP Macintosh files
::   --netatalk                  Look for NETATALK Macintosh files
::   --double                    Look for AppleDouble Macintosh files
::   --ethershare                Look for Helios EtherShare Macintosh files
::   --exchange                  Look for PC Exchange Macintosh files
::   --sgi                       Look for SGI Macintosh files
::   --macbin                    Look for MacBinary Macintosh files
::   --single                    Look for AppleSingle Macintosh files
::   --ushare                    Look for IPT UShare Macintosh files
::   --xinet                     Look for XINET Macintosh files
::   --dave                      Look for DAVE Macintosh files
::   --sfm                       Look for SFM Macintosh files
::   --osx-double                Look for MacOS X AppleDouble Macintosh files
::   --osx-hfs                   Look for MacOS X HFS Macintosh files
::   -no-hfs                     Do not create ISO9660/HFS hybrid
