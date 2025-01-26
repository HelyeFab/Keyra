#!/usr/bin/env python3
import json
import xml.etree.ElementTree as ET
import argparse
import gzip
from pathlib import Path
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def parse_entry(entry):
    """Parse a single JMdict entry into our simplified format."""
    # Register XML namespace
    ns = {'xml': 'http://www.w3.org/XML/1998/namespace'}
    
    # Get kanji elements (if any)
    k_eles = entry.findall('.//k_ele')
    kanji = k_eles[0].find('keb').text if k_eles else None
    
    # Get reading elements (required)
    r_eles = entry.findall('.//r_ele')
    if not r_eles:
        return None
    reading = r_eles[0].find('reb').text
    
    # Get sense elements (meanings, parts of speech, and examples)
    meanings_by_lang = {
        'eng': [],
        'deu': [],
        'spa': [],
        'fra': []
    }
    parts_of_speech = set()
    examples = []
    
    for sense in entry.findall('.//sense'):
        # Get examples
        for example in sense.findall('.//example'):
            ex_text = example.find('.//ex_text')
            ex_sent = example.find('.//ex_sent')
            if ex_text is not None and ex_sent is not None:
                examples.append({
                    'japanese': ex_text.text,
                    'english': ex_sent.text
                })
        # Get parts of speech
        pos_elements = sense.findall('.//pos')
        for pos in pos_elements:
            if pos.text:
                parts_of_speech.add(pos.text)
        
        # Get glosses (meanings) for supported languages
        glosses = sense.findall('.//gloss')
        for gloss in glosses:
            lang = gloss.get('{http://www.w3.org/XML/1998/namespace}lang')
            # If no language specified, treat as English
            if lang is None:
                lang = 'eng'
            if lang in meanings_by_lang and gloss.text:
                meanings_by_lang[lang].append(gloss.text)
    
    # Only include entries that have at least one meaning
    if not any(meanings_by_lang.values()):
        return None
        
    return {
        'kanji': kanji,
        'reading': reading,
        'meanings': meanings_by_lang['eng'],  # Just use English meanings directly
        'parts_of_speech': list(parts_of_speech),
        'examples': examples if examples else None  # Set to None if empty
    }

def convert_jmdict(input_file, output_file):
    """Convert JMdict XML to our simplified JSON format."""
    logger.info(f"Reading input file: {input_file}")
    
    # Handle both gzipped and regular XML files
    if input_file.endswith('.gz'):
        with gzip.open(input_file, 'rb') as f:
            tree = ET.parse(f)
    else:
        tree = ET.parse(input_file)
    
    root = tree.getroot()
    dictionary = []
    total_entries = len(root.findall('.//entry'))
    
    logger.info(f"Processing {total_entries} entries...")
    
    for i, entry in enumerate(root.findall('.//entry')):
        if i % 1000 == 0:
            logger.info(f"Processed {i}/{total_entries} entries...")
            
        parsed_entry = parse_entry(entry)
        if parsed_entry:
            dictionary.append(parsed_entry)
    
    logger.info(f"Writing {len(dictionary)} entries to {output_file}")
    
    # Create output directory if it doesn't exist
    output_path = Path(output_file)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    
    with open(output_file, 'w', encoding='utf-8') as f:
        # Write array opening bracket
        f.write('[\n')
        
        # Write each entry with proper formatting
        for i, entry in enumerate(dictionary):
            entry_json = json.dumps(entry, ensure_ascii=False, indent=2)
            # Add comma for all entries except the last one
            if i < len(dictionary) - 1:
                f.write(f'  {entry_json},\n')
            else:
                f.write(f'  {entry_json}\n')
        
        # Write array closing bracket
        f.write(']\n')
    
    logger.info("Conversion complete!")

def main():
    parser = argparse.ArgumentParser(description='Convert JMdict XML to JSON format')
    parser.add_argument('input_file', help='Input JMdict XML file (can be gzipped)')
    parser.add_argument('output_file', help='Output JSON file path')
    
    args = parser.parse_args()
    convert_jmdict(args.input_file, args.output_file)

if __name__ == '__main__':
    main()
