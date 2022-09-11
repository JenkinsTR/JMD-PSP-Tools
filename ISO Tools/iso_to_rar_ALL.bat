@ECHO OFF

SET "MCISO=U:\Games\_PSP_CFW\PC Tools\mciso-amd64.exe"
SET "WRAR=C:\Program Files\WinRAR\Rar.exe"

SET "OUTPUT=%~dp0"
SET "OPTS=-m5 -s -rr5p -ma -md128

REM Compress to CSO
FOR /R %%G IN (*.iso) DO (
	REM RAR the ISO first
	PUSHD "%%~dpG"
	
	REM Look for info txt to add as comment
	IF EXIST "%%~dpnG_info.txt" (
		"%WRAR%" %OPTS% a "%%~nG.rar" -z"%%~dpnG_info.txt" "%%~nG*"
	) ELSE (
		"%WRAR%" %OPTS% a  "%%~nG.rar" "%%~nG*"
	)
	
	REM WARNING THE BELOW REMOVES THE ORIGINAL ISO IF MATCHING RAR IS FOUND. MAKE SURE YOU ARE AWARE
	IF EXIST "%OUTPUT%%%~nG.rar" DEL "%OUTPUT%%%~nG.iso" /q /s >NUL 2>&1
	POPD
)

PAUSE

EXIT