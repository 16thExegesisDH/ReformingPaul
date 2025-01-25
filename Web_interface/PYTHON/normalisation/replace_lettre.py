"""
This function replaces characters or combinations of characters 
(e.g., accented letters, ligatures, or deprecated forms) with their 
modern equivalents or simplified forms.

"""

import re

def replace_lettre(text):

    replacements = {
        r'ſ': 's',      # Replace the old 'long s' with the modern 's'
        r'œ': 'oe',     # Replace the ligature 'œ' with 'oe'
        r'æ': 'ae',     # Replace the ligature 'æ' with 'ae'
        r'ę': 'ae',     # Replace 'ę' with 'ae'
        r'ā': 'a',      # Replace 'ā' with 'a'
        r'à': 'a',      # Replace 'à' with 'a'
        r'á': 'a',      # Replace accented 'á' with 'a'
        r'á': 'a',      # Replace combined diacritical 'á' with 'a'
        r'è': 'e',      # Replace 'è' with 'e'
        r'è': 'e',      # Replace accented 'è' with 'e'
        r'é': 'e',      # Replace accented 'é' with 'e'
        r'é': 'e',      # Replace combined diacritical 'é' with 'e'
        r'ī': 'i',      # Replace 'ī' with 'i'
        r'í': 'i',      # Replace accented 'í' with 'i'
        r'î': 'i',     # Replace combined diacritical 'î' with 'i'
        r'ĩ': 'i',     # Replace combined diacritical 'ĩ' with 'i'
        r'ij': 'ii',    # Replace 'ij' with 'ii'
        r'ō': 'o',      # Replace 'ō' with 'o'
        r'ò': 'o',     # Replace 'ò' with 'o'
        r'ò': 'o',      # Replace accented 'ò' with 'o'
        r'ó': 'o',     # Replace combined diacritical 'ó' with 'o'
        r'ū': 'u',      # Replace 'ū' with 'u'
        r'ú': 'u',     # Replace accented 'ú' with 'u'
        r'ù': 'u',     # Replace 'ù' with 'u'
        r'ꝑ': 'per',    # Replace the abbreviation 'ꝑ' with 'per'
        r'ꝙ': 'qu',     # Replace the abbreviation 'ꝙ' with 'qu'
        r'q;': 'que',   # Replace 'q;' with 'que'
    }

    # Apply each pattern-replacement pair to the text
    for pattern, replacement in replacements.items():
        text = re.sub(pattern, replacement, text)

    return text
