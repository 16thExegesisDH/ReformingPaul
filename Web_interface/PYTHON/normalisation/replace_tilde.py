"""
Normalize tilde-based characters and sequences in the text.

This function handles specific transformations for characters like:
- 'ã' to 'an' or 'am' with various conditions.
- 'ẽ' to 'en' or 'em' with similar patterns.
- 'õ' to 'on' or 'om' depending on following characters.
- 'ũ' to 'un' or 'um', 
- special cases for 'õ' and 'ẽ'. The ocr model changed and propose now special caracter (e.g. Pre-composed 'ẽ' → U+1EBD) add in the script. 

It performs the replacement of tilde-based letters, dealing with optional 
separators (such as '¬'), and adjusting the result based on the character 
following the tilde.

"""
import re

def replace_tilde(text):

    # Replace 'ã' followed by optional '¬' and 'd'/'t' with 'an'/'an' preserving 'd'/'t'
    text = re.sub(r'ã¬?([cdt])', r'an\1', text)
    # Replace 'ã' followed by optional '¬' and any other character with 'am', preserving the character
    text = re.sub(r'ã¬?([^\S\r\n<]|.)', lambda m: 'am ' if m.group(1).isspace() else 'am' + m.group(1), text)
    # Replace 'ã' at the end of a line with 'am'
    text = re.sub(r'ã¬?$', 'am', text, flags=re.MULTILINE)
    
    # Replace 'ẽ' followed by optional '¬' and 'd'/'s'/'t' with 'en'/'em' preserving the character
    text = re.sub(r'ẽ¬?([dst])', r'en\1', text)
    # Replace 'ẽ' followed by optional '¬' and any other character with 'em', preserving the character
    text = re.sub(r'ẽ¬?([^\S\r\n<]|.)', lambda m: 'em ' if m.group(1).isspace() else 'em' + m.group(1), text)
    # Replace 'ẽ' at the end of a line with 'em'
    text = re.sub(r'ẽ¬?$', 'em', text, flags=re.MULTILINE)

    # Replace 'õ' followed by optional '¬' and 'p'/'b' with 'om'/'om' preserving the character
    text = re.sub(r'õ¬?([pb])', r'om\1', text)
    # Replace 'õ' followed by optional '¬' and any other character with 'on', preserving the character
    text = re.sub(r'õ¬?([^pb])', r'on\1', text)
    # Replace 'õ' at the end of a line with 'on'
    text = re.sub(r'õ¬?$', 'on', text, flags=re.MULTILINE)
    
    # Replace 'ũ' followed by optional '¬' and 't'/'c' with 'un'/'um' preserving the character
    text = re.sub(r'ũ¬?([ct])', r'un\1', text)
    # Replace 'ũ' followed by optional '¬' and any other character with 'um', preserving the character
    text = re.sub(r'ũ¬?([^\S\r\n<]|.)', lambda m: 'um ' if m.group(1).isspace() else 'um' + m.group(1), text)
    # Replace 'ũ' at the end of a line with 'um'
    text = re.sub(r'ũ¬?$', 'um', text, flags=re.MULTILINE)
    
    # Handle special case for 'õ' - replace with 'om' when followed by 'p'/'b'
    text = re.sub(r'õ¬?([pb])', r'om\1', text)
    # Replace 'õ' followed by optional '¬' and any other character with 'on', preserving the character
    text = re.sub(r'õ¬?([^pb])', r'on\1', text)
    # Replace 'õ' at the end of a line with 'on'
    text = re.sub(r'õ¬?$', 'on', text, flags=re.MULTILINE)
    
    # Handle special case for 'ẽ' - replace with 'en'/'em' as necessary
    text = re.sub(r'ẽ¬?([dst])', r'en\1', text)
    # Replace 'ẽ' followed by optional '¬' and any other character with 'em', preserving the character
    text = re.sub(r'ẽ¬?([^\S\r\n<]|.)', lambda m: 'em ' if m.group(1).isspace() else 'em' + m.group(1), text)
    # Replace 'ẽ' at the end of a line with 'em'
    text = re.sub(r'ẽ¬?$', 'em', text, flags=re.MULTILINE)

    return text
