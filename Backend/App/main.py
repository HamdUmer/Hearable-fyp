from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
import os
from urllib.parse import quote
from contextlib import asynccontextmanager
from fastapi.middleware.cors import CORSMiddleware


# Absolute path to videos folder (outside App/)
videos_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "videos"))

# Store one video per word
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
                files = [
                    f for f in os.listdir(word_path)
                    if f.endswith(".mp4")
                ]

                if files:
                    video_data[word] = files[0]

        print(f"Loaded {len(video_data)} words")

    yield  # App runs here

    # Shutdown (optional)
    print("App shutting down...")


app = FastAPI(lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Or specify your Flutter web origin
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Serve videos correctly
app.mount("/videos", StaticFiles(directory=videos_path), name="videos")


@app.get("/words")
def get_words():
    result = []

    for word, file in video_data.items():
        encoded_word = quote(word)
        encoded_file = quote(file)

        result.append({
            "word": word,
            "video": f"http://127.0.0.1:8000/videos/{encoded_word}/{encoded_file}"
        })

    return result