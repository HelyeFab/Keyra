#!/usr/bin/env python3
import json
import xml.etree.ElementTree as ET
import argparse
import gzip
from pathlib import Path
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def parse_kanji(character):
    """Parse a single kanji character entry into our simplified format."""
    result = {
        'literal': character.find('literal').text,
        'meanings': [],
        'readings': {
            'on': [],
            'kun': []
        },
        'grade': None,
        'jlpt': None,
        'stroke_count': None,
    }
    
    # Get meanings (English only)
    for rm_element in character.findall('.//reading_meaning/rmgroup/meaning'):
        # Only get English meanings (no language attribute means English)
        if 'm_lang' not in rm_element.attrib:
            result['meanings'].append(rm_element.text)
    
    # Get readings
    for reading in character.findall('.//reading_meaning/rmgroup/reading'):
        r_type = reading.get('r_type')
        if r_type == 'ja_on':
            result['readings']['on'].append(reading.text)
        elif r_type == 'ja_kun':
            result['readings']['kun'].append(reading.text)
    
    # Get misc info
    misc = character.find('misc')
    if misc is not None:
        grade = misc.find('grade')
        if grade is not None:
            result['grade'] = int(grade.text)
            
        jlpt = misc.find('jlpt')
        if jlpt is not None:
            result['jlpt'] = int(jlpt.text)
            
        stroke_count = misc.find('stroke_count')
        if stroke_count is not None:
            result['stroke_count'] = int(stroke_count.text)
    
    return result

def convert_kanjidic(input_file, output_file):
    """Convert KANJIDIC XML to our simplified JSON format."""
    logger.info(f"Reading input file: {input_file}")
    
    # Handle gzipped XML file
    with gzip.open(input_file, 'rb') as f:
        tree = ET.parse(f)
    
    root = tree.getroot()
    dictionary = {}
    total_characters = len(root.findall('.//character'))
    
    logger.info(f"Processing {total_characters} characters...")
    
    for i, character in enumerate(root.findall('.//character')):
        if i % 100 == 0:
            logger.info(f"Processed {i}/{total_characters} characters...")
            
        parsed_character = parse_kanji(character)
        dictionary[parsed_character['literal']] = parsed_character
    
    logger.info(f"Writing {len(dictionary)} characters to {output_file}")
    
    # Create output directory if it doesn't exist
    output_path = Path(output_file)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(dictionary, f, ensure_ascii=False, indent=2)
    
    logger.info("Conversion complete!")

def main():
    parser = argparse.ArgumentParser(description='Convert KANJIDIC XML to JSON format')
    parser.add_argument('input_file', help='Input KANJIDIC XML file (can be gzipped)')
    parser.add_argument('output_file', help='Output JSON file path')
    
    args = parser.parse_args()
    convert_kanjidic(args.input_file, args.output_file)

if __name__ == '__main__':
    main()
