import os
from langchain_community.vectorstores import Chroma
from langchain_text_splitters import RecursiveCharacterTextSplitter
import google.generativeai as genai
from src.log_interaction import log_interaction
from src.search import  search_inventory
from src.classfy_intent import classify_intent
from src.db import db_conn
from src.pdf_extractor import extract_text_from_pdfs
from langchain_google_genai import GoogleGenerativeAIEmbeddings
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain.prompts import PromptTemplate
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain.schema import HumanMessage

import logging
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional


app = FastAPI(
    title="Customer Service Agent API",
    description="API for interacting with the Customer Service Agent using RAG pipeline.",
)

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

from src.config import (
    GOOGLE_API_KEY,
    DATA_PATH,
    CHROMA_DB_PATH,
    EMBEDDING_MODEL,
    LLM_MODEL,
    CHROMA_COLLECTION_NAME
)

genai.configure(api_key=GOOGLE_API_KEY)


text_splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=50)
embeddings = GoogleGenerativeAIEmbeddings(model="models/embedding-001")
llm = ChatGoogleGenerativeAI(model="gemini-1.0-pro-latest")

def chunck_texts():
    logger.info("Documents extracted from PDFs.")
    document_texts = extract_text_from_pdfs('/home/lillian/customer-service-agent/data')
    documents = text_splitter.create_documents(document_texts)
    logger.info(f"Total documents chunked: {len(documents)}")
    return documents

def initialize_retriever(documents):
    logger.info("Retriever initialized successfully.")
    try:
        vectorstore = Chroma.from_texts(
            texts=[doc.page_content for doc in documents],
            embedding=embeddings,
            collection_name="company_documents_test_2",
            persist_directory="/home/lillian/customer-service-agent/chroma_db"
            )
        retriever = vectorstore.as_retriever()
        logger.info("Retriever initialized successfully.")
        return retriever
    except Exception as e:
        logger.error(f"Failed to initialize retriever: {e}")
        raise
documents = chunck_texts()
retriever = initialize_retriever(documents)

class QuestionRequest(BaseModel):
    question: str

class AnswerResponse(BaseModel):
    answer: str
    
@app.post("/ask", response_model=AnswerResponse, summary="Ask a question to the Customer Service Agent")
def ask_question(request: QuestionRequest):
    """
    Receive a user question and return an answer based on the company's documents and inventory.
    """
    user_question = request.question.strip()
    logger.info("This is the user's question:",user_question)
    if not user_question:
        raise HTTPException(status_code=400, detail="Question cannot be empty.")

    try:
        answer = answer_question(user_question, retriever)
        return AnswerResponse(answer=answer)
    except Exception as e:
        logger.error(f"Error processing question: {e}")
        raise HTTPException(status_code=500, detail="An error occurred while processing your request.")

def answer_question(user_question: str, retriever) -> str:
    intent = classify_intent(user_question)
    logger.info(f"Classified intent: {intent}")
    context = ""
    if intent == 'Inventory Inquiry':
        product_info = search_inventory(user_question)
        if product_info:
            context += (
                f"Product Name: {product_info.get('productname', 'N/A')}\n"
                f"Category: {product_info.get('categoryname', 'N/A')}\n"
                f"Description: {product_info.get('productdescription', 'N/A')}\n"
                f"Price: ${product_info.get('productlistprice', 'N/A')}\n"
                f"Quantity in Stock: {product_info.get('totalitemquantity', 'N/A')}\n"
                f"Warehouse: {product_info.get('warehousename', 'N/A')} at {product_info.get('warehouseaddress', 'N/A')}\n"
                f"Contact: {product_info.get('employeename', 'N/A')} ({product_info.get('employeeemail', 'N/A')})\n"
            )
            logger.info("Product information retrieved from inventory.")
        else:
            context += "No matching products found in inventory.\n"
            logger.info("No matching products found in inventory.")
    elif intent == 'General Inquiry':
        retrieved_docs = retriever.get_relevant_documents(user_question)
        logger.info(f"Retrieved {len(retrieved_docs)} relevant documents.")
        if retrieved_docs:
            context += "\n".join([doc.page_content for doc in retrieved_docs])
        else:
            context += "No relevant documents found.\n"
            logger.info("No relevant documents found.")
    else:
        product_info = search_inventory(user_question)
        logger.info("Product information retrieved from inventory for other intent.")
        if product_info:
            context += (
                f"Product Name: {product_info.get('productname', 'N/A')}\n"
                f"Category: {product_info.get('categoryname', 'N/A')}\n"
                f"Description: {product_info.get('productdescription', 'N/A')}\n"
                f"Price: ${product_info.get('productlistprice', 'N/A')}\n"
                f"Quantity in Stock: {product_info.get('totalitemquantity', 'N/A')}\n"
                f"Warehouse: {product_info.get('warehousename', 'N/A')} at {product_info.get('warehouseaddress', 'N/A')}\n"
                f"Contact: {product_info.get('employeename', 'N/A')} ({product_info.get('employeeemail', 'N/A')})\n"
            )
        retrieved_docs = retriever.get_relevant_documents(user_question)
        if retrieved_docs:
            context += "\n".join([doc.page_content for doc in retrieved_docs])
            logger.info(f"Retrieved {len(retrieved_docs)} relevant documents for other intent.")
    if context.strip():
        prompt = f"""
        You are an AI assistant for a company that specializes in computer-based products and services. Your role is to assist customers by providing information from the company's documents and inventory database.

        Use the following context to answer the customer's question. If you cannot find the information in the context, politely inform the customer that you don't have that information.

        Ensure your response is clear, professional, and informative.

        Context:
        {context}

        Question:
        {user_question}

        Answer:
        """ 
        messages = [HumanMessage(content=prompt)]
        response = llm.invoke(messages)
        logger.info("Generated answer using LLM.")
        answer = response.content.strip()
    else:
        answer = "I'm sorry, but I don't have that information."
        logger.info("No context available to generate an answer.")

    log_interaction(user_question, answer)
    logger.info("Logged the interaction.")

    return answer


