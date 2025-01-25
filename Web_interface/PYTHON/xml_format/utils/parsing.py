import xml.etree.ElementTree as ET

def parse_xml(xml_content):
    """Parse XML content into an ElementTree object and return the root."""
    tree = ET.ElementTree(ET.fromstring(xml_content))
    return tree.getroot()