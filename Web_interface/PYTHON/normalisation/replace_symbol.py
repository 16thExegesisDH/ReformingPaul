""" 
    This function handles exceptions and symbol replacements that need 
    to be processed before any other transformations, ensuring proper 
    text normalization.
    
"""

import re

def replace_symbol(text):

    replacements = {
        r'¬': '-',        # Replace the symbol '¬' with a dash '-'
        r'\$': ' ',       #  # Replace the dollar sign '$' with a whitespace
    }

    for pattern, replacement in replacements.items():
        text = re.sub(pattern, replacement, text)
    
    return text