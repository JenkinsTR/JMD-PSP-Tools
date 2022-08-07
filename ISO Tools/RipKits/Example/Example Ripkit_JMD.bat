@ECHO OFF

REM SET a copy macro for the 0 byte input
SET ZEROB=COPY "K:\GitHub\JMD-PSP-Tools\ISO Tools\RipKits\Bin\zero.file"

REM Each unwanted file can be parsed in the following simple way
%ZEROB% "D:\Games\PSP\_RIPkits\Some Cool Game\sound\sounds_FR.xwb" /Y
%ZEROB% "D:\Games\PSP\_RIPkits\Some Cool Game\sound\sounds_GE.xwb" /Y
%ZEROB% "D:\Games\PSP\_RIPkits\Some Cool Game\sound\sounds_IT.xwb" /Y
%ZEROB% "D:\Games\PSP\_RIPkits\Some Cool Game\sound\sounds_SP.xwb" /Y

:: Note that every game is different.
:: Sometimes the unwanted files are buried in folders,
:: or are locked behind encrypted archives.

:: SOME COMMON LANGUAGE SHORTHAND
:: 		French			=	FR		|	fre,fra		|	_F
:: 		German			=	DE,GE	|	ger,deu		|	_G,_D
:: 		Italian			=	IT		|	ita			|	_I
:: 		Japanese		=	JP		|	jap,jpn		|	_J
:: 		Spanish			=	SP		|	spa,esp		|	_S,_E
:: 		Mexican			=	MX		|	mex,spa		|	_M,_S
:: 		Polish			=	PO,PL	|	pol			|	_P
:: 		Russian			=	RU		|	rus			|	_R
:: 		Korean			=	KO		|	kor			|	_K
:: 		Portugese		=	PT,BR	|	por,bra		|	_B
:: 		Hungarian		=	HU		|	por,bra		|	_B
:: 		Czech			=	CZ		|	por,bra		|	_B
:: 		Dutch			=	NL		|	dut,ntl		|	_N,_D
:: 		Chinese			=	ZH,CN	|	zho,chn		|	_C,_Z
:: Chinese Traditional	=	CN,CT	|	cht,chn		|	_C,_T

:: Be careful when referencing the last column as it might conflict with actual important game files.
:: You should only attempt them when they aren't orphaned by themselves
:: Example: when a folder contains something like
::      GAMEDATA\COMMON\STRINGS_E.DAT
::      GAMEDATA\COMMON\STRINGS_F.DAT
::      GAMEDATA\COMMON\STRINGS_G.DAT
::      GAMEDATA\COMMON\STRINGS_I.DAT
::      GAMEDATA\COMMON\STRINGS_S.DAT

:: This is might be self explanitory but the above are game string databases in English, French, German, Italian and Spanish respectively.

:: A question I'm asked often is Why do this? Why not just delete the files?
:: The answer is simple but important;
:: Most platforms, not just PSP, and their software, have hard coded references to asset files inside the software itself.
:: Deleting the unwanted files only works in about 30-50% of cases. This method works more like 90%+ of the time.

:: A lot of games check for the existance of files before they will boot correctly. If they don't exist, it won't boot.
:: Doing this Zero Byte method means that the game can still find the files (even though they're empty), and it will continue to boot as normal.

:: The only instances that will cause a crash is when you completely zero-byte a whole language, and then attempt to switch to that language in-game.

REM Press any key to continue
PAUSE

REM Safely exit cmd
EXIT




