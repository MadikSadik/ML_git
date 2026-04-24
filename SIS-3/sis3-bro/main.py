from fastapi import FastAPI
from pydantic import BaseModel
import joblib

app = FastAPI()
model = joblib.load("model.joblib")

class WineFeatures(BaseModel):
    features: list[float]

@app.get("/")
def root():
    return {"message": "ML API is running"}

@app.post("/predict")
def predict(data: WineFeatures):
    prediction = model.predict([data.features])
    return {"predict": int(prediction[0])}