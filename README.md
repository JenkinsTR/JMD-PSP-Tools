# JMD PSP Tools
 JMDigital's PSP Tool collection
 
## ISO Tools
 Tools to manage, convert, compress, extract and create PSP ISOs.

### add_UID_to_end_of_ALL_ISOs.bat
 Run this in a folder that contains PSP ISOs and it will add the UMD ID to the end of the ISO name.
 
 Before: `ATV Offroad Fury Pro (USA).iso`
 After: `ATV Offroad Fury Pro (USA) [UCUS-98648].iso`
 
 Because of a bug in the way this tool works, you will need to hold a key down to continue as the 3rd party tool used, umdatabase, is not designed for this purpose.
 
 It will look like nothing is happening, but make sure you press a key to check, as the process is usually fast, no longer than about 20secs for large UMD images.
 
### add_UID_to_end_of_ISO_dragdrop.bat
 The same as above, but for singular ISOs that you can drag onto the batch file and it will repeat the above process.
 
### create_PSPiso_from_folder.bat
 A sophisticated Drag 'n Drop tool to create a PSP compliant ISO from an extracted disc. This was created with the help of the ancient free "CDRTools" and nircmd. It also uses a modified version of ciso by Boost from way back in 2005.
 
 So long as you have named the folder correctly:
 
 `Game Name (Region) (Languages) [ULUS-######]`
 
 The tool will;
  - Run a timestamp builder that catelogues the timestamps of every file
  - Creates a PSP compliant ISO
  - Uses the oldest date in the file tree as the "CreatedDate" for the ISO
  - Uses the newest date in the file tree as the "LastModified" for the ISO
  - Options are available for changing Vendor ID and so on.
  - Info tool will be run against the output ISO, and a 'sidecar' TXT will be made containing the ISO meta and a list of files
  - mciso is used to compress the ISO to a CSO at the highest compression level.
  - The output ISO is destroyed, leaving just the smaller compressed CSO, and the sidecar TXT.
  
  I delibrately didn't write a deletion portion for the input folder because that should be up to you to decide to keep or not.
 
### cso_to_iso_dragdrop.bat
 Simple tool using mciso. Drag 'n Drop a CSO onto this and it will uncompress it, and create a resulting ISO in the same folder.
 
### extract_all_ISOs_from_subdirs.bat
 Note: Requires 7-zip 64bit to be installed
 
 This is an old tool I've included because it still works well.
 
 It will crawl through every folder and sub folder from where it is launched, and extract every found ISO into a folder of it's own, next to where the ISO was found.
 
 This works for PSP (and other platform) ISOs that aren't encrypted.
 
### get_iso_info_ALL.bat
 a.k.a "PSP ISO Reporting Tool"
 
 Combines a few methods mentioned above to create a 'diagnostic' output of all ISOs found in every folder and sub folder from where it is launched. Resulting text files will be next to each ISO found with a "_info" suffix.
 
### get_iso_info_dragdrop.bat
 As above, but for singular ISOs.
 
### get_UID_from_name_dragdrop.bat
 A small proof-of-concept that was used in the `add_UID_to_end_of_ALL_ISOs` tool. Drag 'n 'Drop a folder or file onto this and if it contains a UID in square brackets, it will be displayed in the console as "Volume ID".
 
### iso_to_cso_dragdrop.bat
 The reverse of `cso_to_iso_dragdrop`. Drag 'n Drop an ISO onto this and it will compress it, and create a resulting CSO in the same folder.
 
## RipKits
 RipKits are batch files that are written for specific games that remove junk padding, *PSP System Updates* that are included on the disc, and other languages that aren't English, where possible.
 
 Currently there are _92_ supported games, with more to come. They're located in the `ISO Tools\RipKits\Games` folder.
 
 An example source is included in `ISO Tools\RipKits\Example` that will get you started on making your own
 
 The *Deprecated* folder includes 2 scripts that were re-written in 2020 in order to generate dummy txt and CSO files with the aim of overwriting them from within UMDGen.
 
 This process took too long to create the 92 rips originally, which was a driving factor for creating this toolkit.
 
## PSPMediaConverter_src
 Work-in-progress (but functional) tool to create PSP compliant AVC videos using FFMpeg from virtually `any` video input source.
 
 One of the features of this program is support for "VFR" (Variable FrameRate) videos. Most PSP video converters will force a VFR video to be CFR, often resulting in out-of-sync audio/video streams.
 
 This tool combats that by using a more advanced and strict FFMPeg approach that the PSP seems to support in all my tests. The 23min pilot episode for "Futurama" was used as a test, and the output came in at about 70mb and the visual quality was very high.
 
 Sadly, this tool doesn't seem to work on a retail PSP with Official Firmware installed. There is no way to have the video be supported like this on retail *and* CFW at the same time.
 
 I've included a bit of documentation on the actual video codec formats for the PSP itself, gathered from various sources on the internet over the years.
 
 Contrary to what most docs say, at some point Sony updated the PSP to support videos with "miXEd caSIng anD SpACes" on mp4 videos. Only the "MP_ROOT" folder has special filename requirements, and isn't needed.