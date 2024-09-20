from main import answer_question, chunck_texts, initialize_retriever


def test_rag_pipeline():
    print("Hello, how can I help you today?")
    user_question = "Do you have Intel Xeon E5-2670 V3, what is its description and who is the employee assigned?"
    documents = chunck_texts()
    retriever = initialize_retriever(documents)
    try:
        answer = answer_question(user_question, retriever)
        print("User Question:")
        print(user_question)
        print("\nAnswer:")
        print(answer)
    except Exception as e:
        print(f"An error occurred during testing: {e}")
        
if __name__ == "__main__":
    test_rag_pipeline()