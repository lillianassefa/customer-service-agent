# Customer Service Agent API

Welcome to the Customer Service Agent API! This application helps customers get information about your company's products and services by answering their questions intelligently. It uses advanced technology to understand and respond to inquiries based on your company’s documents and inventory.

## Getting Started

### Prerequisites
Before you begin, make sure you have the following:
- **Python 3.7 or higher** installed on your computer.
- **Git** installed for cloning the repository (optional).
- A **Google Generative AI API Key** to enable the AI features.

### Installation
1. **Clone the Repository**
   If you have Git installed, you can clone the project repository by running:
   ```bash
   git clone https://github.com/yourusername/customer-service-agent.git
   cd customer-service-agent
If you don't have Git, you can download the project as a ZIP file from GitHub and extract it.

Create a Virtual Environment It’s a good idea to create a virtual environment to keep your project dependencies organized.

bash
Copy code
python3 -m venv venv
source venv/bin/activate  # On Windows, use: venv\Scripts\activate
Install Dependencies Install the required Python packages using the provided requirements.txt file.

bash
Copy code
pip install -r requirements.txt
Configuration
Set Up Environment Variables Create a .env file in the root directory of the project and add the following lines, replacing the placeholders with your actual information:
env
Copy code
GOOGLE_API_KEY=your-google-api-key
DATA_PATH=/path/to/your/data
CHROMA_DB_PATH=/path/to/chroma_db
EMBEDDING_MODEL=models/embedding-001
LLM_MODEL=gemini-1.0-pro-latest
CHROMA_COLLECTION_NAME=company_documents_test_2
This file will store important settings like your API key and paths to your data.
Running the Application
Start the FastAPI server by running the following command in your terminal:

bash
Copy code
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
app.main:app tells Uvicorn where to find the FastAPI application.
--reload allows the server to automatically restart when you make changes to the code.
Once the server is running, open your web browser and go to http://localhost:8000/docs. Here, you’ll see an interactive interface where you can test the API by asking questions and receiving answers.

Testing the /ask Endpoint
To test the main feature of the application:

Open Swagger UI: Navigate to http://localhost:8000/docs in your browser.

Find the /ask Endpoint: Look for the POST /ask endpoint in the list of available APIs.

Try It Out: Click on the /ask endpoint to expand it, then click the "Try it out" button.

Enter a Question: In the provided field, type a question like:

json
Copy code
{
  "question": "Do you have Intel Xeon E5-2670 V3, what is its description and who is the employee assigned?"
}
Execute the Request: Click the "Execute" button. The API will process your question and return an answer based on your company’s documents and inventory.

Example Response
After submitting your question, you might receive a response like:

json
Copy code
{
  "answer": "Yes, we have the Intel Xeon E5-2670 V3. Description: High-performance server processor. The assigned employee is John Doe (john.doe@example.com)."
}

If you’d like to contribute to this project, feel free to fork the repository, make your changes, and submit a pull request. Contributions are welcome!

License
This project is licensed under the MIT License. You are free to use, modify, and distribute this software as long as you include the original license.

Thank you for using the Customer Service Agent API! If you have any questions or need further assistance, feel free to reach out.