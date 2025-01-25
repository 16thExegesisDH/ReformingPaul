import sys
import xml.etree.ElementTree as ET
from utils.file_management import read_input_file, write_output_file
from utils.parsing import parse_xml
from utils.ordre_and_categorize import (
    reorder_elements_around_pb,
    sort_pb_elements_by_corresp,
    remove_duplicate_pb_elements
)
from utils.clean_xml import clean_xml
from utils.title_form import normalize_titles_Aretius

def reorder_elements_and_pb(input_file, output_file):
    """Main function to reorder elements and sort <pb> tags."""
    declaration, xml_content = read_input_file(input_file)
    root = parse_xml(xml_content)
    
     # Normalize titles using the function from script.py
    normalize_titles_Aretius(root)

    body = root.find(".//body")
    reorder_elements_around_pb(body)
    sort_pb_elements_by_corresp(root)
    remove_duplicate_pb_elements(body)

    xml_string = ET.tostring(root, encoding="unicode")
    cleaned_xml = clean_xml(xml_string)
    write_output_file(output_file, declaration, cleaned_xml)

    print(f"Reordered and sorted XML has been saved to {output_file}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python main.py <input_file.xml> <output_file.xml>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]

    reorder_elements_and_pb(input_file, output_file)
