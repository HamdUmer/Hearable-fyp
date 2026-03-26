# chain.py
from App.chatbot.store_index import index_name, embeddings
from langchain_pinecone import PineconeVectorStore
from pinecone import Pinecone
import ollama
import os

# =========================
# 1️⃣ Initialize Pinecone
# =========================
pc = Pinecone(api_key=os.getenv("PINECONE_API_KEY"))
index = pc.Index(index_name)

vectorstore = PineconeVectorStore(
    index=index,
    embedding=embeddings
)

retriever = vectorstore.as_retriever()

# =========================
# 2️⃣ Wrapper function to get chatbot response
# =========================
def get_chat_response(query: str):
    # Retrieve relevant documents from Pinecone
    docs = retriever.invoke(query)
    
    # Combine documents into a single context string
    context = "\n".join([doc.page_content for doc in docs])
    
    # Build prompt: context + user query
    prompt = f"Context: {context}\n\nQuestion: {query}\nAnswer:"

    try:
        # Call local LLaMA model via Ollama
        result = ollama.chat(
            model="llama3.2:3b",
            messages=[
                {"role": "user", "content": prompt}
            ]
        )
        # Access response correctly
        return result.message.content
    except Exception as e:
        print(f"⚠️ Ollama error: {e}")
        return "⚠️ Chatbot error"