from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
import cv2
import numpy as np
import tensorflow as tf
import matplotlib.pyplot as plt
from PIL import Image
import io
import uvicorn
import os
from datetime import datetime
from image import image_router
from cropplan import cropplan_router
from c1 import chatbot_router
from weather import weather_router
from agri_pdf_plan2 import report_router

app = FastAPI()

# CORS middleware setup
origins = [
    "http://localhost",
    "http://localhost:3000",
    "*",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routes
app.include_router(image_router, prefix="/image", tags=["Image"])
app.include_router(cropplan_router, prefix="/cropplan", tags=["Cropplan"])
app.include_router(chatbot_router, prefix="/chatbot", tags=["Chatbot"])
app.include_router(weather_router, prefix="/weather", tags=["Weather"])
app.include_router(report_router, prefix="/report", tags=["Report"])

# Run FastAPI
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
