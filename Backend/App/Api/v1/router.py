from fastapi import APIRouter
from App.schemas.chat import ChatRequest, ChatResponse
from App.chatbot.chain import get_chat_response

router = APIRouter()

@router.post("/chat", response_model=ChatResponse)
def chat(request: ChatRequest):
    reply = get_chat_response(request.message)
    return ChatResponse(response=reply) 