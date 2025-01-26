
ChatGPT said:
ChatGPT
Instructions for an AI Coding Agent to Develop a Script for Uploading Books to Firebase
Goal:
Create a Python script that automates the process of uploading book data (including images, metadata, and translations) from a local directory to Firebase Firestore and Firebase Storage. The script should handle batch uploads efficiently, ensure error handling, and log the results.

Functional Requirements
Local Directory Structure:

The script must process a structured local directory containing books:
bash
Copy code
/local_books/
    /book-001/
        cover.png
        page_1.png
        page_2.png
        metadata.json
    /book-002/
        cover.png
        page_1.png
        page_2.png
        metadata.json
Each book folder contains:
Images: Book cover and page images.
metadata.json: Metadata including text, translations, and page references.
Firebase Integration:

Use the Firebase Admin SDK to authenticate with Firebase and interact with Firestore and Storage.
Upload images to Firebase Storage and store their public URLs in Firestore.
Store metadata (title, author, description, categories, and pages) in Firestore under a books collection.
Batch Processing:

Process all books in the directory sequentially.
Ensure each book is uploaded completely (images and metadata) before moving to the next.
Error Handling and Logging:

Log upload successes and failures to a file for debugging.
Retry failed uploads where possible.
Automation:

The script should be runnable via the command line and process new books in the directory automatically.
Validation:

Validate the presence and completeness of metadata.json before uploading.
Ensure all required fields are present in metadata.json (e.g., author, title, description, pages).
Technical Requirements
Environment Setup:

The script should initialize Firebase using a Service Account Key.
Include a virtual environment for dependencies like:
firebase-admin for Firebase SDK.
requests (optional) for auxiliary tasks like fetching data or debugging.
Upload Workflow:

Images: Upload each image (cover and pages) to Firebase Storage.
Organize images under a unique book ID, e.g., books/book-001/cover.png.
Store the resulting public URLs in the corresponding metadata.json structure.
Metadata: After processing images, upload the updated metadata (including image URLs) to Firestore under the books collection.
Book Metadata Structure:

Each book metadata document in Firestore should follow this structure:
json
Copy code
{
    "author": "Author Name",
    "title": {
        "en": "English Title",
        "de": "German Title"
    },
    "description": "Book description",
    "categories": ["Category1", "Category2"],
    "defaultLanguage": "en",
    "createdAt": "Timestamp",
    "pages": [
        {
            "text": {
                "en": "Page 1 text",
                "de": "Seite 1 Text"
            },
            "imagePath": "https://firebase-storage-url/page_1.png"
        }
    ]
}
Implementation Steps
Initialize Firebase:

Use the Firebase Admin SDK to connect to Firestore and Storage.
Authenticate with a Service Account Key.
Process Local Files:

Iterate through the /local_books/ directory.
For each folder:
Parse metadata.json.
Validate required fields (e.g., author, title, pages).
Upload Images:

Upload cover.png and page_x.png files to Firebase Storage.
Replace local file paths in metadata.json with public URLs from Firebase Storage.
Upload Metadata:

Upload the updated metadata.json to Firestore under the books collection.
Error Handling:

If an error occurs during image upload or metadata upload:
Log the error to a file with details (e.g., book ID, error type).
Skip to the next book and retry failed uploads later.
Logging:

Maintain a log file to record:
Successfully uploaded books.
Errors and their reasons.
Non-Functional Requirements
Scalability:

The script should handle hundreds of books efficiently without crashing or timing out.
Optimize storage uploads with retries and batch processing if needed.
Maintainability:

Write clean, modular code with reusable functions (e.g., for uploading images, parsing metadata).
Use comments and documentation for clarity.
Extensibility:

Allow easy addition of new metadata fields or changes to the directory structure.
Make the script configurable (e.g., directory path, Firebase credentials) via a configuration file or command-line arguments.
Deliverables
Python Script:

A fully functional script that meets the above requirements.
Includes functions for:
Initializing Firebase.
Parsing and validating metadata.
Uploading images to Firebase Storage.
Uploading metadata to Firestore.
Documentation:

Instructions for setting up Firebase and the local directory structure.
Steps to run the script and troubleshoot errors.
A sample metadata.json file.
Logs:

A log file format for tracking successes and failures.
Testing Plan
Unit Testing:
Test individual functions (e.g., upload_image, upload_metadata) with mock data.
Integration Testing:
Run the script on a sample directory with 2–3 books to ensure end-to-end functionality.
Error Simulation:
Test scenarios like missing fields in metadata.json, invalid image paths, or Firebase upload failures.
Performance Testing:
Simulate uploading 100+ books to ensure scalability.
Agent Instructions
Start by setting up Firebase Admin SDK and creating a connection to Firestore and Storage.
Write reusable functions for processing books, uploading images, and updating metadata.
Include robust error handling and logging mechanisms.
Prioritize modular, maintainable code to facilitate future updates.



Instructions for the Agent
1. Reuse Firebase Credentials
The script must use the same Service Account Key JSON file that was downloaded from the Firebase Console for the existing Keyra app.
Instruct the agent to reference this file directly or copy it to the new project folder.
Example steps:

Locate the existing Service Account Key:

File path for Keyra app (e.g., keyra_project/serviceAccountKey.json).
Copy the file to the script folder or provide its path in the script:

Copy to the script folder:
bash
Copy code
cp keyra_project/serviceAccountKey.json new_project_folder/
Or directly reference its existing location in the script.
Example:

python
Copy code
cred = credentials.Certificate("/path/to/keyra_project/serviceAccountKey.json")
firebase_admin.initialize_app(cred, {
    "storageBucket": "your-app-id.appspot.com"
})
2. Reuse Existing Firestore Database Rules
The agent should not attempt to modify the Firestore rules but instead operate within the current ruleset defined for the Keyra app.
Key Steps:

Ensure the script writes to the Books collection (e.g., /books/{bookId}) and respects the rules for read and write access.
Validate that the script authenticates with Firebase Admin SDK, which bypasses client rules (Admin SDK has elevated permissions).
Example code:

python
Copy code
db = firestore.client()

# Upload book metadata
db.collection("books").document(book_id).set(book_data)
3. Use the Same Firebase Storage Bucket
The agent should configure the script to upload images and audio files to the same Firebase Storage bucket as the Keyra app.
Key Steps:

Use the storageBucket field in the initialize_app() method to reference the existing storage bucket.
python
Copy code
firebase_admin.initialize_app(cred, {
    "storageBucket": "your-app-id.appspot.com"
})
Ensure the script uploads files to the same structure used by Keyra (e.g., books/{bookId}/cover.png).
4. Maintain Directory Independence
Place the new script and the local_books folder in a separate directory (e.g., /path/to/new_project_folder/), while ensuring it interacts seamlessly with the Keyra Firebase project.
Directory structure:

bash
Copy code
/path/to/new_project_folder/
    /local_books/
        /book-001/
            cover.png
            metadata.json
        /book-002/
            cover.png
            metadata.json
    upload_books.py
    serviceAccountKey.json  # Optional if referenced directly
5. Handle Dependencies
Instruct the agent to use a virtual environment in the new folder to isolate dependencies.
Steps:

Create a virtual environment:
bash
Copy code
python3 -m venv venv
source venv/bin/activate
Install Firebase Admin SDK and any other dependencies:
bash
Copy code
pip install firebase-admin
6. Instruct the Agent on Script Behavior
The script should:

Authenticate using the Service Account Key.
Use the existing Books collection in Firestore.
Upload images/audio to the same Firebase Storage bucket.
Operate within the current directory (new_project_folder) without modifying or interfering with the Keyra app's main codebase.
Example Python script outline:

python
Copy code
import firebase_admin
from firebase_admin import credentials, firestore, storage
import os
import json

# Step 1: Initialize Firebase
cred = credentials.Certificate("/path/to/keyra_project/serviceAccountKey.json")
firebase_admin.initialize_app(cred, {
    "storageBucket": "your-app-id.appspot.com"
})

db = firestore.client()
bucket = storage.bucket()

# Step 2: Define functions for processing and uploading books
def upload_images(book_id, local_path, pages):
    uploaded_pages = []
    for page in pages:
        image_file = page["imagePath"]
        image_path = os.path.join(local_path, image_file)
        if os.path.exists(image_path):
            blob = bucket.blob(f"books/{book_id}/{image_file}")
            blob.upload_from_filename(image_path)
            page["imagePath"] = blob.public_url
        uploaded_pages.append(page)
    return uploaded_pages

def upload_metadata(book_id, book_data):
    db.collection("books").document(book_id).set(book_data)

def upload_book(book):
    book_id = book["id"]
    local_path = book["localPath"]
    book["pages"] = upload_images(book_id, local_path, book["pages"])
    book.pop("localPath", None)
    upload_metadata(book_id, book)
    print(f"Uploaded book: {book_id}")

# Step 3: Read local directory and upload books
def get_books_from_local(directory_path):
    books = []
    for book_id in os.listdir(directory_path):
        book_path = os.path.join(directory_path, book_id)
        if os.path.isdir(book_path):
            metadata_path = os.path.join(book_path, "metadata.json")
            if os.path.exists(metadata_path):
                with open(metadata_path, "r") as f:
                    metadata = json.load(f)
                metadata["localPath"] = book_path
                metadata["id"] = book_id
                books.append(metadata)
    return books

# Main
if __name__ == "__main__":
    directory_path = "/path/to/new_project_folder/local_books"
    books = get_books_from_local(directory_path)

    for book in books:
        try:
            upload_book(book)
        except Exception as e:
            print(f"Failed to upload {book['id']}: {e}")
7. Security and Access
Ensure the Service Account Key JSON file is not exposed publicly (e.g., through Git or other sharing mechanisms).
Use the Firebase Admin SDK, as it inherently bypasses Firestore rules and provides elevated permissions for writing to Firestore and Storage.
Testing Instructions
Place sample books in the local_books directory, ensuring metadata and images follow the expected structure.
Run the script:
bash
Copy code
python upload_books.py
Verify:
Firestore: Check the Books collection for newly added books.
Storage: Confirm that images are uploaded to the correct paths and URLs are stored in Firestore.
This approach ensures your new script interacts seamlessly with your Keyra app's Firebase project while maintaining directory and project independence.