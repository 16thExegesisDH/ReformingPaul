#!/bin/bash

# Check if a file is provided as an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: File '$input_file' not found."
    exit 1
fi

# Output file
output_file="${input_file%.tex}.update.tex"

# Replace occurrences of word splits (e.g., "wo- man" to "woman")
# Also handle line breaks within LaTeX commands like \textit{} where the hyphen should be removed
sed -E '
    # Remove hyphen and space at end of words
    s/([A-Za-z])- +/\1/g;

    # Specifically remove hyphen at the end of LaTeX commands like \textit{}
    s/(\\[a-zA-Z]+\{[^}]+)-/\1/g
' "$input_file" > "$output_file"

echo "Processing complete. Output written to $output_file"

# Run lualatex on the output file (install lualatex first). use lualatex for handling greek caracters
# Manually insert 'R' to run, if prompted.
lualatex "$output_file"

echo "lualatex processing complete."
