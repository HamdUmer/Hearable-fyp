# App/chatbot/helper.py
from langchain_community.document_loaders import PyPDFLoader, DirectoryLoader
from typing import List
from langchain_core.documents import Document
from langchain_community.embeddings import HuggingFaceEmbeddings  # updated import
from langchain_text_splitters import RecursiveCharacterTextSplitter
import os


BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_DIR = os.path.join(BASE_DIR, "data")  # points to App/data


def load_pdf_files(data=DATA_DIR):
    loader = DirectoryLoader(
        data,
        glob="*.pdf",
        loader_cls=PyPDFLoader
    )
    documents = loader.load()
    return documents


def filter_to_min(docs: List[Document]) -> List[Document]:
    minimal_docs: List[Document] = []
    for doc in docs:
        src = doc.metadata.get("source")
        minimal_docs.append(
            Document(
                page_content=doc.page_content,
                metadata={"source": src}
            )
        )
    return minimal_docs


def split_into_chunks(minimal_docs: List[Document]):
    text_splitter = RecursiveCharacterTextSplitter(
        chunk_size=500,
        chunk_overlap=20,
    )
    texts_chunk = text_splitter.split_documents(minimal_docs)
    return texts_chunk


def download_embeddings():
    model_name = "sentence-transformers/all-MiniLM-L6-v2"
    embeddings = HuggingFaceEmbeddings(model_name=model_name)
    return embeddings