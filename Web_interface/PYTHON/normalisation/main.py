"""
This script provides functionality for normalizing latin from 16th century both TXT files and XML files.
-undo abreviations, tildes and special caracters on the basis of classical latin

Features:
- TXT files: Normalize the content of text files by applying custom transformations defined in `normalize_latin_text`.
- XML files: Normalize the content of specific XML tags (e.g., `<reg>`) by removing namespaces, replacing special characters, and formatting the text.

Usage:
Run the script with the input and output file paths as command-line arguments. The script automatically detects the file type based on the input file's extension:
- `.xml`: The file is treated as an XML file, and XML-specific normalization is performed.
- Other file extensions: The file is treated as a plain TXT file, and plain text normalization is performed.

Example:
    python main.py input.xml output.xml
    python main.py input.txt output.txt
"""

import sys
import os
import xml.etree.ElementTree as ET
from normalize_latin_text import normalize_latin_text
from xml.dom import minidom

# Helper function to remove namespaces from XML elements
def remove_namespace(tree):
    """Remove namespaces from all tags in an XML tree."""
    for elem in tree.iter():
        if '}' in elem.tag:
            elem.tag = elem.tag.split('}', 1)[1]  # Remove namespace prefix

# Pretty-print XML for better readability
def prettify(elem):
    """
    Convert an XML element to a pretty-printed string.
    This removes extra newlines and spaces to ensure a clean format.
    """
    rough_string = ET.tostring(elem, 'utf-8')
    reparsed = minidom.parseString(rough_string)
    return '\n'.join([line for line in reparsed.toprettyxml(indent="  ").splitlines() if line.strip()])

# Function to normalize a TXT files
def normalize_text_file(input_file, output_file):
  
    try:
        # Read the content of the input file
        with open(input_file, 'r', encoding='utf-8') as file:
            text = file.read()

        # Apply text normalization
        normalized_text = normalize_latin_text(text)

        # Write the normalized text to the output file
        with open(output_file, 'w', encoding='utf-8') as file:
            file.write(normalized_text)

        print(f"Normalization complete. Output saved to {output_file}")

    except FileNotFoundError:
        print(f"Error: File '{input_file}' not found.")
    except Exception as e:
        print(f"An error occurred: {e}")

# Function to normalize XML files
def normalize_xml_file(input_file, output_file):
 
    try:
        # Parse the XML file
        tree = ET.parse(input_file)
        root = tree.getroot()

        # Remove namespace prefixes for consistency
        remove_namespace(root)

        # Define the tag to normalize
        target_tag = 'reg'

        # Normalize text within each target tag
        for elem in root.iter(target_tag):
            original_text = elem.text
            if original_text:
                # Normalize text and replace '&' with 'et' : handling the escape caracters
                normalized_text = normalize_latin_text(original_text.replace('&', 'et'))
                elem.text = normalized_text

        # Save the normalized XML to the output file, with pretty formatting
        with open(output_file, "w", encoding="utf-8") as f:
            f.write(prettify(root))

        print(f"XML normalization complete. Output saved to {output_file}")

    except FileNotFoundError:
        print(f"Error: File '{input_file}' not found.")
    except ET.ParseError:
        print(f"Error: Failed to parse XML file '{input_file}'.")
    except Exception as e:
        print(f"An error occurred: {e}")

# Main script entry point
if __name__ == "__main__":
    # Ensure correct usage by checking command-line arguments
    if len(sys.argv) != 3:
        print("Usage: python main.py <input_file> <output_file>")
    else:
        input_file = sys.argv[1]
        output_file = sys.argv[2]

        # Determine the file type by its extension
        file_extension = os.path.splitext(input_file)[1].lower()

        # Normalize based on file type
        if file_extension == ".xml":
            normalize_xml_file(input_file, output_file)
        else:
            normalize_text_file(input_file, output_file)

