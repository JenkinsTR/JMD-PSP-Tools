@ECHO OFF

SET "UMDB=K:\GitHub\JMD-PSP-Tools\ISO Tools\bin\umdatabase.exe"

PUSHD "%~dp1"

IF NOT EXIST "%~dp1_ISO_TEMP" MKDIR "%~dp1_ISO_TEMP"

MOVE "%~1" "%~dp1_ISO_TEMP\%~nx1" 

ECHO temp > "%~dp1_ISO_TEMP\%~n1.txt"

PUSHD "%~dp1_ISO_TEMP"
"%UMDB%" "%~dp1_ISO_TEMP\%~nx1" > "%~dp1_ISO_TEMP\%~n1.txt"|TYPE "%~dp1_ISO_TEMP\%~n1.txt"
POPD

PUSHD "%~dp1"

FOR /R %%G IN (_ISO_TEMP\*.iso) DO SET UID=%%~nG
FOR /R %%G IN (_ISO_TEMP\*.txt) DO SET NAME=%%~nG

MOVE "%~dp1_ISO_TEMP\%UID%.iso" "%~dp1%NAME% [%UID%].iso"
MOVE "%~dp1_ISO_TEMP\%NAME%.txt" "%~dp1%NAME% [%UID%].txt"

POPD

PAUSE

EXIT