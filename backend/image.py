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
from fastapi import FastAPI, APIRouter
from cure_disease import disease_cures
import json

image_router = APIRouter()

# Load trained model
model  = tf.keras.models.load_model('trained_model.h5')

# Function to process the image
def preprocess_image(image_path):
    # image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
    # image = np.array(image)
    # image = cv2.resize(image, (128, 128))  # Resize to model's input shape
    # image = image / 255.0  # Normalize
    # image = np.expand_dims(image, axis=0)  # Add batch dimension

    # image_path = "img"
    # image_path = "test_plant.jpg"
    #Reading Image
    img = cv2.imread(image_path)
    print("here1")
    img = cv2.cvtColor(img,cv2.COLOR_BGR2RGB) 
    print("here2")


    image = tf.keras.preprocessing.image.load_img(image_path,target_size=(128, 128))
    print("here3")
    input_arr = tf.keras.preprocessing.image.img_to_array(image)
    print("here4")
    input_arr = np.array([input_arr]) #Convert single image to a batch
    print("here5")
    print(input_arr.shape)
    print("here6")
    return input_arr

# #To get cure of plant disease
# def get_cure_info(disease_name):
#     disease = disease_cures.get(disease_name)
#     if disease:
#         cure_info = f"{disease['cure']}"
#         if disease['insecticides']:
#             cure_info += "\nRecommended products:\n- " + "\n- ".join(disease['insecticides'])
#         return cure_info
#     else:
#         return "No cure information available for this disease."
        
def get_cure_info(disease_name):
    disease = disease_cures.get(disease_name)
    if disease:
        info = {}
        # Add Symptoms
        if 'symptoms' in disease and disease['symptoms']:
            info["symptoms"] = disease['symptoms']
        # Add Cure
        info["cure"] = disease['cure']
        # Add Insecticides if applicable
        if disease['insecticides']:
            info["recommended_products"] = disease['insecticides']
        return json.dumps(info, indent=4)
    else:
        return json.dumps({"error": "No information available for this disease."}, indent=4)

# API endpoint to predict disease
@image_router.post("/")
async def predict(file: UploadFile = File(...)):
    try:
        # image_bytes = await file.read()

        # Define the folder to save images
        save_folder = "uploaded_images"
        os.makedirs(save_folder, exist_ok=True)  # Create folder if not exists

        # Create a unique filename using timestamp
        filename = f"{datetime.now().strftime('%Y%m%d%H%M%S')}_{file.filename}"
        file_path = os.path.join(save_folder, filename)
        # file_path = "test_plant.jpg"


        with open(file_path, "wb") as buffer:
            buffer.write(await file.read())

        # image = preprocess_image(image_bytes)
        input_arr = preprocess_image(file_path)
        print("here7")
        # Make prediction
        prediction = model.predict(input_arr)
        # predicted_class = np.argmax(prediction)  # Get the highest probability class
        # print("predicted_class:",predicted_class)
        result_index = np.argmax(prediction)
        print("result_index:", result_index)

        result_index



        class_name = ['Apple___Apple_scab',
 'Apple___Black_rot',
 'Apple___Cedar_apple_rust',
 'Apple___healthy',
 'Blueberry___healthy',
 'Cherry_(including_sour)___Powdery_mildew',
 'Cherry_(including_sour)___healthy',
 'Corn_(maize)___Cercospora_leaf_spot Gray_leaf_spot',
 'Corn_(maize)___Common_rust_',
 'Corn_(maize)___Northern_Leaf_Blight',
 'Corn_(maize)___healthy',
 'Grape___Black_rot',
 'Grape___Esca_(Black_Measles)',
 'Grape___Leaf_blight_(Isariopsis_Leaf_Spot)',
 'Grape___healthy',
 'Orange___Haunglongbing_(Citrus_greening)',
 'Peach___Bacterial_spot',
 'Peach___healthy',
 'Pepper,_bell___Bacterial_spot',
 'Pepper,_bell___healthy',
 'Potato___Early_blight',
 'Potato___Late_blight',
 'Potato___healthy',
 'Raspberry___healthy',
 'Soybean___healthy',
 'Squash___Powdery_mildew',
 'Strawberry___Leaf_scorch',
 'Strawberry___healthy',
 'Tomato___Bacterial_spot',
 'Tomato___Early_blight',
 'Tomato___Late_blight',
 'Tomato___Leaf_Mold',
 'Tomato___Septoria_leaf_spot',
 'Tomato___Spider_mites Two-spotted_spider_mite',
 'Tomato___Target_Spot',
 'Tomato___Tomato_Yellow_Leaf_Curl_Virus',
 'Tomato___Tomato_mosaic_virus',
 'Tomato___healthy']

        #Displaying Result of disease prediction
        model_prediction = class_name[result_index]
        print("model_prediction:",model_prediction)

        info = get_cure_info(model_prediction)

        # return JSONResponse(content={"prediction": int(predicted_class)})
        return JSONResponse(content={"prediction": model_prediction, "info": info})
    except Exception as e:
        return JSONResponse(content={"error": str(e)}, status_code=500)
