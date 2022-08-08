@ECHO OFF

SET "MCISO=U:\Games\_PSP_CFW\PC Tools\mciso-amd64.exe"

SET "OUTPUT=%~dp0"

REM Compress to CSO
FOR /R %%G IN (*.iso) DO (
	"%MCISO%" 9 "%OUTPUT%%%~nG.iso" "%OUTPUT%%%~nG.cso"
)

REM Decompress CSO to ISO
REM FOR /R %%G IN (*.iso) DO (
	REM "%MCISO%" 0 "%OUTPUT%%%~nG.cso" "%OUTPUT%%%~nG.iso"
REM )

PAUSE

EXIT