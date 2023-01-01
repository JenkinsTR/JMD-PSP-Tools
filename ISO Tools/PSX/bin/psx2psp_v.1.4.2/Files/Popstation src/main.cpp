//#include <stdio.h>
//#include <string.h>
//#include <stdlib.h>
//#include <stdarg.h>
#include <windows.h>
//#include <zlib.h>
#include "main.h"

HANDLE WINAPI convert(ConvertIsoInfo info)
{
	return popstationConvert(info);
}

void WINAPI cancel_convert()
{
	popstationCancel();
}
//---
HANDLE WINAPI extract(ExtractIsoInfo info)
{
	return popstripExtract(info);
}

void WINAPI cancel_extract()
{
	popstripCancel();
}