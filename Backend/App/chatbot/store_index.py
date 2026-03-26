# App/chatbot/store_index.py
from dotenv import load_dotenv
import os
from pinecone import Pinecone, ServerlessSpec
from langchain_pinecone import PineconeVectorStore
from App.chatbot.helper import load_pdf_files, filter_to_min, split_into_chunks, download_embeddings

# Load .env variables
load_dotenv()  # make sure .env is in Backend/

PINECONE_API_KEY = os.getenv("PINECONE_API_KEY")
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

# Set environment variables for Pinecone/OpenAI
os.environ["PINECONE_API_KEY"] = PINECONE_API_KEY
os.environ["OPENAI_API_KEY"] = OPENAI_API_KEY

# Load PDF data
extracted_data = load_pdf_files()  # uses dynamic DATA_DIR
filter_data = filter_to_min(extracted_data)
text_chunks = split_into_chunks(filter_data)
embeddings = download_embeddings()

# Initialize Pinecone
pc = Pinecone(api_key=PINECONE_API_KEY)
index_name = "hearable-chatbot"

# Create index if it doesn't exist
if not pc.has_index(index_name):
    pc.create_index(
        name=index_name,
        dimension=384,  # matches embeddings
        metric="cosine",
        spec=ServerlessSpec(cloud="aws", region="us-east-1")
    )

index = pc.Index(index_name)

# Create vector store
docsearch = PineconeVectorStore.from_documents(
    documents=text_chunks,
    embedding=embeddings,
    index_name=index_name
)