from fastapi import FastAPI

app = FastAPI(title="DeepWork AI Flows API")

@app.get("/")
def read_root():
    return {"message": "DeepWork AI Flows API is running 🚀"}

@app.get("/health")
def health_check():
    return {"status": "ok"}
