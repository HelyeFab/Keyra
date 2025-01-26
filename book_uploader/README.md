# Book Uploader for Keyra

This script automates the process of uploading books (including images, metadata, and translations) to Firebase for use in the Keyra app.

## Setup

1. Install the required dependencies:
```bash
pip install -r requirements.txt
```

2. Ensure you have the Firebase service account key file (serviceAccountKey.json).

## Directory Structure

Your books should be organized in the following structure:
```
local_books/
    book-0001/
        cover.png
        page_1.png
        page_2.png
        metadata.json
    book-0002/
        ...
```

### Metadata Format

Each book's `metadata.json` must follow this structure according to Firestore rules:
```json
{
    "title": {
        "en": "English Title",
        "de": "German Title"
    },
    "defaultLanguage": "en",
    "pages": [
        {
            "text": {
                "en": "Page 1 text",
                "de": "Seite 1 Text"
            }
        }
    ]
}
```

Optional fields:
```json
{
    "author": "Author Name",
    "description": "Book description",
    "categories": ["Category1", "Category2"]
}
```

**Note**: The `title` must be a map of language codes to translations, and each page's `text` must also be a map of translations.

## Usage

Run the script with:
```bash
python upload_books.py /path/to/serviceAccountKey.json /path/to/local_books
```

The script will:
1. Process each book in the directory
2. Upload images to Firebase Storage
3. Store metadata in Firestore
4. Log progress and any errors to `book_upload.log`

## Features

- Batch processing of multiple books
- Automatic image uploading to Firebase Storage
- Metadata validation
- Error handling and logging
- Progress tracking with tqdm
- Support for multilingual content

## Logging

The script logs all operations to both console and `book_upload.log`. Check the log file for detailed information about uploads and any errors that occur.

# Book Uploader for Keyra

cd book_uploader && source .venv/bin/activate && python upload_books.py serviceAccountKey.json local_books