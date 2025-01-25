import re

def clean_xml(xml_string):
    """Clean XML content by removing unnecessary whitespaces."""
    return re.sub(r'\s+/>', '/>', xml_string)
