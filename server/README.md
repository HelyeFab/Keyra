# Keyra API Server

This is the backend server for the Keyra Flutter app, responsible for managing API keys and other sensitive configurations.

## Setup

1. Create a virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Create a `.env` file with your configuration:
```
BOOKS_API_KEY=your_api_key_here
# Add other API keys as needed
```

## Running the Server

For development:
```bash
uvicorn main:app --reload
```

The server will start at `http://localhost:8000`

## API Documentation

Once the server is running, you can access:
- Interactive API docs: `http://localhost:8000/docs`
- Alternative API docs: `http://localhost:8000/redoc`

## Security Notes

- In production, implement proper authentication
- Store API keys in a secure database or secret management service
- Use HTTPS in production
- Implement rate limiting
- Add proper logging and monitoring


I've created a basic FastAPI server structure with:

requirements.txt: Contains all necessary Python dependencies
main.py: A basic FastAPI server with:
A simple endpoint to retrieve API keys
Basic security setup (needs to be enhanced for production)
Environment variable support
README.md: Documentation for setup and running the server
Next steps I recommend:

Set up proper authentication (JWT tokens or API keys)
Add more endpoints as needed for your app
Set up a proper database for storing sensitive data
Deploy to a cloud platform
For your Flutter app, you'll need to:

Create an API client service
Store the server URL in your app's configuration
Implement proper error handling for network requests
