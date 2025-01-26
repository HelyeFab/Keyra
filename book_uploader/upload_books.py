import os
import json
import logging
import firebase_admin
from firebase_admin import credentials, storage, firestore
from tqdm import tqdm
import time
from google.cloud import storage as google_storage
from google.api_core import retry, exceptions
from google.cloud.firestore_v1.base_query import BaseQuery

# Set up logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('book_upload.log'),
        logging.StreamHandler()
    ]
)

def upload_file_with_retry(bucket, source_file, destination_blob, max_retries=3):
    """Upload a file to Firebase Storage with retry logic."""
    retry_count = 0
    while retry_count < max_retries:
        try:
            blob = bucket.blob(destination_blob)
            blob.upload_from_filename(source_file, timeout=300)  # 5 minute timeout
            blob.make_public()  # Make the file publicly accessible
            return blob.public_url  # Return the public URL
        except Exception as e:
            retry_count += 1
            if retry_count == max_retries:
                logging.error(f"Failed to upload {source_file} after {max_retries} attempts: {str(e)}")
                return None
            logging.warning(f"Attempt {retry_count} failed, retrying in 5 seconds...")
            time.sleep(5)

@retry.Retry(
    initial=1.0,  # Initial delay in seconds
    maximum=60.0,  # Maximum delay in seconds
    multiplier=2.0,  # Delay multiplier
    predicate=retry.if_exception_type(exceptions.DeadlineExceeded),
    deadline=300.0  # Overall deadline in seconds
)
def write_to_firestore_with_retry(db, collection, document_id, data):
    """Write to Firestore with retry logic for timeouts."""
    doc_ref = db.collection(collection).document(document_id)
    doc_ref.set(data)

class BookUploader:
    def __init__(self, cred_path):
        try:
            cred = credentials.Certificate(cred_path)
            # Initialize with admin privileges
            firebase_admin.initialize_app(cred, {
                'storageBucket': 'keyra-93667.firebasestorage.app',
                'databaseAuthVariableOverride': {
                    'admin': True
                }
            })
            logging.info("Firebase initialized successfully with admin privileges")
            
            self.db = firestore.client()
            self.bucket = storage.bucket()
            
        except Exception as e:
            logging.error(f"Failed to initialize Firebase: {str(e)}")
            raise

    def validate_metadata(self, metadata):
        """Validate the required fields in metadata according to Firestore rules."""
        # Check required fields
        if not all(key in metadata for key in ['title', 'pages', 'defaultLanguage']):
            raise ValueError("Missing required fields. Must have: title, pages, defaultLanguage")
        
        # Validate types according to Firestore rules
        if not isinstance(metadata['title'], dict):
            raise ValueError("'title' must be a map of language codes to translations")
            
        if not isinstance(metadata['pages'], list):
            raise ValueError("'pages' must be a list")
            
        if not isinstance(metadata['defaultLanguage'], str):
            raise ValueError("'defaultLanguage' must be a string")
            
        # Validate pages structure
        for i, page in enumerate(metadata['pages']):
            if not isinstance(page.get('text', {}), dict):
                raise ValueError(f"Page {i+1}: 'text' must be a map of language codes to translations")
            
            # Ensure audioPath is a map of string language codes to string URLs
            if 'audioPath' in page:
                if not isinstance(page['audioPath'], dict):
                    raise ValueError(f"Page {i+1}: 'audioPath' must be a map of language codes to URLs")
                # Convert any non-string keys to strings
                page['audioPath'] = {str(k): str(v) for k, v in page['audioPath'].items()}
            else:
                page['audioPath'] = {}  # Initialize empty if not present
            
            # Ensure imagePath is a string
            if 'imagePath' in page:
                if not isinstance(page['imagePath'], str):
                    raise ValueError(f"Page {i+1}: 'imagePath' must be a string URL")
            
            # Ensure text values are strings
            page['text'] = {str(k): str(v) for k, v in page['text'].items()}

    def upload_book(self, book_dir):
        try:
            # Get book ID from directory name
            book_id = os.path.basename(book_dir)
            
            # Read metadata
            metadata_path = os.path.join(book_dir, 'metadata.json')
            if not os.path.exists(metadata_path):
                raise FileNotFoundError(f"Metadata file not found in {book_dir}")
                
            with open(metadata_path, 'r', encoding='utf-8') as f:
                metadata = json.load(f)
            
            self.validate_metadata(metadata)
            
            # Upload images with retry logic
            images = []
            image_urls = {}
            for file in os.listdir(book_dir):
                if file.endswith('.png'):
                    source_path = os.path.join(book_dir, file)
                    destination_path = f"books/{book_id}/{file}"
                    
                    logging.info(f"Uploading {file} to {destination_path}...")
                    public_url = upload_file_with_retry(self.bucket, source_path, destination_path)
                    if not public_url:
                        raise Exception(f"Failed to upload {file}")
                    
                    images.append(destination_path)
                    image_urls[destination_path] = public_url
                    
                    # Set cover image URL if this is the cover image
                    if file == 'cover.png':
                        metadata['coverImage'] = public_url
            
            # Upload metadata to Firestore with retry
            logging.info(f"Uploading metadata for {book_id} to Firestore...")
            
            # Clean up metadata before saving
            metadata['images'] = images
            metadata['imageUrls'] = image_urls  # Store all image URLs
            metadata['createdAt'] = firestore.SERVER_TIMESTAMP
            metadata['updatedAt'] = firestore.SERVER_TIMESTAMP
            
            # Ensure title values are strings
            metadata['title'] = {str(k): str(v) for k, v in metadata['title'].items()}
            
            # Ensure defaultLanguage is a string
            metadata['defaultLanguage'] = str(metadata['defaultLanguage'])
            
            # Handle description field - use English description if it's a map
            if isinstance(metadata.get('description'), dict):
                metadata['description'] = metadata['description'].get('en', '')
            
            # Remove any fields that shouldn't be in Firestore
            fields_to_remove = ['currentLanguage', 'currentPage', 'isAudioPlaying', 
                              'isFavorite', 'lastReadAt', 'readingProgress']
            for field in fields_to_remove:
                metadata.pop(field, None)
            
            # Initialize audioPath with a dummy link for each page and language
            supported_languages = ['en', 'es', 'fr', 'de', 'it', 'ja']
            for page in metadata['pages']:
                if 'audioPath' not in page or not page['audioPath']:
                    page['audioPath'] = {lang: 'dummy.mp3' for lang in supported_languages}
            
            # Write to Firestore with retry logic
            write_to_firestore_with_retry(self.db, 'books', book_id, metadata)
            
            logging.info(f"Successfully processed book {book_id}")
            return True
            
        except Exception as e:
            logging.error(f"Failed to process book in {book_dir}: {str(e)}")
            return False

def main():
    if len(sys.argv) != 3:
        print("Usage: python upload_books.py <service_account_key> <books_dir>")
        return

    cred_path = sys.argv[1]
    books_dir = sys.argv[2]

    uploader = BookUploader(cred_path)
    
    # Process each book directory
    successes = 0
    failures = 0
    
    book_dirs = [d for d in os.listdir(books_dir) 
                if os.path.isdir(os.path.join(books_dir, d))]
                
    for book_dir in tqdm(book_dirs, desc="Processing books"):
        full_path = os.path.join(books_dir, book_dir)
        if uploader.upload_book(full_path):
            successes += 1
        else:
            failures += 1
    
    logging.info(f"Upload complete. Successes: {successes}, Failures: {failures}")

if __name__ == "__main__":
    import sys
    main()
