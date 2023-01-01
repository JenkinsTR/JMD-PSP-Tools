#define WM_CONVERT_SIZE     WM_USER+200
#define WM_CONVERT_PROGRESS WM_USER+201
#define WM_CONVERT_ERROR    WM_USER+202
#define WM_CONVERT_DONE     WM_USER+203

#define WriteInteger(a, c) \
	x = a; \
	for (i = 0; i < c; i++) \
		fwrite(&x, 1, 4, out)

#define WriteChar(a, c) \
	for (i = 0; i < c; i++) \
		fputc(a, out)

#define WriteRandom(c) \
	for (i = 0; i < c; i++) \
	{ \
		x = rand(); \
		fwrite(&x, 1, 4, out); \
	}


#pragma pack(1)
typedef struct
{
	unsigned int signature;
	unsigned int version;
	unsigned int fields_table_offs;
	unsigned int values_table_offs;
	int nitems;
} SFOHeader;
#pragma pack()

#pragma pack(1)
typedef struct
{
	unsigned short field_offs;
	unsigned char  unk;
	unsigned char  type; // 0x2 -> string, 0x4 -> number
	unsigned int length;
	unsigned int size;
	unsigned short val_offs;
	unsigned short unk4;
} SFODir;
#pragma pack()

#pragma pack(1)
typedef struct
{
	unsigned int offset;
	unsigned int length;
	unsigned int dummy[6];
} IsoIndex;
#pragma pack()

//---

typedef struct {
	char newData;
	DWORD dataPosition;
} PatchData;

typedef struct {
	char fileCount;
	char srcISO1[0xFF];
	char srcISO2[0xFF];
	char srcISO3[0xFF];
	char srcISO4[0xFF];
	char gameTitle1[0xFF];
	char gameTitle2[0xFF];
	char gameTitle3[0xFF];
	char gameTitle4[0xFF];
	char gameID1[0xFF];
	char gameID2[0xFF];
	char gameID3[0xFF];
	char gameID4[0xFF];
} MultiDiscInfo;

typedef struct {
	HWND callback;
	char base[0xFF];
	char data_psp[0xFF];
	char srcISO[0xFF];
  char dstPBP[0xFF];
	char pic0[0xFF];
	char pic1[0xFF];
	char icon0[0xFF];
	char icon1[0xFF];
	char snd0[0xFF];
	char boot[0xFF];
	bool srcIsPbp;

	char gameTitle[0xFF];
	char saveTitle[0xFF];
	char gameID[0xFF];
	char saveID[0xFF];
	int compLevel;

	int tocSize;
	void* tocData;

	MultiDiscInfo multiDiscInfo;

	int patchCount;
	PatchData *patchData;
} ConvertIsoInfo;

HANDLE popstationConvert(ConvertIsoInfo info);
void popstationCancel();