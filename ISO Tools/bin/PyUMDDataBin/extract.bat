@ECHO OFF

SET INPUT=K:\GitHub\JMD-PSP-Tools\ISO Tools\Metadata\Games\AFL Challenge (Australia) [ULES-01299]
SET OUTPUT=K:\GitHub\JMD-PSP-Tools\ISO Tools\Metadata

python extractmetadata.py "%INPUT%" "%OUTPUT%.xml"

PAUSE
EXIT
