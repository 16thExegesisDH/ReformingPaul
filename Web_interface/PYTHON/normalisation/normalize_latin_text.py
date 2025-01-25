"""
Normalize Latin text using a sequence of transformation functions.
-To extend the pipeline, add new transformation functions to the pipeline list.

"""

import replace_symbol
import replace_tilde
import replace_lettre

def normalize_latin_text(text):
  
    # Define the pipeline: an ordered list of transformation functions
    normalization_pipeline = [
        replace_symbol.replace_symbol,  # Handle symbol replacements
        replace_tilde.replace_tilde,    # Process tilde-related transformations
        replace_lettre.replace_lettre,  # Normalize specific letters
    ]

    for func in normalization_pipeline:
        text = func(text)
    
    return text
