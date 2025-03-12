# import json
# import re
# from groq import Groq
# from fpdf import FPDF
# from datetime import datetime
# from fastapi import APIRouter
# from pydantic import BaseModel
# from fastapi import FastAPI, HTTPException
# from fastapi.responses import FileResponse

# report_router = APIRouter()

# # Initialize Groq API client
# GROQ_MODEL = "llama-3.3-70b-versatile"
# client = Groq(api_key="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")

# session_history = []
# crop_plan = {}

# class PDF(FPDF):
#     def header(self):
#         self.set_font('Arial', 'B', 16)
#         self.cell(0, 10, 'Comprehensive Crop Management Plan', 0, 1, 'C')
#         self.ln(10)

#     def chapter_title(self, title):
#         self.set_font('Arial', 'B', 12)
#         self.cell(0, 10, title, 0, 1)
#         self.ln(4)

#     def chapter_body(self, body):
#         self.set_font('Arial', '', 12)
#         self.multi_cell(0, 8, body)
#         self.ln()

# def clean_json_response(response):
#     """Extract JSON from markdown formatted response"""
#     try:
#         cleaned = re.sub(r'^```json|```$', '', response, flags=re.MULTILINE)
#         return cleaned.strip()
#     except Exception as e:
#         print(f"Error cleaning response: {e}")
#         return response

# def chat_with_llm(user_input):
#     global session_history
#     session_history.append({"role": "user", "content": user_input})

#     system_prompt = """You are an agricultural expert assistant for Indian farmers. Generate detailed crop plans including:
#     1. Crop selection based on soil type and climate
#     2. Fertilizer recommendations with quantities per acre
#     3. Pest control solutions with chemical/organic options
#     4. Disease diagnosis and treatment
#     5. Irrigation schedule with water requirements
#     6. Market price trends and best selling periods
#     7. Risk analysis (weather, pests, market)
#     8. Insurance options with premium estimates
#     9. Financial projections (costs, yield, profit in INR)
    
#     Respond ONLY with raw JSON format without any markdown formatting or additional text.
#     Structure response with these keys:
#     - crop_recommendation
#     - soil_preparation
#     - sowing_plan 
#     - fertilizer_schedule
#     - pest_management
#     - disease_control
#     - irrigation_plan
#     - harvest_plan
#     - market_analysis
#     - risk_assessment
#     - insurance_options
#     - financial_projections
    
#     Use metric units and INR currency. Be specific to Indian agricultural practices."""

#     response = client.chat.completions.create(
#         model=GROQ_MODEL,
#         messages=[{"role": "system", "content": system_prompt}] + session_history[-5:],
#         temperature=0.7,
#         max_tokens=1500,
#         top_p=1,
#         stream=False
#     )

#     bot_response = response.choices[0].message.content
#     session_history.append({"role": "assistant", "content": bot_response})
#     return bot_response

# def validate_crop_plan(data):
#     required_keys = [
#         'crop_recommendation', 'soil_preparation', 'sowing_plan',
#         'fertilizer_schedule', 'pest_management', 'disease_control',
#         'irrigation_plan', 'harvest_plan', 'market_analysis',
#         'risk_assessment', 'insurance_options', 'financial_projections'
#     ]
#     return all(key in data for key in required_keys)

# def generate_pdf_report(data, filename="crop_plan.pdf"):
#     pdf = PDF()
#     pdf.add_page()
    
#     def format_value(value):
#         if isinstance(value, dict):
#             return '\n'.join([f"{k}: {v}" for k, v in value.items()])
#         return str(value)

#     sections = {
#         "Crop Recommendation": format_value(data.get('crop_recommendation', '')),
#         "Soil Preparation": format_value(data.get('soil_preparation', '')),
#         "Sowing Plan": format_value(data.get('sowing_plan', '')),
#         "Fertilizer Schedule": format_value(data.get('fertilizer_schedule', '')),
#         "Pest Management": format_value(data.get('pest_management', '')),
#         "Disease Control": format_value(data.get('disease_control', '')),
#         "Irrigation Plan": format_value(data.get('irrigation_plan', '')),
#         "Harvest Plan": format_value(data.get('harvest_plan', '')),
#         "Market Analysis": format_value(data.get('market_analysis', '')),
#         "Risk Assessment": format_value(data.get('risk_assessment', '')),
#         "Insurance Options": format_value(data.get('insurance_options', '')),
#         "Financial Projections": format_value(data.get('financial_projections', ''))
#     }

#     for title, content in sections.items():
#         pdf.chapter_title(title)
#         pdf.chapter_body(content)
    
#     try:
#         pdf.output(filename)
#         return filename
#     except Exception as e:
#         print(f"PDF generation error: {e}")
#         return None

# def collect_farmer_input():
#     print("Welcome to Krishi Mitra - Agricultural Planning Assistant\n")
#     inputs = {
#         'location': input("Enter your location (State/District): "),
#         'soil_type': input("Soil type (Clay/Loam/Sandy): ").capitalize(),
#         'farm_size': float(input("Farm size (acres): ")),
#         'crop_type': input("Preferred crop type (leave blank for recommendations): ").title(),
#         'last_crop': input("Previous crop cultivated: ").title(),
#         'budget': input("Estimated budget (INR): ")
#     }
#     return inputs

# # Request body structure for the user's input
# class UserInput(BaseModel):
#     location: str
#     soil_type: str
#     farm_size: float
#     crop_type: str
#     last_crop: str
#     budget: str

# @report_router.post("/")
# def main(input: UserInput):
#     # farmer_data = collect_farmer_input()
#     # initial_query = f"""Generate crop plan for:
#     # Location: {farmer_data['location']}
#     # Soil Type: {farmer_data['soil_type']}
#     # Farm Size: {farmer_data['farm_size']} acres
#     # Preferred Crop: {farmer_data['crop_type'] or 'Not specified'}
#     # Previous Crop: {farmer_data['last_crop']}
#     # Budget: INR {farmer_data['budget']}
#     # """
#     print("input locaiofs",input.location)
#     initial_query = f"""Generate crop plan for:
#     Location: {input.location}
#     Soil Type: {input.soil_type}
#     Farm Size: {input.farm_size} acres
#     Preferred Crop: {input.crop_type or 'Not specified'}
#     Previous Crop: {input.last_crop}
#     Budget: INR {input.budget}
#     """

#     response = chat_with_llm(initial_query)
    
#     try:
#         cleaned_response = clean_json_response(response)
#         crop_data = json.loads(cleaned_response)
        
#         if not validate_crop_plan(crop_data):
#             return {"response": "Incomplete crop plan data"}
#             raise ValueError("Incomplete crop plan data")
        
#         pdf_filename = generate_pdf_report(crop_data)

#         if pdf_filename:
#             return FileResponse(pdf_filename, media_type='application/pdf', filename="crop_plan.pdf")
#         else:
#             raise HTTPException(status_code=500, detail="Failed to generate PDF")
    
            
#         # if generate_pdf_report(crop_data):
#         #     print("\nSuccessfully generated comprehensive crop plan!")
#         #     print("Check 'crop_plan.pdf' for detailed recommendations")

#         #     # Return the response to the frontend
#         #     # return {"response": "Successfully generated comprehensive crop plan! Check 'crop_plan.pdf' for detailed recommendations"}
#         # else:
#         #     print("Failed to generate PDF report")
#     except json.JSONDecodeError:
#         print("Error parsing response. Here's the raw recommendation:\n")
#         print(response)
#     except Exception as e:
#         print(f"Error: {str(e)}")

# if __name__ == "__main__":
#     main()