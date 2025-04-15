import re
import sys
import os

def transform_text(text):
    """Convert sequences of at least 2 uppercase letters to lowercase."""
    return re.sub(r'[A-Z]{2,}', lambda match: match.group(0).lower(), text)

def process_file(input_file):
    """Read a file, transform its content, and save the result."""
    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        transformed_content = transform_text(content)
        
        # Generate output filename
        base_name, ext = os.path.splitext(input_file)
        output_file = f"{base_name}_minuscule{ext}"
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(transformed_content)
        
        print(f"Processed file saved as {output_file}")
    except FileNotFoundError:
        print(f"Error: File '{input_file}' not found.")
    except Exception as e:
        print(f"Error processing file: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script.py <input_file>")
        sys.exit(1)
    
    input_file = sys.argv[1]
    
    # Ensure the input file exists before proceeding
    if not os.path.exists(input_file):
        print(f"Error: The input file '{input_file}' does not exist.")
        sys.exit(1)
    
    process_file(input_file)
