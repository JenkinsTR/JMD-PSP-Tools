#define WM_EXTRACT_SIZE     WM_USER+100
#define WM_EXTRACT_PROGRESS WM_USER+101
#define WM_EXTRACT_ERROR    WM_USER+102
#define WM_EXTRACT_DONE     WM_USER+103

// The maximum possible number of ISO indexes
#define MAX_INDEXES 0x7E00
// The location of the PSAR offset in the PBP header
#define HEADER_PSAR_OFFSET 0x24
// The location of the ISO indexes in the PSAR
#define PSAR_INDEX_OFFSET 0x4000
// The location of the ISO data in the PSAR
#define PSAR_ISO_OFFSET 0x100000
// The size of one "block" of the ISO
#define ISO_BLOCK_SIZE 0x930

// Struct to store an ISO index
typedef struct {
	int offset;
	int length;
} INDEX;

typedef struct {
	HWND callback;
	char srcPBP[0xFF];
  char dstISO[0xFF];
} ExtractIsoInfo;

HANDLE popstripExtract(ExtractIsoInfo info);
void popstripCancel();

#pragma once
extern int WINAPI popstripInit(INDEX **iso_index, char* pbpFile);  //Returns index count
extern int WINAPI popstripReadBlock(INDEX *iso_index, int blockNo, unsigned char *out_buffer);
extern int WINAPI popstripGetIsoSize(INDEX *iso_index);
extern void WINAPI popstripFinal(INDEX **iso_index);