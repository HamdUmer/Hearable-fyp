from fastapi import FastAPI, Request
from fastapi.staticfiles import StaticFiles
import os
from urllib.parse import quote
from contextlib import asynccontextmanager
from fastapi.middleware.cors import CORSMiddleware

# ✅ Import chatbot router
from App.Api.v1.router import router as chat_router


# =========================
# 📁 Video Folder Setup
# =========================

videos_path = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "..", "videos")
)

video_data = {}


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup logic
    if not os.path.exists(videos_path):
        print(f"Videos folder not found: {videos_path}")
    else:
        for word in os.listdir(videos_path):
            word_path = os.path.join(videos_path, word)

            if os.path.isdir(word_path):
                files = [f for f in os.listdir(word_path) if f.endswith(".mp4")]

                if files:
                    video_data[word] = files[0]

        print(f"Loaded {len(video_data)} words")

    yield

    print("App shutting down...")


# =========================
# 🚀 FastAPI App
# =========================

app = FastAPI(lifespan=lifespan)


# =========================
# 🌐 CORS (IMPORTANT for Flutter)
# =========================

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all for development
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# =========================
# 📦 Mount Video Folder
# =========================

app.mount("/videos", StaticFiles(directory=videos_path), name="videos")


# =========================
# 🎥 Video API
# =========================

@app.get("/words")
def get_words(request: Request):
    result = []

    base_url = str(request.base_url)

    for word, file in video_data.items():
        encoded_word = quote(word)
        encoded_file = quote(file)

        result.append({
            "word": word,
            "video": f"{base_url}videos/{encoded_word}/{encoded_file}"
        })

    return result


# =========================
# 🤖 Chatbot API
# =========================

app.include_router(chat_router, prefix="/api/v1")


# =========================
# 🏠 Root Endpoint
# =========================

@app.get("/")
def home():
    return {"message": "Backend running with Chatbot + Videos"}