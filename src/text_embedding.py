from src.pdf_extractor import extract_text_from_pdfs
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_google_genai import GoogleGenerativeAIEmbeddings
import chromadb

document_texts = extract_text_from_pdfs('/home/lillian/customer-service-agent/data')


text_splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=50)
documents = text_splitter.create_documents(document_texts)
embeddings = GoogleGenerativeAIEmbeddings(model = "models/embedding-001")



class EmbeddingFunction:
    def __call__(self, input):
        
        return embeddings.embed_documents(input)


chroma_client = chromadb.Client()


embedding_function = EmbeddingFunction()

collection = chroma_client.create_collection(
    name='company_documents_test_2',
    embedding_function=embedding_function
)

texts = [doc.page_content for doc in documents]

collection.add(
    documents=texts,
    
    ids=[str(i) for i in range(len(texts))]
)

from langchain.vectorstores import Chroma

vectorstore = Chroma.from_texts(
    texts= texts,
    collection_name="company_documents_test_2",
    embedding=embeddings
)

retriever = vectorstore.as_retriever()
