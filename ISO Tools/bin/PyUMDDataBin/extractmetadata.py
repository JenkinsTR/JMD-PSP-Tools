import struct
import xml.etree.ElementTree as ET
import sys
import os
import zlib

# The path to the input folder
input_path = "."

# The path to the UMD_DATA.BIN file
umd_data_bin_path = os.path.join(input_path, "UMD_DATA.BIN")

# The path to the PARAM.SFO file
param_sfo_path = os.path.join(input_path, "PSP_GAME", "PARAM.SFO")

# The path to the output XML file
output_path = "UMD_DATA.XML"

# Check if an input path and output file path were provided as command line arguments
if len(sys.argv) > 1:
    input_path = sys.argv[1]
    umd_data_bin_path = os.path.join(input_path, "UMD_DATA.BIN")
    param_sfo_path = os.path.join(input_path, "PSP_GAME", "PARAM.SFO")

if len(sys.argv) > 2:
    output_path = sys.argv[2]

# Read the UMD_DATA.BIN file into a bytes object
with open(umd_data_bin_path, "rb") as f:
    umd_data_bin_bytes = f.read()

# Extract the metadata from the UMD_DATA.BIN file
title = umd_data_bin_bytes[0x80:0xC0].decode("ascii").rstrip("\0")
publisher = umd_data_bin_bytes[0xC0:0x100].decode("ascii").rstrip("\0")
region = umd_data_bin_bytes[0x100:0x120].decode("ascii").rstrip("\0")

# Create an ElementTree object to store the metadata
xml_doc = ET.Element("UMDDataBin")

# Create elements for the title, publisher, and region and add them to the root element
title_element = ET.SubElement(xml_doc, "Title")
title_element.text = title

publisher_element = ET.SubElement(xml_doc, "Publisher")
publisher_element.text = publisher

region_element = ET.SubElement(xml_doc, "Region")
region_element.text = region

# Read the PARAM.SFO file into a bytes object
with open(param_sfo_path, "rb") as f:
    param_sfo_bytes = f.read()

# Parse the PARAM.SFO file and extract the metadata
try:
    # Check if the PARAM.SFO file is compressed
    if param_sfo_bytes[0:4] == b'\x00\x50\x53\x46':
        # Decompress the PARAM.SFO file
        decompressed_size = struct.unpack("<I", param_sfo_bytes[8:12])[0]
        param_sfo_bytes = zlib.decompress(param_sfo_bytes[12:])

    # Parse the PARAM.SFO header
    param_sfo_header = struct.unpack("<4s8xIIIII", param_sfo_bytes[:28])
    param_sfo_entries_offset = param_sfo_header[3]
    param_sfo_entries_count = param_sfo_header[4]
    param_sfo_values_offset = param_sfo_header[5]
    
    for i in range(param_sfo_entries_count):
        # Read the entry
        entry_format = "<2s2s2s2sI"
        entry_size = struct.calcsize(entry_format)
        entry_start = param_sfo_entries_offset + i * entry_size
        entry = struct.unpack(entry_format, param_sfo_bytes[entry_start:entry_start + entry_size])
    
        # Extract the metadata from the entry
        key_offset = entry[0]
        data_type = entry[1]
        data_length = entry[2]
        data_max_length = entry[3]
        data_offset = entry[4]
    
        # Read the data
        data_start = param_sfo_values_offset + data_offset
        data = param_sfo_bytes[data_start:data_start + data_length]
    
        # Decode the data as a string
        sfo_data = data.decode("utf-8").rstrip("\0")
    
        # Extract the key as a string
        key_start = key_offset
        key_end = key_offset + 4
        key = param_sfo_bytes[key_start:key_end].decode("utf-8").rstrip("\0")
    
        # Add the metadata to the ElementTree object
        sfo_element = ET.SubElement(xml_doc, key)
        sfo_element.text = sfo_data

# Save the ElementTree object as an XML file
tree = ET.ElementTree(xml_doc)
tree.write(output_path)
