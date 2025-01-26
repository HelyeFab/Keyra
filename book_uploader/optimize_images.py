from PIL import Image
import os
import sys

def optimize_image(image_path, max_size_kb=500):
    # Open the image
    img = Image.open(image_path)
    
    # Convert to RGB if necessary
    if img.mode in ('RGBA', 'P'):
        img = img.convert('RGB')
    
    # Initial quality
    quality = 95
    
    # Save with optimization
    while quality > 10:
        # Create a temporary file path
        temp_path = image_path + '.temp'
        
        # Save with current quality
        img.save(temp_path, 'JPEG', quality=quality, optimize=True)
        
        # Check file size
        size_kb = os.path.getsize(temp_path) / 1024
        
        if size_kb <= max_size_kb:
            # If size is good, replace original with optimized version
            os.replace(temp_path, image_path)
            print(f"Optimized {os.path.basename(image_path)} to {size_kb:.1f}KB (quality={quality})")
            break
        
        # Remove temporary file
        os.remove(temp_path)
        
        # Reduce quality for next iteration
        quality -= 5
    
    img.close()

def main():
    if len(sys.argv) < 2:
        print("Usage: python optimize_images.py <books_dir>")
        return
        
    books_dir = sys.argv[1]
    
    # Process each book directory
    for book_dir in os.listdir(books_dir):
        book_path = os.path.join(books_dir, book_dir)
        if not os.path.isdir(book_path):
            continue
            
        print(f"Processing {book_dir}...")
        
        # Process each PNG file in the book directory
        for file in os.listdir(book_path):
            if file.endswith('.png'):
                image_path = os.path.join(book_path, file)
                optimize_image(image_path)

if __name__ == "__main__":
    main()
