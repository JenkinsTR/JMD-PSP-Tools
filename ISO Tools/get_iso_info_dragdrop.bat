@ECHO OFF

SET ISOINFO=K:\GitHub\JMD-PSP-Tools\ISO Tools\bin\isoinfo.exe

:: Usage: isoinfo.exe [options] -i filename [-find [[find expr.]]
:: Options:
::         -help,-h        Print this help
::         -version        Print version info and exit
::         -debug          Print additional debug info
::         -ignore-error Ignore errors
::         -d              Print information from the primary volume descriptor
::         -f              Generate output similar to 'find .  -print'
::         -find [find expr.] Option separator: Use find command line to the right
::         -J              Print information from Joliet extensions
::         -j charset      Use charset to display Joliet file names
::         -l              Generate output similar to 'ls -lR'
::         -p              Print Path Table
::         -R              Print information from Rock Ridge extensions
::         -s              Print file size infos in multiples of sector size (2048 bytes).
::         -N sector       Sector number where ISO image should start on CD
::         -T sector       Sector number where actual session starts on CD
::         -i filename     Filename to read ISO-9660 image from
::         dev=target      SCSI target to use as CD/DVD-Recorder
::         -X              Extract all matching files to the filesystem
::         -x pathname     Extract specified file to stdout

"%ISOINFO%" -d -i "%~1" > "%~n1_info.txt"
ECHO. >> "%~n1_info.txt"
ECHO. >> "%~n1_info.txt"
"%ISOINFO%" -l -i "%~1" >> "%~n1_info.txt"
REM "%ISOINFO%" -p -i "%~1" > iso4p.txt

PAUSE

EXIT