#include <stdio.h>
//#include <string.h>
//#include <stdlib.h>
//#include <stdarg.h>
#include <stdlib.h>
#include <windows.h>
#include "zlib.h"
#include "popstation.h"
#include "popstrip.h"
#include "data.h"

ConvertIsoInfo convertInfo;
BOOL cancelConvert=FALSE;
int nextPatchPos;

DWORD WINAPI convertIso(LPVOID hwndDlg);
DWORD WINAPI convertIsoMD(LPVOID hwndDlg);

HANDLE popstationConvert(ConvertIsoInfo info)
{
	DWORD dwThreadId;

	convertInfo=info;
	cancelConvert=FALSE;
	if (convertInfo.patchCount>0)
	{
		nextPatchPos=0;
	}
	if (convertInfo.multiDiscInfo.fileCount<=1)
	{
		return CreateThread(NULL, 0, convertIso, (LPDWORD)info.callback, 0, &dwThreadId);
	} else
	{
		return CreateThread(NULL, 0, convertIsoMD, (LPDWORD)info.callback, 0, &dwThreadId);
	}
}

void popstationCancel()
{
	cancelConvert=TRUE;
}

void patchData(char *buffer, int size, int pos)
{
	while (1)
	{
		if (nextPatchPos>=convertInfo.patchCount) break;
		if ((pos<=convertInfo.patchData[nextPatchPos].dataPosition) && ((pos+size)>=convertInfo.patchData[nextPatchPos].dataPosition))
		{
			buffer[convertInfo.patchData[nextPatchPos].dataPosition-pos]=convertInfo.patchData[nextPatchPos].newData;
			nextPatchPos++;
		} else break;
	}
}


int getsize(FILE *f)
{
	int size;

	fseek(f, 0, SEEK_END);
	size = ftell(f);

	fseek(f, 0, SEEK_SET);
	return size;
}

int popstationErrorExit(char *fmt, ...)
{
	va_list list;
	char msg[256];

	va_start(list, fmt);
	vsprintf(msg, fmt, list);
	va_end(list);

	PostMessage(convertInfo.callback,WM_CONVERT_ERROR,0,0);
	MessageBox(convertInfo.callback,msg,"Popstation - Error",MB_OK | MB_ICONERROR);
	return 0;
}

int deflateCompress(z_stream *z, void *inbuf, int insize, void *outbuf, int outsize, int level)
{
	int res;
	
	z->zalloc = Z_NULL;
	z->zfree  = Z_NULL;
	z->opaque = Z_NULL;

	if (deflateInit2(z, level , Z_DEFLATED, -15, 8, Z_DEFAULT_STRATEGY) != Z_OK)
		return -1;

	z->next_out  = (Bytef*)outbuf;
	z->avail_out = outsize;
	z->next_in   = (Bytef*)inbuf;
	z->avail_in  = insize;

	if (deflate(z, Z_FINISH) != Z_STREAM_END)
	{
		return -1;
	}

	res = outsize - z->avail_out;

	if (deflateEnd(z) != Z_OK)
		return -1;

	return res;
}

void SetSFOTitle(char *sfo, char *title)
{
	SFOHeader *header = (SFOHeader *)sfo;
	SFODir *entries = (SFODir *)(sfo+0x14);
	int i;
	
	for (i = 0; i < header->nitems; i++)
	{
		if (strcmp(sfo+header->fields_table_offs+entries[i].field_offs, "TITLE") == 0)
		{
			memset( sfo+header->values_table_offs+entries[i].val_offs, 0   , entries[i].size);   // Might not be MD ok
			strncpy(sfo+header->values_table_offs+entries[i].val_offs, title, entries[i].size);
			
			if (strlen(title)+1 > entries[i].size)
			{
				entries[i].length = entries[i].size;
			}
			else
			{
				entries[i].length = strlen(title)+1;
			}
		}
	}
}

void SetSFOCode(char *sfo, char *code)
{
	SFOHeader *header = (SFOHeader *)sfo;
	SFODir *entries = (SFODir *)(sfo+0x14);
	int i;
	
	for (i = 0; i < header->nitems; i++)
	{
		if (strcmp(sfo+header->fields_table_offs+entries[i].field_offs, "DISC_ID") == 0)
		{
			memset( sfo+header->values_table_offs+entries[i].val_offs, 0   , entries[i].size);
			strncpy(sfo+header->values_table_offs+entries[i].val_offs, code, entries[i].size);
			
			if (strlen(code)+1 > entries[i].size)
			{
				entries[i].length = entries[i].size;
			}
			else
			{
				entries[i].length = strlen(code)+1;
			}
		}
	}
}

	char buffer[1*1048576];
	char buffer2[0x9300];

	int *ib = (int*)buffer;

	int pic0 = 0, pic1 = 0, icon0 = 0, icon1 = 0, snd = 0, toc = 0, boot = 0, prx = 0;
	int sfo_size, pic0_size, pic1_size, icon0_size, icon1_size, snd_size, toc_size, boot_size, prx_size;
	int start_dat = 0, min, sec, frm;;
	unsigned int psp_header[0x30/4];
	unsigned int base_header[0x28/4];
	unsigned int header[0x28/4];
	unsigned int dummy[6];

	int bufferSize;
	int totSize=0;
	INDEX *iso_index;
	int blockCount;

DWORD WINAPI convertIsoMD(LPVOID hwndDlg)
{
	FILE *in, *out, *base, *t;
	int i, offset, isosize, isorealsize, x;
	int index_offset, p1_offset, p2_offset, m_offset, end_offset;
	IsoIndex *indexes;
	int iso_positions[5];
	int ciso;	
	z_stream z;

	int ndiscs;
	char *inputs[4];
	char *output;
	char *title;
	char *titles[4];
	char *code;
	char *codes[4];
	int complevels[4];
	char *BASE;

	ndiscs=convertInfo.multiDiscInfo.fileCount;

	inputs[0]=convertInfo.multiDiscInfo.srcISO1;
	inputs[1]=convertInfo.multiDiscInfo.srcISO2;
	inputs[2]=convertInfo.multiDiscInfo.srcISO3;
	inputs[3]=convertInfo.multiDiscInfo.srcISO4;

	titles[0]=convertInfo.multiDiscInfo.gameTitle1;
	titles[1]=convertInfo.multiDiscInfo.gameTitle2;
	titles[2]=convertInfo.multiDiscInfo.gameTitle3;
	titles[3]=convertInfo.multiDiscInfo.gameTitle4;

	codes[0] =convertInfo.multiDiscInfo.gameID1;
	codes[1] =convertInfo.multiDiscInfo.gameID2;
	codes[2] =convertInfo.multiDiscInfo.gameID3;
	codes[3] =convertInfo.multiDiscInfo.gameID4;

	complevels[0]=convertInfo.compLevel;
	complevels[1]=convertInfo.compLevel;
	complevels[2]=convertInfo.compLevel;
	complevels[3]=convertInfo.compLevel;

	output=convertInfo.dstPBP;
	title=convertInfo.gameTitle;
	code=convertInfo.gameID;
	BASE=convertInfo.base;
	
	base = fopen(BASE, "rb");
	if (!base)
	{
		return popstationErrorExit("Cannot open %s\n", BASE);
	}

	out = fopen(output, "wb");
	if (!out)
	{
		return popstationErrorExit("Cannot create %s\n", output);
	}

	printf("Writing PBP header...\n");

	fread(base_header, 1, 0x28, base);

	if (base_header[0] != 0x50425000)
	{
		return popstationErrorExit("%s is not a PBP file.\n", BASE);
	}

	sfo_size = base_header[3] - base_header[2];
	
	t = fopen(convertInfo.icon0, "rb");
	if (t)
	{
		icon0_size = getsize(t);
		icon0 = 1;
		fclose(t);
	}
	else
	{
		icon0_size = base_header[4] - base_header[3];
	}

	t = fopen(convertInfo.icon1, "rb");
	if (t)
	{
		icon1_size = getsize(t);
		icon1 = 1;
		fclose(t);
	}
	else
	{
		icon1_size = 0;
	}

	t = fopen(convertInfo.pic0, "rb");
	if (t)
	{
		pic0_size = getsize(t);
		pic0 = 1;
		fclose(t);
	}
	else
	{
		pic0_size = 0; //base_header[6] - base_header[5];
	}

	t = fopen(convertInfo.pic1, "rb");
	if (t)
	{
		pic1_size = getsize(t);
		pic1 = 1;
		fclose(t);
	}
	else
	{
		pic1_size = 0; // base_header[7] - base_header[6];
	}

	t = fopen(convertInfo.snd0, "rb");
	if (t)
	{
		snd_size = getsize(t);
		snd = 1;
		fclose(t);
	}
	else
	{
		snd = 0;
	}

	t = fopen(convertInfo.boot, "rb");
	if (t)
	{
		boot_size = getsize(t);
		boot = 1;
		fclose(t);
	}
	else
	{
		boot = 0;
	}

	t = fopen(convertInfo.data_psp, "rb");
	if (t)
	{
		prx_size = getsize(t);
		prx = 1;
		fclose(t);
	}
	else
	{
		fseek(base, base_header[8], SEEK_SET);
		fread(psp_header, 1, 0x30, base);

		prx_size = psp_header[0x2C/4];
	}

	int curoffs = 0x28;

	header[0] = 0x50425000;
	header[1] = 0x10000;
	
	header[2] = curoffs;

	curoffs += sfo_size;
	header[3] = curoffs;

	curoffs += icon0_size;
	header[4] = curoffs;

	curoffs += icon1_size;
	header[5] = curoffs;

	curoffs += pic0_size;
	header[6] = curoffs;

	curoffs += pic1_size;
	header[7] = curoffs;

	curoffs += snd_size;
	header[8] = curoffs;

	x = header[8] + prx_size;

	if ((x % 0x10000) != 0)
	{
		x = x + (0x10000 - (x % 0x10000));
	}
	
	header[9] = x;

	fwrite(header, 1, 0x28, out);

	printf("Writing sfo...\n");

	fseek(base, base_header[2], SEEK_SET);
	fread(buffer, 1, sfo_size, base);
	SetSFOTitle(buffer, title);
	strcpy(buffer+0x108, code);
	fwrite(buffer, 1, sfo_size, out);

	printf("Writing icon0.png...\n");

	if (!icon0)
	{
		fseek(base, base_header[3], SEEK_SET);
		fread(buffer, 1, icon0_size, base);
		fwrite(buffer, 1, icon0_size, out);
	}
	else
	{
		t = fopen(convertInfo.icon0, "rb");
		fread(buffer, 1, icon0_size, t);
		fwrite(buffer, 1, icon0_size, out);
		fclose(t);
	}

	if (icon1)
	{
		printf("Writing icon1.pmf...\n");
		
		t = fopen(convertInfo.icon1, "rb");
		fread(buffer, 1, icon1_size, t);
		fwrite(buffer, 1, icon1_size, out);
		fclose(t);
	}

	if (!pic0)
	{
		//fseek(base, base_header[5], SEEK_SET);
		//fread(buffer, 1, pic0_size, base);
		//fwrite(buffer, 1, pic0_size, out);
	}
	else
	{
		printf("Writing pic0.png...\n");
		
		t = fopen(convertInfo.pic0, "rb");
		fread(buffer, 1, pic0_size, t);
		fwrite(buffer, 1, pic0_size, out);
		fclose(t);
	}

	if (!pic1)
	{
		//fseek(base, base_header[6], SEEK_SET);
		//fread(buffer, 1, pic1_size, base);
		//fwrite(buffer, 1, pic1_size, out);		
	}
	else
	{
		printf("Writing pic1.png...\n");
		
		t = fopen(convertInfo.pic1, "rb");
		fread(buffer, 1, pic1_size, t);
		fwrite(buffer, 1, pic1_size, out);
		fclose(t);
	}

	if (snd)
	{
		printf("Writing snd0.at3...\n");
		
		t = fopen(convertInfo.snd0, "rb");
		fread(buffer, 1, snd_size, t);
		fwrite(buffer, 1, snd_size, out);
		fclose(t);
	}

	printf("Writing DATA.PSP...\n");

	if (prx)
	{
		t = fopen(convertInfo.data_psp, "rb");
		fread(buffer, 1, prx_size, t);
		fwrite(buffer, 1, prx_size, out);
		fclose(t);
	}
	else
	{
		fseek(base, base_header[8], SEEK_SET);
		fread(buffer, 1, prx_size, base);
		fwrite(buffer, 1, prx_size, out);
	}

	offset = ftell(out);
	
	for (i = 0; i < header[9]-offset; i++)
	{
		fputc(0, out);
	}

	printf("Writing PSTITLE header...\n");

	fwrite("PSTITLEIMG000000", 1, 16, out);

	// Save this offset position
	p1_offset = ftell(out);
	
	WriteInteger(0, 2);
	WriteInteger(0x2CC9C5BC, 1);
	WriteInteger(0x33B5A90F, 1);
	WriteInteger(0x06F6B4B3, 1);
	WriteInteger(0xB25945BA, 1);
	WriteInteger(0, 0x76);

	m_offset = ftell(out);

	memset(iso_positions, 0, sizeof(iso_positions));
	fwrite(iso_positions, 1, sizeof(iso_positions), out);

	WriteRandom(12);
	WriteInteger(0, 8);
	
	fputc('_', out);
	fwrite(code, 1, 4, out);
	fputc('_', out);
	fwrite(code+4, 1, 5, out);

	WriteChar(0, 0x15);
	
	p2_offset = ftell(out);
	WriteInteger(0, 2);
	
	fwrite(data3, 1, sizeof(data3), out);
	fwrite(title, 1, strlen(title), out);

	WriteChar(0, 0x80-strlen(title));
	WriteInteger(7, 1);
	WriteInteger(0, 0x1C);

	//Get size of all isos
	totSize=0;
	for (ciso = 0; ciso < ndiscs; ciso++)
	{
		in = fopen (inputs[ciso], "rb");
		if (!in)
		{
			return popstationErrorExit("Cannot open %s\n", inputs[ciso]);
		}

		isosize = getsize(in);
		totSize+=isosize;
	}
	PostMessage(convertInfo.callback,WM_CONVERT_SIZE,0,totSize);

	totSize=0;
	for (ciso = 0; ciso < ndiscs; ciso++)
	{
		in = fopen (inputs[ciso], "rb");
		if (!in)
		{
			return popstationErrorExit("Cannot open %s\n", inputs[ciso]);
		}

		isosize = getsize(in);
		isorealsize = isosize;

		if ((isosize % 0x9300) != 0)
		{
			isosize = isosize + (0x9300 - (isosize%0x9300));
		}
		
		offset = ftell(out);

		if (offset % 0x8000)
		{
			x = 0x8000 - (offset % 0x8000);

			WriteChar(0, x);			
		}

		iso_positions[ciso] = ftell(out) - header[9];

		printf("Writing header (iso #%d)\n", ciso+1);

		fwrite("PSISOIMG0000", 1, 12, out);

		WriteInteger(0, 0xFD);

		memcpy(data1+1, codes[ciso], 4);
		memcpy(data1+6, codes[ciso]+4, 5);
		fwrite(data1, 1, sizeof(data1), out);

		WriteInteger(0, 1);
		
		strcpy((char*)(data2+8), titles[ciso]);
		fwrite(data2, 1, sizeof(data2), out);

		index_offset = ftell(out);

		printf("Writing indexes (iso #%d)...\n", ciso+1);

		memset(dummy, 0, sizeof(dummy));

		offset = 0;

		if (complevels[ciso] == 0)
		{	
			x = 0x9300;
		}
		else
		{
			x = 0;
		}

		for (i = 0; i < isosize / 0x9300; i++)
		{
			fwrite(&offset, 1, 4, out);
			fwrite(&x, 1, 4, out);
			fwrite(dummy, 1, sizeof(dummy), out);

			if (complevels[ciso] == 0)
				offset += 0x9300;
		}

		offset = ftell(out);

		for (i = 0; i < (iso_positions[ciso]+header[9]+0x100000)-offset; i++)
		{
			fputc(0, out);
		}

		printf("Writing iso #%d (%s)...\n", ciso+1, inputs[ciso]);

		if (complevels[ciso] == 0)
		{
			while ((x = fread(buffer, 1, 1048576, in)) > 0)
			{
				fwrite(buffer, 1, x, out);
				totSize+=x;
				PostMessage(convertInfo.callback,WM_CONVERT_PROGRESS,0,totSize);
				if (cancelConvert)
				{
					fclose(in);
					fclose(out);
					fclose(base);

					return 0;
				}
			}

			for (i = 0; i < (isosize-isorealsize); i++)
			{
				fputc(0, out);
			}
		}
		else
		{
			indexes = (IsoIndex *)malloc(sizeof(IsoIndex) * (isosize/0x9300));

			if (!indexes)
			{
				fclose(in);
				fclose(out);
				fclose(base);

				return popstationErrorExit("Cannot alloc memory for indexes!\n");
			}

			i = 0;
			offset = 0;

			while ((x = fread(buffer2, 1, 0x9300, in)) > 0)
			{
				totSize+=x;

				if (x < 0x9300)
				{
					memset(buffer2+x, 0, 0x9300-x);
				}
			
				x = deflateCompress(&z, buffer2, 0x9300, buffer, sizeof(buffer), complevels[ciso]);

				if (x < 0)
				{
					fclose(in);
					fclose(out);
					fclose(base);
					free(indexes);

					return popstationErrorExit("Error in compression!\n");
				}

				memset(&indexes[i], 0, sizeof(IsoIndex));

				indexes[i].offset = offset;

				if (x >= 0x9300) /* Block didn't compress */
				{				
					indexes[i].length = 0x9300;
					fwrite(buffer2, 1, 0x9300, out);
					offset += 0x9300;
				}
				else
				{
					indexes[i].length = x;
					fwrite(buffer, 1, x, out);
					offset += x;
				}

				PostMessage(convertInfo.callback,WM_CONVERT_PROGRESS,0,totSize);
				if (cancelConvert)
				{
					fclose(in);
					fclose(out);
					fclose(base);

					return 0;
				}

				i++; 
			}

			if (i != (isosize/0x9300))
			{
				fclose(in);
				fclose(out);
				fclose(base);
				free(indexes);

				return popstationErrorExit("Some error happened.\n");
			}
		}

		if (complevels[ciso] != 0)
		{
			offset = ftell(out);
			
			printf("Updating compressed indexes (iso #%d)...\n", ciso+1);

			fseek(out, index_offset, SEEK_SET);
			fwrite(indexes, 1, sizeof(IsoIndex) * (isosize/0x9300), out);

			fseek(out, offset, SEEK_SET);
		}
	}

	x = ftell(out);

	if ((x % 0x10) != 0)
	{
		end_offset = x + (0x10 - (x % 0x10));
			
		for (i = 0; i < (end_offset-x); i++)
		{
			fputc('0', out);
		}
	}
	else
	{
		end_offset = x;
	}

	end_offset -= header[9];

	printf("Writing special data...\n");
	
	fseek(base, base_header[9]+12, SEEK_SET);
	fread(&x, 1, 4, base);

	x += 0x50000;

	fseek(base, x, SEEK_SET);
	fread(buffer, 1, 8, base);
	
	if (memcmp(buffer, "STARTDAT", 8) != 0)
	{
		return popstationErrorExit("Cannot find STARTDAT in %s.\n", 
			      "Not a valid PSX eboot.pbp\n", BASE);
	}

	fseek(base, x+16, SEEK_SET);
	fread(header, 1, 8, base);
	fseek(base, x, SEEK_SET);
	fread(buffer, 1, header[0], base);

	if (!boot)
	{
		fwrite(buffer, 1, header[0], out);
		fread(buffer, 1, header[1], base);
		fwrite(buffer, 1, header[1], out);
	}
	else
	{
		printf("Writing boot.png...\n");

		ib[5] = boot_size;
		fwrite(buffer, 1, header[0], out);
		t = fopen(convertInfo.boot, "rb");
		fread(buffer, 1, boot_size, t);
		fwrite(buffer, 1, boot_size, out);
		fclose(t);
		fread(buffer, 1, header[1], base);
	}

	//fseek(base, x, SEEK_SET);

	while ((x = fread(buffer, 1, 1048576, base)) > 0)
	{
		fwrite(buffer, 1, x, out);
	}

	fseek(out, p1_offset, SEEK_SET);
	fwrite(&end_offset, 1, 4, out);

	end_offset += 0x2d31;
	fseek(out, p2_offset, SEEK_SET);
	fwrite(&end_offset, 1, 4, out);

	fseek(out, m_offset, SEEK_SET);
	fwrite(iso_positions, 1, sizeof(iso_positions), out);

	fclose(in);
	fclose(out);
	fclose(base);

	PostMessage(convertInfo.callback,WM_CONVERT_DONE,0,0);
}

DWORD WINAPI convertIso(LPVOID hwndDlg)
{
	FILE *in, *out, *base, *t;
	int i, j, offset, isosize, isorealsize, x;
	int index_offset, p1_offset, p2_offset, end_offset;
	IsoIndex *indexes;
	int curoffs = 0x28;
	char *input;
	char *output;
	int complevel;
	char *BASE;
	z_stream z;

	BASE=convertInfo.base;
	input=convertInfo.srcISO;
	output=convertInfo.dstPBP;
//	title=convertInfo.title;
//	code=convertInfo.gameCode;
	complevel=convertInfo.compLevel;
	
	in = fopen (input, "rb");
	if (!in)
	{
		if (input[0]==0)
			return popstationErrorExit("No input file selected.");
		else
			return popstationErrorExit("Unable to open \"%s\".",input);
	}

	//Check if input is pbp
	if (convertInfo.srcIsPbp)
	{
		blockCount=popstripInit(&iso_index,convertInfo.srcISO);
		if (blockCount==0) return popstationErrorExit("No iso index was found.");
		isosize=popstripGetIsoSize(iso_index);
	} else
	{
		isosize = getsize(in);
	}
	isorealsize = isosize;

	PostMessage(convertInfo.callback,WM_CONVERT_SIZE,0,isosize);

	if ((isosize % 0x9300) != 0)
	{
		isosize = isosize + (0x9300 - (isosize%0x9300));
	}

	//printf("isosize, isorealsize %08X  %08X\n", isosize, isorealsize);

	base = fopen(BASE, "rb");
	if (!base)
	{
		return popstationErrorExit("Unable to open \"%s\".",BASE);
	}

	out = fopen(output, "wb");
	if (!out)
	{
		if (output[0]==0)
			return popstationErrorExit("No output file selected.");
		else
			return popstationErrorExit("Unable to open \"%s\".",output);
	}

	printf("Writing header...\n");

	fread(base_header, 1, 0x28, base);

	if (base_header[0] != 0x50425000)
	{
		return popstationErrorExit("%s is not a PBP file.\n", BASE);
	}

	sfo_size = base_header[3] - base_header[2];
	
	t = fopen(convertInfo.icon0, "rb");
	if (t)
	{
		icon0_size = getsize(t);
		icon0 = 1;
		fclose(t);
	}
	else
	{
		icon0_size = 0;//base_header[4] - base_header[3];
	}

	t = fopen(convertInfo.icon1, "rb");
	if (t)
	{
		icon1_size = getsize(t);
		icon1 = 1;
		fclose(t);
	}
	else
	{
		icon1_size = 0;
	}

	t = fopen(convertInfo.pic0, "rb");
	if (t)
	{
		pic0_size = getsize(t);
		pic0 = 1;
		fclose(t);
	}
	else
	{
		pic0_size = 0; //base_header[6] - base_header[5];
	}

	t = fopen(convertInfo.pic1, "rb");
	if (t)
	{
		pic1_size = getsize(t);
		pic1 = 1;
		fclose(t);
	}
	else
	{
		pic1_size = 0; // base_header[7] - base_header[6];
	}

	t = fopen(convertInfo.snd0, "rb");
	if (t)
	{
		snd_size = getsize(t);
		snd = 1;
		fclose(t);
	}
	else
	{
		snd = 0;
	}

	t = fopen(convertInfo.boot, "rb");
	if (t)
	{
		boot_size = getsize(t);
		boot = 1;
		fclose(t);
	}
	else
	{
		boot = 0;
	}

	t = fopen(convertInfo.data_psp, "rb");
	if (t)
	{
		prx_size = getsize(t);
		prx = 1;
		fclose(t);
	}
	else
	{
		fseek(base, base_header[8], SEEK_SET);
		fread(psp_header, 1, 0x30, base);

		prx_size = psp_header[0x2C/4];
	}

	header[0] = 0x50425000;
	header[1] = 0x10000;
	
	header[2] = curoffs;

	curoffs += sfo_size;
	header[3] = curoffs;

	curoffs += icon0_size;
	header[4] = curoffs;

	curoffs += icon1_size;
	header[5] = curoffs;

	curoffs += pic0_size;
	header[6] = curoffs;

	curoffs += pic1_size;
	header[7] = curoffs;

	curoffs += snd_size;
	header[8] = curoffs;

	x = header[8] + prx_size;

	if ((x % 0x10000) != 0)
	{
		x = x + (0x10000 - (x % 0x10000));
	}
	
	header[9] = x;

	fwrite(header, 1, 0x28, out);

	printf("Writing sfo...\n");

	fseek(base, base_header[2], SEEK_SET);
	fread(buffer, 1, sfo_size, base);
	SetSFOTitle(buffer, convertInfo.saveTitle);
	SetSFOCode (buffer, convertInfo.saveID);
	//strcpy(buffer+0x108, code);
	fwrite(buffer, 1, sfo_size, out);

	printf("Writing icon0.png...\n");

	if (icon0)
	{
		t = fopen(convertInfo.icon0, "rb");
		fread(buffer, 1, icon0_size, t);
		fwrite(buffer, 1, icon0_size, out);
		fclose(t);
	}

	if (icon1)
	{
		printf("Writing icon1.pmf...\n");
		
		t = fopen(convertInfo.icon1, "rb");
		fread(buffer, 1, icon1_size, t);
		fwrite(buffer, 1, icon1_size, out);
		fclose(t);
	}

	if (pic0)
	{
		printf("Writing pic0.png...\n");
		
		t = fopen(convertInfo.pic0, "rb");
		fread(buffer, 1, pic0_size, t);
		fwrite(buffer, 1, pic0_size, out);
		fclose(t);
	}

	if (pic1)
	{
		printf("Writing pic1.png...\n");
		
		t = fopen(convertInfo.pic1, "rb");
		fread(buffer, 1, pic1_size, t);
		fwrite(buffer, 1, pic1_size, out);
		fclose(t);
	}

	if (snd)
	{
		printf("Writing snd0.at3...\n");
		
		t = fopen(convertInfo.snd0, "rb");
		fread(buffer, 1, snd_size, t);
		fwrite(buffer, 1, snd_size, out);
		fclose(t);
	}

	printf("Writing DATA.PSP...\n");
	if (prx)
	{
		t = fopen(convertInfo.data_psp, "rb");
		fread(buffer, 1, prx_size, t);
		fwrite(buffer, 1, prx_size, out);
		fclose(t);
	}
	else
	{
		fseek(base, base_header[8], SEEK_SET);
		fread(buffer, 1, prx_size, base);
		fwrite(buffer, 1, prx_size, out);
	}

	offset = ftell(out);
	
	for (i = 0; i < header[9]-offset; i++)
	{
		fputc(0, out);
	}

	printf("Writing iso header...\n");

	fwrite("PSISOIMG0000", 1, 12, out);

	p1_offset = ftell(out);
	
	x = isosize + 0x100000;
	fwrite(&x, 1, 4, out);

	x = 0;
	for (i = 0; i < 0xFC; i++)
	{
		fwrite(&x, 1, 4, out);
	}

	memcpy(data1+1, convertInfo.gameID, 4);
	memcpy(data1+6, convertInfo.gameID+4, 5);
/*
	offset = isorealsize/2352+150;
	min = offset/75/60;
	sec = (offset-min*60*75)/75;
	frm = offset-(min*60+sec)*75;
	data1[0x41b] = bcd(min);
	data1[0x41c] = bcd(sec);
	data1[0x41d] = bcd(frm);
*/
	if (convertInfo.tocSize>0)
	{
		printf("Copying toc to iso header...\n");
		memcpy(data1+1024, convertInfo.tocData, convertInfo.tocSize);
	}
	fwrite(data1, 1, sizeof(data1), out);

	p2_offset = ftell(out);
	x = isosize + 0x100000 + 0x2d31;
	fwrite(&x, 1, 4, out);

	strcpy((char*)(data2+8), convertInfo.gameTitle);
	fwrite(data2, 1, sizeof(data2), out);

	index_offset = ftell(out);

	printf("Writing indexes...\n");

	memset(dummy, 0, sizeof(dummy));

	offset = 0;

	if (complevel == 0)
	{	
		x = 0x9300;
	}
	else
	{
		x = 0;
	}

	for (i = 0; i < isosize / 0x9300; i++)
	{
		fwrite(&offset, 1, 4, out);
		fwrite(&x, 1, 4, out);
		fwrite(dummy, 1, sizeof(dummy), out);

		if (complevel == 0)
			offset += 0x9300;
	}

	offset = ftell(out);

	for (i = 0; i < (header[9]+0x100000)-offset; i++)
	{
		fputc(0, out);
	}

	printf("Writing iso...\n");

	totSize=0;
	if (complevel == 0)
	{
		i=0;
		if (convertInfo.srcIsPbp)
		{
			for (i=0;i<blockCount;i++)
			{
				bufferSize=popstripReadBlock(iso_index,i,(unsigned char*)buffer2);

				if (convertInfo.patchCount>0) patchData(buffer2, bufferSize, totSize);
				totSize+=bufferSize;
				if (totSize>isorealsize)
				{
					bufferSize=bufferSize - (totSize - isorealsize);
					totSize=isorealsize;
				}

				fwrite(buffer2,1,bufferSize,out);

				PostMessage(convertInfo.callback,WM_CONVERT_PROGRESS,0,totSize);
				if (cancelConvert)
				{
					fclose(in);
					fclose(out);
					fclose(base);
					if (convertInfo.srcIsPbp)	popstripFinal(&iso_index);
					return 0;
				}
			}
		} else
		{
			while ((x = fread(buffer, 1, 1048576, in)) > 0)
			{
				if (convertInfo.patchCount>0) patchData(buffer, x, i);
				fwrite(buffer, 1, x, out);

				i+=x;
				PostMessage(convertInfo.callback,WM_CONVERT_PROGRESS,0,i);
				if (cancelConvert)
				{
					fclose(in);
					fclose(out);
					fclose(base);

					return 0;
				}
			}
		}

		for (i = 0; i < (isosize-isorealsize); i++)
		{
			fputc(0, out);
		}
	}
	else
	{
 		indexes = (IsoIndex *)malloc(sizeof(IsoIndex) * (isosize/0x9300));

		if (!indexes)
		{
			fclose(in);
			fclose(out);
			fclose(base);
			if (convertInfo.srcIsPbp)	popstripFinal(&iso_index);

			return popstationErrorExit("Cannot alloc memory for indexes!\n");
		}

		i = 0;
		j = 0;
		offset = 0;

		while (true)
		{

			if (convertInfo.srcIsPbp)
			{
				if (i>=blockCount) break;
				bufferSize=popstripReadBlock(iso_index,i,(unsigned char*)buffer2);

				totSize+=bufferSize;
				if (totSize>isorealsize)
				{
					bufferSize=bufferSize - (totSize - isorealsize);
					totSize=isorealsize;
				}
				x=bufferSize;
			} else
			{
				x = fread(buffer2, 1, 0x9300, in);
			}
			if (x==0) break;
			if (convertInfo.patchCount>0) patchData(buffer2, x, j);

			j+=x;
			PostMessage(convertInfo.callback,WM_CONVERT_PROGRESS,0,j);
			if (cancelConvert)
			{
				fclose(in);
				fclose(out);
				fclose(base);
				free(indexes);
				if (convertInfo.srcIsPbp)	popstripFinal(&iso_index);

				return 0;
			}

			if (x < 0x9300)
			{
				memset(buffer2+x, 0, 0x9300-x);
			}
			
			x = deflateCompress(&z, buffer2, 0x9300, buffer, sizeof(buffer), complevel);

			if (x < 0)
			{
				fclose(in);
				fclose(out);
				fclose(base);
				free(indexes);
				if (convertInfo.srcIsPbp)	popstripFinal(&iso_index);

				return popstationErrorExit("Error in compression!\n");
			}

			memset(&indexes[i], 0, sizeof(IsoIndex));

			indexes[i].offset = offset;

			if (x >= 0x9300) /* Block didn't compress */
			{				
				indexes[i].length = 0x9300;
				fwrite(buffer2, 1, 0x9300, out);
				offset += 0x9300;
			}
			else
			{
				indexes[i].length = x;
				fwrite(buffer, 1, x, out);
				offset += x;
			}

			i++; 
		}

		if (i != (isosize/0x9300))
		{
			fclose(in);
			fclose(out);
			fclose(base);
			free(indexes);

			return popstationErrorExit("Some error happened.\n");
		}

		x = ftell(out);

		if ((x % 0x10) != 0)
		{
			end_offset = x + (0x10 - (x % 0x10));
			
			for (i = 0; i < (end_offset-x); i++)
			{
				fputc('0', out);
			}
		}
		else
		{
			end_offset = x;
		}

		end_offset -= header[9];
	}

	printf("Writing special data...\n");
	
	fseek(base, base_header[9]+12, SEEK_SET);
	fread(&x, 1, 4, base);

	x += 0x50000;

	fseek(base, x, SEEK_SET);
	fread(buffer, 1, 8, base);
	
	if (memcmp(buffer, "STARTDAT", 8) != 0)
	{
		return popstationErrorExit("Cannot find STARTDAT in %s.\n",
			      "Not a valid PSX eboot.pbp\n", BASE);
	}

	fseek(base, x+16, SEEK_SET);
	fread(header, 1, 8, base);
	fseek(base, x, SEEK_SET);
	fread(buffer, 1, header[0], base);

	if (!boot)
	{
		fwrite(buffer, 1, header[0], out);
		fread(buffer, 1, header[1], base);
		fwrite(buffer, 1, header[1], out);
	}
	else
	{
		printf("Writing boot.png...\n");

		ib[5] = boot_size;
		fwrite(buffer, 1, header[0], out);
		t = fopen(convertInfo.boot, "rb");
		fread(buffer, 1, boot_size, t);
		fwrite(buffer, 1, boot_size, out);
		fclose(t);
		fread(buffer, 1, header[1], base);
	}

	while ((x = fread(buffer, 1, 1048576, base)) > 0)
	{
		fwrite(buffer, 1, x, out);
	}

	if (complevel != 0)
	{
		printf("Updating compressed indexes...\n");

		fseek(out, p1_offset, SEEK_SET);
		fwrite(&end_offset, 1, 4, out);

		end_offset += 0x2d31;
		fseek(out, p2_offset, SEEK_SET);
		fwrite(&end_offset, 1, 4, out);

		fseek(out, index_offset, SEEK_SET);
		fwrite(indexes, 1, sizeof(IsoIndex) * (isosize/0x9300), out);
	}

	fclose(in);
	fclose(out);
	fclose(base);
	if (convertInfo.srcIsPbp)	popstripFinal(&iso_index);

	PostMessage(convertInfo.callback,WM_CONVERT_DONE,0,0);
}
