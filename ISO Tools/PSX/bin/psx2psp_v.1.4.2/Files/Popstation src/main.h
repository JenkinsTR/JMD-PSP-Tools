#include "popstrip.h"
#include "popstation.h"

#pragma once
extern HANDLE WINAPI convert(ConvertIsoInfo info);
extern void WINAPI cancel_convert();
extern HANDLE WINAPI extract(ExtractIsoInfo info);
extern void WINAPI cancel_extract();