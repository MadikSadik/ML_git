# ML Model Deployment with FastAPI and Docker

A simple machine learning model deployed as an API using FastAPI and Docker.

## Dataset
Wine dataset from scikit-learn (3 classes, 13 features).

## Project Structure
- train.py — trains and saves the model
- main.py — FastAPI application
- model.joblib — saved trained model
- requirements.txt — Python dependencies
- Dockerfile — Docker container instructions

## How to Run

### Train the model
python train.py

### Run locally
uvicorn main:app --reload

### Run with Docker
docker build -t ml-api .
docker run -p 8000:8000 ml-api

## API Endpoints
- GET / — health check
- POST /predict — send 13 wine features, get predicted class

## Example Request
{"features": [13.0, 2.0, 2.0, 10.0, 90.0, 2.0, 2.0, 0.3, 1.5, 5.0, 1.0, 3.0, 1000.0]}