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
		"%WRAR%" a "%%G" %OPTS% -z"%%~dpnG_info.txt" "%%~nG.rar"
	) ELSE (
		"%WRAR%" a "%%G" %OPTS% "%%~nG.rar"
	)

	"%MCISO%" 9 "%OUTPUT%%%~nG.iso" "%OUTPUT%%%~nG.cso"
	
	REM WARNING THE BELOW REMOVES THE ORIGINAL ISO. MAKE SURE YOU ARE AWARE
	IF EXIST "%OUTPUT%%%~nG.iso" DEL "%OUTPUT%%%~nG.iso" /q /s >NUL 2>&1
	POPD
)

PAUSE

EXIT