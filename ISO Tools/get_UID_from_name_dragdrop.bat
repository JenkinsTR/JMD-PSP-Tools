@ECHO OFF

REM Get UID from folder name and set it as VOLID
FOR /F "tokens=1,2,3 delims=[]" %%G IN ("%~n1") DO SET VOLID=%%H

ECHO Volume ID set as %VOLID%

PAUSE
EXIT