import os
from dotenv import load_dotenv

load_dotenv()

GOOGLE_API_KEY = os.getenv("GOOGLE_API_KEY")


DATA_PATH = '/home/lillian/customer-service-agent/data'
CHROMA_DB_PATH = '/home/lillian/customer-service-agent/chroma_db'


EMBEDDING_MODEL = "models/embedding-001"
LLM_MODEL = "gemini-1.0-pro-latest"

CHROMA_COLLECTION_NAME = "company_documents_test_2"
