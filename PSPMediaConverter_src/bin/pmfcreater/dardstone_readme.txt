PLACE YOUR MPS FILE IN THE SAME FOLDER AS THIS DIRECTORY (Where this readme file is). RENAME YOU "00001.MPS" to "GAMEBOOT.MPS" and place in the same directory as the extracted files.
RUN THE FILE CALLED "RUN ME". YOUR "gameboot.pmf" will be created in the same folder. :)

Made By: DarkStone
Enhanced by: $n!pR =]

i will tell you how to make your source file since that is not illegal. converting it with the umd composer software is illegal. anyways... here goes....

Download and Install:
VirtualDubMod - [url]http://puzzle.dl.sourceforge.net/sourceforge/virtualdub/VirtualDub-1.6.15.ziphttp://umn.dl.sourceforge.net/sourceforge/virtualdubmod/VirtualDubMod_1_5_10_2_All_inclusive.zip[/url]
AviSynth - [url]http://nchc.dl.sourceforge.net/sourceforge/avisynth2/AviSynth_220406.exe[/url]

Install AviSynth 1st. Now extract VirtualDubMod to a folder.
Find the file you want to convert. Once found, open up notepad. 
Type the following lines in the text document.
-----------------------------------------------------------

DirectShowSource("YOURVIDEOFILEHERE.EXTENSION")
lanczosresize(480,272)
changefps(29.97)

-----------------------------------------------------------

Replace YOURVIDEOFILEHERE.EXTENSION with the name of the file you want to convert including its extension. For example,

-----------------------------------------------------------

DirectShowSource("naruto.avi")
lanczosresize(480,272)
changefps(29.97)

-----------------------------------------------------------

Now save your text document in the same folder as your movie file. Make sure you save it as an .AVS file and not a .TXT file. This is done by changing "Save as type" to "All Files" and adding the extension the the filename you are going to save it as, eg, NARUTO.AVS.

Now locate the folder you extracted virtualdubmod to. open VirtualDubMod.exe 

Go to File>Open File. Find your .AVS file. Open that. you should now see your video file in the window. 

Now go to Streams>Stream List.

Click Save WAV. After it is saved click disable. Now go to OK.

Now go to File>Save As. name your avi file and click save.

Almost there now. :) Last step!

Find your WAV file you saved. Open it with sound recorder. Go to File>Save As.

Where it says Format at the bottom of the save window, click on Change.

Format should be: PCM
Atrributes: 44.100 kHz, 16 Bit, Stereo                172kb/sec.

Click ok. Now save your WAV as a new name.

Sony UMD Tools
1: Open up the UMD Stream composer.exe
2: Go to new
3: Name it what you want. Click next
4: Tick the PSP Movie format (for game) bit.
5: Change the max clip size to 2mb or less
6: Hit finish
7: Go to video source
8: Find your video file made earlier with Virtual Dub Mod
9: Go to audio source
10: Find the WAV you made earlier.
11: Now go to run at the top
12: Choose encode + multiplex
13: Hit start
14: Well done the .mps has been made

Step 4, .mps to .pmf Converter
1: Go to My Documents (well yours)
2: Go to the UMD Stream composer folder
3: The .mps file is in here somewhere (I forget where exactly!)
4: Now rename the .mps file to gameboot.
5: Put it in the same directory as the .mps to .pmf converter
6: Run the converter (Click Run Me)
7: And your gameboot.pmf should be created

Now flash it your PSP using X-flash. As long as you have custom firmware installed with recovery mode, there are no worries!

Thats it! :) it seems tedious work but it becomes very easy once you get the hang of it. Good Luck!

Bugfix by *DarkStone*

v 0.6


thanks to  Mathieulh for giving me some tips :D ;)
thanks to FoG and thanks to babyg :) your support is GREATLY APPRECIATED.