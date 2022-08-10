# JMD PSP Tools
 JMDigital's PSP Tool collection
 
## ISO Tools\
Batch tools to manage, convert, compress, extract and create PSP ISOs.

Important Note: Files that contain exclamation marks (!) will likely fail to process on most or all of these tools. You will have to find and rename them manually first before using any of the below.
I haven't made a tool for this because in some cases, they can be replaced with ` - ` (like the *Buzz!* titles) but others that have it at the end of the name, require removing it instead of replacing it.

This will include a lot of Japanese game titles, even when they're the translated English region (US or EUR) title.

For large folders containing many ISOs, use the search bar in Windows Explorer and search for `*!*.iso` to make it easier to find them all.

----
### add_UID_to_end_of_ALL_ISOs.bat
 Run this in a folder that contains PSP ISOs and it will add the UMD ID to the end of the ISO name.
  - Before: `ATV Offroad Fury Pro (USA).iso`
 - After: `ATV Offroad Fury Pro (USA) [UCUS-98648].iso`
 
Because of a bug in the way this tool works, you will need to **hold a key down to continue** as the 3rd party tool used, umdatabase, is not designed for this purpose.
 
It will look like nothing is happening, but **make sure you press a key to check**, as the process is usually fast, no longer than about 20secs for large UMD images.

*For very large folders full of ISOs, you might want to jam something in a key on your keyboard to be able to walk away. I use the UP key and a small pair of scissors, using UP to prevent any issues arising if I don't come back in time. This will mean you can't use the computer until it is done, but it is better than pressing a key 1000 times without prompts.*

I usually run this tool first. 

**Run** `get_iso_info_ALL.bat` **immediately after this tool** and ***optionally*** `extract_metadata_files_from_ISO_ALL.bat` to grab any important files/meta from the ISO before converting to CSO. 
You can then remove the ISO yourself after, as the header/meta/XMB data has been extracted by the above. Otherwise if you're planning on modding the game itself, or using a RipKit, or creating custom gameboots, then I suggest keeping the ISO as well.

### add_UID_to_end_of_ISO_dragdrop.bat
The same as above, but for singular ISOs that you can drag onto the batch file and it will repeat the above process.

----
### build_XML_cat_PSP.bat
Builds a simple XML catalogue database from all found `*_info.txt` files that were generated with `get_iso_info_ALL.bat` a.k.a the "PSP ISO Reporting Tool". 

Outputs to `ISO Tools\db\pspdb.xml` and file format is like so;

    <?xml version="1.0" encoding="UTF-8"?> 
    <PSPDB> 
    	<GAME> 
    		<TITLE>007 - From Russia with Love </TITLE> 
    		<TITLEID>ULUS-10080</TITLEID> 
    		<PUBL>ELECTRONIC ARTS</PUBL> 
    		<REGION>USA</REGION> 
    		<LANG>En</LANG> 
    		<UMDDATE>2006-01-23 14:22:41</UMDDATE> 
    		<UMDSIZE>698 MB</UMDSIZE> 
    	</GAME> 
    </PSPDB> 

All of the above data is pulled from the `gamename_info.txt` files mentioned above.

----
### create_PSPiso_from_folder.bat
A sophisticated Drag 'n Drop tool to create a PSP compliant ISO from an extracted disc folder. This was created with the help of the ancient free "*CDRTools*" and nircmd. It also uses a modified version of ciso by Boost from way back in 2005. Essentially, this doesn't use any part of the *PSP SDK* to create a compliant ISO.
 
 So long as you have named the folder correctly:
 
 `Game Name (Region) (Languages) [ULUS-######]`
 
 The tool will;
  - Run a timestamp builder that catalogues the timestamps of every file
  - **Creates a PSP compliant ISO**
  - Uses the oldest date in the file tree as the "CreatedDate" for the ISO
  - Uses the newest date in the file tree as the "LastModified" for the ISO
  - Options are available for changing Vendor ID and so on.
  - Info tool will be run against the output ISO, and a 'sidecar' TXT will be made containing the ISO meta and a list of files
  - mciso is used to compress the ISO to a CSO at the highest compression level.
  - The output ISO is destroyed, leaving just the smaller compressed CSO, and the sidecar TXT.
  
I deliberately didn't write a deletion portion for the input folder because that should be up to you to decide to keep or not.

----
### create_XMB_background_thumb_ISO_ALL.bat
TODO: This tool is not written yet, but will 'merge' all found metadata images relating to the XMB background of each game using ImageMagick.

----
### cso_to_iso_dragdrop.bat
Simple tool using mciso. Drag 'n Drop a CSO onto this and it will uncompress it, and create a resulting ISO in the same folder.

### cso_to_iso_ALL.bat
Similar to the above, but will convert all found CSOs in all sub folders to ISO.
 
----
### extract_all_ISOs_from_subdirs.bat
Note: Requires 7-zip 64bit to be installed
 
This is an old tool I've included because it still works well.
 
It will crawl through every folder and sub folder from where it is launched, and extract every found ISO into a folder of it's own, next to where the ISO was found.
 
 This works for PSP (and other platform) ISOs that aren't encrypted.

----
### extract_ISO_rar_7z_convert_to_CSO.bat
This tool will extract all RAR files in all sub folders containing an ISO, and immediately compress it to CSO, and remove the ISO after completion.

This can be modified to work with Zip or 7z, just change `*.rar` to `*.zip` in the `FOR /R %%G IN (*.rar) DO` line.

----
### extract_metadata_files_from_ISO_ALL.bat
Extract all meta images, sound, animated icons and SFO data from all ISOs in all sub folders.

    FILTER1="*PIC0.PNG"
    FILTER2="*PIC1.PNG"
    FILTER3="*ICON0.PNG"
    FILTER4="*ICON1.PNG"
    FILTER5="*ICON1.PMF"
    FILTER6="*PARAM.SFO"
    FILTER7="*SND0.AT3"

*FILTER4 is basically useless because no such files should exist, but I thought I would include anyway*

 - This tool was created for a variety of uses, especially if you're interested in creating custom GameBoots or XMB game backgrounds/icons.
 - I've also started a long term project to standardize and unify all PSP Game XMB background types in order to enhance titles that have no full screen background, or don't take use of the larger PIC0 icon.
 - More info can be found here: [UMD Background Project](https://github.com/JenkinsTR/JMD-PSP-Tools/tree/main/Graphics/UMD%20Background%20Project)

#### extract_metadata_files_from_CSO_ALL.bat
This is the same as above but for all CSO files in all sub folders, that are decompressed to ISO first, then the above ISO extract code is run, finally the ISO is removed.

This is safe to run on a folder that contains mixed types (CSO and ISO), as it will store ONLY the found CSO filenames, and use those for the output ISO, which is then the target for the deletion code.
Be careful if you have ISOs and CSOs in the same folder that share an exact same name, though. That is the only case I can see being a problem.

----
### get_iso_info_ALL.bat
 a.k.a "PSP ISO Reporting Tool"
 
Combines a few methods mentioned above to create a 'diagnostic' output of all ISOs found in every folder and sub folder from where it is launched. Resulting text files will be next to each ISO found with a "_info" suffix.

This tool should be immediately run after `add_UID_to_end_of_ALL_ISOs.bat`
 
### get_iso_info_dragdrop.bat
As above, but for singular ISOs.
 
----
### get_UID_from_name_dragdrop.bat
A small proof-of-concept that was used in the `add_UID_to_end_of_ALL_ISOs` tool. Drag 'n 'Drop a folder or file onto this and if it contains a UID in square brackets, it will be displayed in the console as "Volume ID".
 
----
### iso_to_cso_dragdrop.bat
The reverse of `cso_to_iso_dragdrop`. Drag 'n Drop an ISO onto this and it will compress it, and create a resulting CSO in the same folder.

### iso_to_cso_ALL.bat
Similar to the above, but will convert all found ISOs in all sub folders to CSO.
 
----
## RipKits\
 RipKits are batch files that are written for specific games that remove junk padding, *PSP System Updates* that are included on the disc, and other languages that aren't English, where possible.
 
 Currently there are _92_ supported games, with more to come. They're located in the `ISO Tools\RipKits\Games` folder.
 
 An example source is included in `ISO Tools\RipKits\Example` that will get you started on making your own
 
 The *Deprecated* folder includes 2 scripts that were re-written in 2020 in order to generate dummy txt and CSO files with the aim of overwriting them from within UMDGen.
 
 These are no longer used because the process took too long to create the 92 rips originally, which was a driving factor for creating this whole toolkit to begin with 🤪
 
# PSPMediaConverter_src
## jm_pspmc_v1.bat
Work-in-progress (but functional) tool to create PSP compliant AVC videos using FFMpeg from virtually `any` video input source.
 
One of the features of this program is support for "VFR" (Variable FrameRate) videos. Most PSP video converters will force a VFR video to be CFR, often resulting in out-of-sync audio/video streams.
 
This tool combats that by using a more advanced and strict FFMPeg approach that the PSP seems to support in all my tests. The 23min pilot episode for "Futurama" was used as a test, and the output came in at about 70mb and the visual quality was very high.
 
Sadly, this tool doesn't seem to work on a retail PSP with Official Firmware installed. There is no way to have the video be supported like this on retail *and* CFW at the same time.
 
I've included a bit of documentation on the actual video codec formats for the PSP itself, gathered from various sources on the internet over the years.
 
Contrary to what most docs say, at some point Sony updated the PSP to support videos with "miXEd caSIng anD SpACes" on mp4 videos. Only the "MP_ROOT" folder has special filename requirements, and isn't needed.

----
## pmf_converter_v1.bat
**[NOT FUNCTIONING PROPERLY - WiP]**
This is the first attempt at a fully automated PMF converter.
Fails due to possible bug in old stream composer.

# More to come!
