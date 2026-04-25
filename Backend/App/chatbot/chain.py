# chain.py
from App.chatbot.store_index import index_name, embeddings
from langchain_pinecone import PineconeVectorStore
from pinecone import Pinecone
import ollama
import os


pc = Pinecone(api_key=os.getenv("PINECONE_API_KEY"))
index = pc.Index(index_name)

vectorstore = PineconeVectorStore(
    index=index,
    embedding=embeddings
)

retriever = vectorstore.as_retriever()


def get_chat_response(query: str):
    
    docs = retriever.invoke(query)
    
    
    context = "\n".join([doc.page_content for doc in docs])
    
    
    prompt = f"Context: {context}\n\nQuestion: {query}\nAnswer:"

    try:
        
        result = ollama.chat(
            model="llama3.2:3b",
            messages=[
                {"role": "user", "content": prompt}
            ]
        )
        
        return result.message.content
    except Exception as e:
        print(f"⚠️ Ollama error: {e}")
        return "⚠️ Chatbot error"