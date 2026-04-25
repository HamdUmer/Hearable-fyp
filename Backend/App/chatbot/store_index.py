# App/chatbot/store_index.py
from dotenv import load_dotenv
import os
from pinecone import Pinecone, ServerlessSpec
from langchain_pinecone import PineconeVectorStore
from App.chatbot.helper import load_pdf_files, filter_to_min, split_into_chunks, download_embeddings


load_dotenv()  # make sure .env is in Backend/

PINECONE_API_KEY = os.getenv("PINECONE_API_KEY")
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")


os.environ["PINECONE_API_KEY"] = PINECONE_API_KEY
os.environ["OPENAI_API_KEY"] = OPENAI_API_KEY


extracted_data = load_pdf_files()  # uses dynamic DATA_DIR
filter_data = filter_to_min(extracted_data)
text_chunks = split_into_chunks(filter_data)
embeddings = download_embeddings()


pc = Pinecone(api_key=PINECONE_API_KEY)
index_name = "hearable-chatbot"


if not pc.has_index(index_name):
    pc.create_index(
        name=index_name,
        dimension=384,  # matches embeddings
        metric="cosine",
        spec=ServerlessSpec(cloud="aws", region="us-east-1")
    )

index = pc.Index(index_name)


docsearch = PineconeVectorStore.from_documents(
    documents=text_chunks,
    embedding=embeddings,
    index_name=index_name
)