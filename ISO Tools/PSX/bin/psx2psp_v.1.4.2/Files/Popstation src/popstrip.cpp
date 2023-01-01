#include <stdio.h>
//#include <string.h>
//#include <stdlib.h>
//#include <stdarg.h>
#include <windows.h>
#include "zlib.h"
#include "popstrip.h"

ExtractIsoInfo extractInfo;
bool cancelExtract=FALSE;
char *pbpFileName;

DWORD WINAPI extractIso(LPVOID hwndDlg);

HANDLE popstripExtract(ExtractIsoInfo info)
{
	DWORD dwThreadId;

	extractInfo=info;
	cancelExtract=FALSE;
	return CreateThread(NULL, 0, extractIso, (LPDWORD)info.callback, 0, &dwThreadId);
}

void popstripCancel()
{
	cancelExtract=TRUE;
}

int popstripErrorExit(char *fmt, ...)
{
	va_list list;
	char msg[256];

	va_start(list, fmt);
	vsprintf(msg, fmt, list);
	va_end(list);

	PostMessage(extractInfo.callback,WM_EXTRACT_ERROR,0,0);
	MessageBox(extractInfo.callback,msg,"Popstation - Error",MB_OK | MB_ICONERROR);
	return 0;
}

DWORD WINAPI extractIso(LPVOID hwndDlg)
{
	FILE *iso_stream;
	INDEX *iso_index=NULL;
	int isoSize=0;
	unsigned char buffer[0x9300];
	int bufferSize;
	int i;
	int blockCount;
	int totSize=0;


	// Open the output ISO file
	iso_stream = fopen(extractInfo.dstISO, "wb");
	if (iso_stream == NULL) {
		return popstripErrorExit("Unable to open \"%s\".",extractInfo.dstISO);
	}

	blockCount=popstripInit(&iso_index,extractInfo.srcPBP);
	if (blockCount==0) return popstripErrorExit("No iso index was found.",extractInfo.dstISO);
	isoSize=popstripGetIsoSize(iso_index);
	PostMessage(extractInfo.callback,WM_EXTRACT_SIZE,0,isoSize);
	for (i=0;i<blockCount;i++)
	{
		bufferSize=popstripReadBlock(iso_index,i,buffer);

		totSize+=bufferSize;
		if (totSize>isoSize)
		{
			bufferSize=bufferSize - (totSize - isoSize);
			totSize=isoSize;
		}

		fwrite(buffer,1,bufferSize,iso_stream);

		PostMessage(extractInfo.callback,WM_EXTRACT_PROGRESS,0,totSize);
		if (cancelExtract) break;
	}
	fclose(iso_stream);
	popstripFinal(&iso_index);
	PostMessage(extractInfo.callback,WM_EXTRACT_DONE,0,0);

	return 0;
}

int WINAPI popstripInit(INDEX **iso_index, char* pbpFile)  //Returns index count
{
	FILE *pbp_stream;
	int psar_offset;
	int this_offset;
	int count;
	int offset;
	int length;
	int dummy[6];

	pbpFileName=pbpFile;

	(*iso_index)=(INDEX*)malloc(sizeof(INDEX)*MAX_INDEXES);
	
	// Open the PBP file
	pbp_stream = fopen(pbpFileName, "rb");
	if (pbp_stream == NULL)
	{
		return popstripErrorExit("Unable to open \"%s\".",pbpFileName);
	}
	
	// Read in the offset of the PSAR file
	fseek(pbp_stream, HEADER_PSAR_OFFSET, SEEK_SET);
	fread(&psar_offset, 4, 1, pbp_stream);
	
	// Go to the location of the ISO indexes in the PSAR
	fseek(pbp_stream, psar_offset + PSAR_INDEX_OFFSET, SEEK_SET);
	
	// Store the current location in the PBP
	this_offset = ftell(pbp_stream);
	
	// Reset the counter variable
	count = 0;
	
	// Read indexes until the start of the ISO file
	while (this_offset < psar_offset + PSAR_ISO_OFFSET)
	{		
		// Read in the block offset from the index
		fread(&offset, 4, 1, pbp_stream);
		// Read in the block length from the index
		fread(&length, 4, 1, pbp_stream);
		// Read in the dummy bytes
		fread(&dummy, 4, 6, pbp_stream);
		
		// Record our current location in the PBP
		this_offset = ftell(pbp_stream);
		
		// Check if this looks like a valid offset
		if (offset != 0 || length != 0)
		{			
			// Store the block offset
			(*iso_index)[count].offset = offset;
			// Store the block length
			(*iso_index)[count].length = length;
			count++;
			if (count>=MAX_INDEXES)
			{
				free((*iso_index));
				(*iso_index)=NULL;
				fclose(pbp_stream);
				return 0;
			}
		}
	}
	fclose(pbp_stream);

	return count;
}

int WINAPI popstripReadBlock(INDEX *iso_index, int blockNo, unsigned char *out_buffer)
{
	FILE *pbp_stream;
	unsigned char *in_buffer;
	z_stream z;
	int psar_offset;
	int this_offset;
//	int count;
	int out_length;

	pbp_stream = fopen(pbpFileName, "rb");
	if (pbp_stream == NULL)
	{
		return popstripErrorExit("Unable to open \"%s\".",pbpFileName);
	}

	// Read in the offset of the PSAR file
	fseek(pbp_stream, HEADER_PSAR_OFFSET, SEEK_SET);
	fread(&psar_offset, 4, 1, pbp_stream);

	// Go to the offset specified in the index
	this_offset = psar_offset + PSAR_ISO_OFFSET + iso_index[blockNo].offset;
	fseek(pbp_stream, this_offset, SEEK_SET);
		
	// Allocate memory for our output buffer
	//(*out_buffer) = (unsigned char*)malloc(16 * ISO_BLOCK_SIZE);
		
	// Check if this block isn't compressed
	if (iso_index[blockNo].length == 16 * ISO_BLOCK_SIZE)
	{
	
		// It's not compressed, make an exact copy
		fread(out_buffer, 1, 16 * ISO_BLOCK_SIZE, pbp_stream);
			
		// Output size is a full block
		out_length = 16 * ISO_BLOCK_SIZE;
			
	// If the block is compressed
	} else
	{
			
		// Allocate memory for our input buffer			
		in_buffer = (unsigned char*)malloc(iso_index[blockNo].length);
		if (!in_buffer)
		{
			return popstripErrorExit("Unable to allocate memory.");
		}
			
		// Read in the number of bytes specified in the index
		fread(in_buffer, 1, iso_index[blockNo].length, pbp_stream);
			
		// Set up the zlib inflation
		z.zalloc = Z_NULL;
		z.zfree = Z_NULL;
		z.opaque = Z_NULL;
		z.avail_in = 0;
		z.next_in = Z_NULL;
		inflateInit2(&z, -15);
			
		// Set up the input stream
		z.avail_in = iso_index[blockNo].length;
		z.next_in = in_buffer;
			
		// Set up the output stream
		z.avail_out = 16 * ISO_BLOCK_SIZE;
		z.next_out = out_buffer;
			
		// Inflate the data from the PBP
		inflate(&z, Z_NO_FLUSH);
			
		// Output size should be a full block
		out_length = 16 * ISO_BLOCK_SIZE - z.avail_out;
			
		// Clean up the input buffer
		free(in_buffer);
			
		// Clean up the zlib inflation
		inflateEnd(&z);
	}
	fclose(pbp_stream);
	return out_length;
}

int WINAPI popstripGetIsoSize(INDEX *iso_index)
{
	unsigned char out_buffer[0x9300];
	int iso_length;

	// The ISO size is contained in the data referenced in index #2
	// If we've just read in index #2, grab the ISO size from the output buffer
	popstripReadBlock(iso_index,1,out_buffer);
	iso_length = (out_buffer[104] + (out_buffer[105] << 8) + (out_buffer[106] << 16) + (out_buffer[107] << 24)) * ISO_BLOCK_SIZE;
//	free(out_buffer);

	return iso_length;
}

void WINAPI popstripFinal(INDEX **iso_index)
{
	free(*iso_index);
}
