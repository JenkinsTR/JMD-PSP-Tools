# PSP UMD Background Project

## Purpose
This work-in-progress project aims to standardize and unify the principles of the ICON0, ICON1, PIC0, PIC1 game boot graphics into one patch-able package.

Developers didn't always know about or have reason enough to create proper backgrounds and associated icons for their games.

All games have at least a 144x80 PNG icon (usually `PSP_GAME\ICON0.PNG`). But it is then a variety of combinations that games use beyond this.

See my PIC0 template here to get a visual idea of the elements: `http://link`

## Terminology
`ICON0.PNG` = The 'Primary title icon' | 144px width, 80px height | PNG

`ICON1.PMF` = Animated 'Primary title icon' | 144px width, 80px height | PlayStation Movie Format

`PIC0.PNG` = The large 'logo icon' | 310px width, 180px height | PNG

`PIC1.PNG` = The full cover background wallpaper | 480px width, 272px height | PNG

`SND0.AT3` = The looping background music. | Filesize limits? | Sony Atract3 format

## Principles to adhere to
While there are no actual 'rules' (and a very short official guide in PSP SDK docs), the best UMD Backgrounds & Icons seem to be ones that make use of all 5 different components; ICON0.PNG, ICON1.PMF, PIC0.PNG, PIC1.PNG & SND0.AT3.

Creating animated Primary icons is quite involved, and may not be included in this project due to the difficulty (and time) to screen record games off the PSP or use clips from YouTube. However, it may be possible to re-use publisher boot logos and make them ICON1 compliant.

`ICON0.PNG` = Should be a small framed logo of the game. Can also be transparent without a background. Required and every game already has one (and most are good).

`ICON1.PMF` = As above, the animated 'Primary' icon is in a propriatary Sony format known as "PMF" (PlayStation Movie Format). Creating these is possible but time consuming.

`PIC0.PNG` = This should be a high quality logo of the game itself, optionally with copyrights of the publisher along the bottom 10-15px. Looks best when fully transparent.

`PIC1.PNG` = Because of including the game logo in PIC0 above, this background should be as minimal as possible, while still being from the game itself. PIC0 fades in over the top of this image within about 1sec of the game becoming the 'active' view.

`SND0.AT3` = These can be edited or replaced but require having the propriatary AT3 codec installed to decode/encode.

Only about 10-20% of games follow the above guidelines, and ones that don't can sometimes look pretty average to poor. 

With these in mind, the project was born. 

## Code approach
Using Windows batch and ImageMagick we can update a lot of games with readily available data that we don't need to recreate.

See `http://link ISO Tools\extract_metadata_files_from_ISO_ALL` on how to extract just the metadata, including these images, from a folder of ISOs.

We need to break down the common variations in order to prepare for covering all bases when processing games.

There seems to be 4 common types, in no particular order;

*Group A* - A game only has `ICON0.PNG` and no other boot graphics. This is the bare minimum and 100% of games should have it.

*Group B* - A game that has ONLY `ICON0.PNG` and `PIC1.PNG` (full screen background). About 50-75% of games are this type.

*Group C* - Game has `ICON0.PNG`, `ICON1.PMF` and `PIC1.PNG`. About 20-40% of games are this type.

*Group D* - A game that has all elements, `ICON0.PNG`, `ICON1.PMF`, `PIC0.PNG` and `PIC1.PNG`. This is the least common, but most professional. "AAA" games are more likely to have these than Indie games or ports from older PS2 titles.

It's pretty random which groups the `SND0.AT3` background music is included in, but there exists cases where titles in each group do and don't contain one.

First we need to find all of the Group D titles, and separate them;

`@ECHO OFF`

`REM We need to have already extracted ISOs to a folder.`

`REM Searching for UMD_DATA.BIN is the only way to capture the master folder with 100% accuracy`
`FOR /R %%G IN (*UMD_DATA.BIN) DO (`
	`SET GAME=%%~dpG`
	`SET PSP_GAME=!GAME!PSP_GAME`
	`PUSHD "!PSP_GAME!"`
	
	`IF EXIST "!PSP_GAME!\ICON0.PNG" (`
		`ECHO GROUP A`
		`ECHO Found game icon, continuing . . .`
		`ECHO !PSP_GAME!\ICON0.PNG > umd_background.txt`
		`ECHO ------------------------------------`
		
		`IF EXIST "!PSP_GAME!\PIC1.PNG" (`
			`ECHO GROUP B`
			`ECHO Found game background, continuing . . .`
			`ECHO ------------------------------------`
			`ECHO !PSP_GAME!\PIC1.PNG >> umd_background.txt`
			
			`IF EXIST "!PSP_GAME!\ICON1.PMF" (`
				`ECHO GROUP C`
				`ECHO Found aniamted icon, continuing . . .`
				`ECHO ------------------------------------`
				`ECHO !PSP_GAME!\ICON1.PMF >> umd_background.txt`
				
				`IF EXIST "!PSP_GAME!\PIC0.PNG" (`
					`ECHO GROUP D`
					`ECHO Found large icon, all elements found`
					`ECHO ------------------------------------`
					`ECHO !PSP_GAME!\PIC0.PNG >> umd_background.txt`
					
				`) ELSE (`
					`ECHO Large icon not found . . .`
					`ECHO ------------------------------------`
				`)`
				
			`) ELSE (`
				`ECHO Animated icon not found . . .`
				`ECHO ------------------------------------`
			`)`			
			
		`) ELSE (`
			`ECHO Game background not found . . .`
			`ECHO ------------------------------------`
		`)`
		
	`) ELSE (`
		`ECHO Game icon not found . . .`
		`ECHO ------------------------------------`
	`)`
	
`)`

