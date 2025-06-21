import pandas as pd
import json
import os

# --- Configuration ---
# This script assumes it is in the root of your Flutter project.
EXCEL_FILE_PATH = os.path.join('lib', 'zhuyin_transform', 'dict_revised_2015_20250327.xlsx')
JSON_OUTPUT_PATH = os.path.join('lib', 'zhuyin_transform', 'zhuyin_dict.json')
CHARACTER_COLUMN_INDEX = 0  # Column A
ZHUYIN_COLUMN_INDEX = 8   # Column I


def convert_excel_to_json():
    """Reads the specified columns from an Excel file and converts them to a JSON dictionary."""
    
    print(f"Reading from: {EXCEL_FILE_PATH}")

    # Check if the source file exists
    if not os.path.exists(EXCEL_FILE_PATH):
        print(f"\nERROR: The source file was not found at the specified path.")
        print("Please make sure the file exists and the path is correct.")
        return

    try:
        # Read the specific columns from the Excel file
        df = pd.read_excel(
            EXCEL_FILE_PATH,
            usecols=[CHARACTER_COLUMN_INDEX, ZHUYIN_COLUMN_INDEX],
            header=None,
            engine='openpyxl'
        )
        df.columns = ['character', 'zhuyin']

        # Clean the data: remove rows with empty values and trim whitespace
        df.dropna(inplace=True)
        df['character'] = df['character'].astype(str).str.strip()
        df['zhuyin'] = df['zhuyin'].astype(str).str.strip()
        df = df[df['character'] != '']
        
        # Convert the DataFrame to a dictionary
        zhuyin_dict = df.set_index('character')['zhuyin'].to_dict()

        # Write the dictionary to a JSON file
        with open(JSON_OUTPUT_PATH, 'w', encoding='utf-8') as f:
            json.dump(zhuyin_dict, f, ensure_ascii=False, indent=2)

        print(f"\nSUCCESS: Converted {len(zhuyin_dict)} entries.")
        print(f"JSON dictionary saved to: {JSON_OUTPUT_PATH}")

    except Exception as e:
        print(f"\nAn error occurred during conversion: {e}")


if __name__ == "__main__":
    convert_excel_to_json()
