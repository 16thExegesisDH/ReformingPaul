import re

def read_input_file(input_file):
    """Read the input file content and return XML declaration and content."""
    with open(input_file, 'r', encoding="utf-8") as f:
        xml_content = f.read()

    declaration = ''
    if xml_content.startswith('<?xml'):
        declaration_end = xml_content.find('?>') + 2
        declaration = xml_content[:declaration_end]
        xml_content = xml_content[declaration_end:].lstrip()
    
    # Look for custom schema models or processing instructions
    # We assume that you want to preserve the custom XML model instructions in the same order
    model_instructions = ""
    while xml_content.startswith('<?xml-model'):
        model_end = xml_content.find('?>') + 2
        model_instructions += xml_content[:model_end] + "\n"  # Capture model declarations
        xml_content = xml_content[model_end:].lstrip()  # Remove model instructions

    # Append the custom model declarations before the actual XML content
    # Remove the namespace issues that the TEI may introduce during processing
    xml_content = model_instructions + xml_content

    return declaration, xml_content


def write_output_file(output_file, declaration, cleaned_xml):
    """Write the modified XML content to the output file."""
    with open(output_file, 'w', encoding="utf-8") as f:
        if declaration:
            f.write(declaration + "\n")
        f.write(cleaned_xml)
