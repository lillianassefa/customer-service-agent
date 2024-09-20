import os
from PyPDF2 import PdfReader

def extract_text_from_pdfs(directory):
    texts = []
    for filename in os.listdir(directory):
        if filename.endswith('.pdf'):
            filepath = os.path.join(directory, filename)
            reader = PdfReader(filepath)
            text = ""
            for page in reader.pages:
                text += page.extract_text()
            texts.append(text)
    return texts


