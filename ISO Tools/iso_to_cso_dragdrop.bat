@ECHO OFF

SET "MCISO=K:\GitHub\JMD-PSP-Tools\ISO Tools\bin\mciso-amd64.exe"

SET "OUTPUT=%~dp0"

REM Compress to CSO
"%MCISO%" 9 "%OUTPUT%\%~n1.iso" "%OUTPUT%\%~n1.cso"

REM Decompress CSO to ISO
REM "%MCISO%" 0 "%OUTPUT%\%~n1.cso" "%OUTPUT%\%~n1.iso"

PAUSE

EXIT