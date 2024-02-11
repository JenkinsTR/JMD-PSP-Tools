# PyUMDDataBin

 To use the program, you can run it from the command line like this:

 `python extract_metadata.py path/to/input/folder path/to/output_file.xml`
 
 This will execute the program, which will search for the UMD_DATA.BIN and PARAM.SFO files in the path/to/input/folder directory,
 extract the metadata from these files, combine it into an XML document, and save the XML document to the file specified by path/to/output_file.xml.
 
 If no output file path is provided, the XML document will be saved to UMD_DATA.XML by default.