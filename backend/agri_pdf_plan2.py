import json
import re
from groq import Groq
from fpdf import FPDF
from datetime import datetime
from fastapi import APIRouter
from pydantic import BaseModel
from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse

report_router = APIRouter()

# Initialize Groq API client
GROQ_MODEL = "llama-3.3-70b-versatile"
client = Groq(api_key="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")

session_history = []
crop_plan = {}

class PDF(FPDF):
    def __init__(self):
        super().__init__()
        self.set_auto_page_break(auto=True, margin=15)
        self.set_title("Krishimitra Crop Management Plan")
    
    def header(self):
        # Add logo and header text
        self.image('krishimitra_logo.png', 10, 8, 25)  # Ensure logo file exists
        self.set_font('Helvetica', 'B', 16)
        self.set_text_color(0, 100, 0)  # Dark green
        self.cell(30)  # Move right of logo
        self.cell(0, 10, 'KRISHIMITRA Crop Management Plan', 0, 1, 'L')
        self.set_font('Helvetica', 'I', 10)
        self.cell(30)
        self.cell(0, 5, 'AI-Powered Agricultural Solutions', 0, 1, 'L')
        # Header line
        self.set_draw_color(0, 100, 0)
        self.line(10, 30, self.w - 10, 30)
        self.ln(12)

    def footer(self):
        self.set_y(-15)
        self.set_font('Helvetica', 'I', 8)
        self.set_text_color(0, 100, 0)
        # Footer line
        self.line(10, self.get_y(), self.w - 10, self.get_y())
        # Footer text
        self.cell(0, 10, 'Contact: support@krishimitra.com | Website: www.krishimitra.com', 0, 0, 'C')
        # Page number
        self.set_x(-30)
        self.cell(0, 10, f'Page {self.page_no()}', 0, 0, 'R')

    def chapter_title(self, title):
        self.set_font('Helvetica', 'B', 12)
        self.set_text_color(0, 100, 0)
        self.set_fill_color(230, 230, 200)
        self.cell(0, 10, title, 0, 1, 'L', 1)
        self.ln(4)

    def chapter_body(self, body):
        self.set_font('Helvetica', '', 11)
        self.set_text_color(0)
        self.multi_cell(0, 7, body)
        self.ln()

def clean_json_response(response):
    """Extract JSON from markdown formatted response"""
    try:
        cleaned = re.sub(r'^```json|```$', '', response, flags=re.MULTILINE)
        return cleaned.strip()
    except Exception as e:
        print(f"Error cleaning response: {e}")
        return response

def chat_with_llm(user_input):
    global session_history
    session_history.append({"role": "user", "content": user_input})

    system_prompt = """You are an agricultural expert assistant for Indian farmers. Generate detailed crop plans including:
    1. Crop selection based on soil type and climate
    2. Fertilizer recommendations with quantities per acre
    3. Pest control solutions with chemical/organic options
    4. Disease diagnosis and treatment
    5. Irrigation schedule with water requirements
    6. Market price trends and best selling periods
    7. Risk analysis (weather, pests, market)
    8. Insurance options with premium estimates
    9. Financial projections (costs, yield, profit in INR)
    
    Respond ONLY with raw JSON format without any markdown formatting or additional text.
    Structure response with these keys:
    - crop_recommendation
    - soil_preparation
    - sowing_plan 
    - fertilizer_schedule
    - pest_management
    - disease_control
    - irrigation_plan
    - harvest_plan
    - market_analysis
    - risk_assessment
    - insurance_options
    - financial_projections
    
    Use metric units and INR currency. Be specific to Indian agricultural practices."""

    response = client.chat.completions.create(
        model=GROQ_MODEL,
        messages=[{"role": "system", "content": system_prompt}] + session_history[-5:],
        temperature=0.7,
        max_tokens=1500,
        top_p=1,
        stream=False
    )

    bot_response = response.choices[0].message.content
    session_history.append({"role": "assistant", "content": bot_response})
    return bot_response

def validate_crop_plan(data):
    required_keys = [
        'crop_recommendation', 'soil_preparation', 'sowing_plan',
        'fertilizer_schedule', 'pest_management', 'disease_control',
        'irrigation_plan', 'harvest_plan', 'market_analysis',
        'risk_assessment', 'insurance_options', 'financial_projections'
    ]
    return all(key in data for key in required_keys)

def format_value(value, indent_level=0):
    """Recursively format nested JSON data with proper indentation and bullet points"""
    indent = '  ' * indent_level
    formatted_lines = []

    if isinstance(value, dict):
        for k, v in value.items():
            key_str = f"{k.replace('_', ' ').title()}"
            if isinstance(v, (dict, list)):
                formatted_lines.append(f"{indent}- {key_str}:")
                formatted_lines.append(format_value(v, indent_level + 1))
            else:
                formatted_lines.append(f"{indent}- {key_str}: {v}")
    elif isinstance(value, list):
        for item in value:
            if isinstance(item, (dict, list)):
                formatted_lines.append(f"{indent}- ")
                formatted_lines.append(format_value(item, indent_level + 1))
            else:
                formatted_lines.append(f"{indent}- {item}")
    else:
        formatted_lines.append(f"{indent}- {value}")

    return '\n'.join(formatted_lines)

def generate_pdf_report(data, farmer_data, filename="crop_plan.pdf"):
    pdf = PDF()
    pdf.add_page()
    
    # Add farmer information section
    pdf.chapter_title("Farmer Profile Summary")
    farmer_info = f"""
    Location: {farmer_data['location']}
    Soil Type: {farmer_data['soil_type']}
    Farm Size: {farmer_data['farm_size']} acres
    Preferred Crop: {farmer_data['crop_type'] or 'Not specified'}
    Previous Crop: {farmer_data['last_crop']}
    Budget: INR {farmer_data['budget']}
    """
    pdf.chapter_body(farmer_info.strip())
    
    # Add report sections
    sections = {
        "Crop Recommendation": format_value(data.get('crop_recommendation', '')),
        "Soil Preparation Guidelines": format_value(data.get('soil_preparation', '')),
        "Sowing Plan": format_value(data.get('sowing_plan', '')),
        "Fertilizer Schedule": format_value(data.get('fertilizer_schedule', '')),
        "Pest Management Strategy": format_value(data.get('pest_management', '')),
        "Disease Control Measures": format_value(data.get('disease_control', '')),
        "Irrigation Plan": format_value(data.get('irrigation_plan', '')),
        "Harvest Planning": format_value(data.get('harvest_plan', '')),
        "Market Analysis": format_value(data.get('market_analysis', '')),
        "Risk Assessment": format_value(data.get('risk_assessment', '')),
        "Insurance Options": format_value(data.get('insurance_options', '')),
        "Financial Projections (INR)": format_value(data.get('financial_projections', ''))
    }

    for title, content in sections.items():
        pdf.chapter_title(title)
        pdf.chapter_body(content)
        pdf.ln(3)
    
    # try:
    #     pdf.output(filename)
    #     return True
    # except Exception as e:
    #     print(f"PDF generation error: {e}")
    #     return False

    try:
        pdf.output(filename)
        return filename
    except Exception as e:
        print(f"PDF generation error: {e}")
        return None

def collect_farmer_input():
    print("\n" + "="*50)
    print("KRISHIMITRA Agricultural Planning System".center(50))
    print("="*50 + "\n")
    inputs = {
        'location': input("Enter your location (State/District): "),
        'soil_type': input("Soil type (Clay/Loam/Sandy): ").capitalize(),
        'farm_size': float(input("Farm size (acres): ")),
        'crop_type': input("Preferred crop type (leave blank for recommendations): ").title(),
        'last_crop': input("Previous crop cultivated: ").title(),
        'budget': input("Estimated budget (INR): ")
    }
    return inputs

# Request body structure for the user's input
class UserInput(BaseModel):
    location: str
    soil_type: str
    farm_size: float
    crop_type: str
    last_crop: str
    budget: str

@report_router.post("/")
def main(input: UserInput):

    # farmer_data = collect_farmer_input()
    initial_query = f"""Generate crop plan for:
    location: {input.location}
    soil_type: {input.soil_type}
    farm_size: {input.farm_size} acres
    crop_type: {input.crop_type or 'Not specified'}
    last_crop: {input.last_crop}
    budget: INR {input.budget}
    """

    response = chat_with_llm(json.dumps(initial_query))

    # cleaned_response = clean_json_response(response)
    # crop_data = json.loads(cleaned_response)
    try:
        cleaned_response = clean_json_response(response)
        crop_data = json.loads(cleaned_response)
        
        if not validate_crop_plan(crop_data):
            return {"response": "Incomplete crop plan data"}
            raise ValueError("Incomplete crop plan data")

        farmer_data = {
    'location': input.location,
    'soil_type': input.soil_type,
    'farm_size': input.farm_size,
    'crop_type': input.crop_type,
    'last_crop': input.last_crop,
    'budget': input.budget
}

        pdf_filename = generate_pdf_report(crop_data, farmer_data)

        
        # pdf_filename = generate_pdf_report(crop_data, initial_query)

        if pdf_filename:
            return FileResponse(pdf_filename, media_type='application/pdf', filename="crop_plan.pdf")
        else:
            raise HTTPException(status_code=500, detail="Failed to generate PDF")
    
            
        # if generate_pdf_report(crop_data):
        #     print("\nSuccessfully generated comprehensive crop plan!")
        #     print("Check 'crop_plan.pdf' for detailed recommendations")

        #     # Return the response to the frontend
        #     # return {"response": "Successfully generated comprehensive crop plan! Check 'crop_plan.pdf' for detailed recommendations"}
        # else:
        #     print("Failed to generate PDF report")
    except json.JSONDecodeError:
        print("Error parsing response. Here's the raw recommendation:\n")
        print(response)
    except Exception as e:
        print(f"Error: {str(e)}")

    # if validate_crop_plan(crop_data) and generate_pdf_report(crop_data, initial_query):
    #     print("\nSuccessfully generated 'crop_plan.pdf'!")

if __name__ == "__main__":
    main()