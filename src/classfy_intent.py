from langchain.prompts import PromptTemplate
from langchain.schema import HumanMessage
from dotenv import load_dotenv
import google.generativeai as genai
import os
from langchain_google_genai import ChatGoogleGenerativeAI


load_dotenv()
GOOGLE_API_KEY = os.getenv("GOOGLE_API_KEY")
genai.configure(api_key=GOOGLE_API_KEY)




llm = ChatGoogleGenerativeAI(model="gemini-1.0-pro-latest")

def classify_intent(question):
    print("classifying intent of the question")
    prompt = f"""
    You are an AI assistant that classifies customer questions into one of the following intents:

    - **Inventory Inquiry**: Questions about product availability, specifications, pricing, or inventory.
    - **General Inquiry**: Questions about company policies, services, or general information.
    - **Other**: Any other questions.

    Based on the user's question below, classify it into one of the intents and return only the intent label: 'Inventory Inquiry', 'General Inquiry', or 'Other'.

    Question:
    "{question}"

    Intent:
    """
    
    messages = [HumanMessage(content=prompt)]
    
    response = llm.invoke(messages)
    
    intent = response.content.strip()
    print("The customer's intent is", intent)
    return intent
