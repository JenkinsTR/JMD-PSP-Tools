@ECHO OFF

COPY "%CD%\getsize.ps1" "%~dpn1\getsize.ps1"

PUSHD "%1"
powershell -file "%~dpn1\getsize.ps1"
POPD

PAUSE
EXIT