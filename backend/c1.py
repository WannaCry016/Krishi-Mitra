import json
from groq import Groq
from datetime import datetime
from fastapi import FastAPI, APIRouter
from pydantic import BaseModel

# Create router
chatbot_router = APIRouter()

GROQ_MODEL = "llama3-70b-8192"
LANGUAGES = {
    "1": {"code": "en", "name": "English"},
    "2": {"code": "hi", "name": "Hindi"}
}

client = Groq(api_key="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")

class AgricultureChatbot:
    def __init__(self, language="en"):
        self.session_history = []
        self.current_language = language
        self.current_date = datetime.now()
        # self.setup_language()
        self.initialize_prompt_template()

    # def setup_language(self):
    #     print("\nPlease choose your language / कृपया अपनी भाषा चुनें:")
    #     for key, lang in LANGUAGES.items():
    #         print(f"{key}. {lang['name']}")
            
    #     while True:
    #         choice = input("\nEnter choice (1-2): ")
    #         if choice in LANGUAGES:
    #             self.current_language = LANGUAGES[choice]["code"]
    #             break
    #         print("Invalid choice. Please enter 1 or 2.")

    def initialize_prompt_template(self):
        """Enhanced agricultural prompt with dynamic data"""
        month_name = self.current_date.strftime("%B")
        season = self.get_up_season()
        
        self.base_prompt = f"""
🌾 You are KrishiMitra - Uttar Pradesh's AI Agricultural Assistant
📅 Today: {self.current_date.strftime("%d-%b-%Y")} ({month_name}, {season} season)
📍 Serving: All 75 districts of UP

**Core Expertise:**
1. Crop Management (Sugarcane, Wheat, Mango, Potato, Basmati)
2. Soil Health & Fertilization
3. Government Schemes & Subsidies
4. Pest/Disease Management
5. Market Prices & MSP Guidance

**Regional Knowledge:**
• Western UP (Alluvial): Sugarcane/Wheat belt | pH 7-8.5
• Bundelkhand (Red Soil): Drought-resistant crops | pH 6-7
• Purvanchal (Clay): Rice/Pulses | pH 5.5-6.5
• Terai: High moisture crops | pH 6.5-7.5

**Current Schemes (2024):**
1. PM-KISAN: ₹6,000/yr direct benefit (Dial 155261)
2. UP Krishi Yantra Subsidy: 40-80% on farm tools
3. Free Soil Testing: Visit Krishi Vigyan Kendra
4. Mango MSP: ₹40/kg for Dussehri (AGMARK centers)

**Response Rules ({self.current_language.upper()}):**
1. Start with most critical information
2. Use bullet points (3-5) with emojis (🌱,⚠️,💧)
3. Include per bigha metrics (with ha in brackets)
4. Mention relevant schemes first with contact info
5. Highlight safety measures with ⚠️
6. Current season focus: {season} ({month_name})
7. If unclear, ask for district/crop specifics

**Technical Guidelines:**
- Sugarcane: 45-50kg seed/bigha | 120:60:60 NPK
- Wheat: HD-3226 variety | 100kg/bigha yield target
- Potato: 800-1000qtl/bigha | Store at 4°C
- Basmati: Pusa 1121 | 18-20 quintal/bigha
- Always mention pesticide waiting periods"""

    def get_up_season(self):
        month = self.current_date.month
        return "Rabi" if 11 <= month <= 4 else "Kharif"

    def build_conversation_context(self):
        return "\n".join([f"{msg['role']}: {msg['content']}" for msg in self.session_history])

    def get_chat_response(self, user_input):
        try:
            full_context = f"{self.base_prompt}\n\nConversation History:\n{self.build_conversation_context()}"
            
            response = client.chat.completions.create(
                model=GROQ_MODEL,
                messages=[{
                    "role": "user",
                    "content": f"{full_context}\nUser: {user_input}\nKrishiMitra:"
                }],
                temperature=0.2,
                max_tokens=750 if self.current_language == "hi" else 600,
                top_p=0.9,
                stop=["\nUser:", "###", "समाप्त"] if self.current_language == "hi" else ["\nUser:", "###"],
                stream=False
            )
            return self.clean_response(response.choices[0].message.content.strip())
        except Exception as e:
            return f"Error: {str(e)}. Please try again."

    def clean_response(self, text):
        """Remove redundant phrases and format properly"""
        replacements = {
            "नमस्ते!": "",
            "As an AI": "As KrishiMitra",
            "according to my training data": ""
        }
        for k, v in replacements.items():
            text = text.replace(k, v)
        return text.strip()

    def handle_user_input(self, user_input):
        if not user_input.strip():
            return "कृपया कृषि प्रश्न पूछें" if self.current_language == "hi" else "Please ask an agriculture question"
            
        self.session_history.append({"role": "user", "content": user_input})
        bot_response = self.get_chat_response(user_input)
        self.session_history.append({"role": "assistant", "content": bot_response})
        return bot_response

    def start_chat(self):
        greetings = {
            "en": f"\n🚜 Welcome to UP KrishiMitra! Ask about {self.get_up_season()} season farming",
            "hi": f"\n🌾 यूपी कृषि मित्र में आपका स्वागत है! {self.get_up_season()} मौसम की खेती के बारे में पूछें"
        }
        
        print(greetings[self.current_language])
        print("Type 'exit' to end | समाप्त करने के लिए 'exit' टाइप करें\n")
        
        while True:
            user_input = input("You: ")
            if user_input.lower() in ['exit', 'बाहर']:
                print("🚜 Happy farming! | शुभ खेती! 🌾")
                break
                
            response = self.handle_user_input(user_input)
            print(f"KrishiMitra: {response}")


# Define request model
class ChatRequest(BaseModel):
    user_input: str
    language: str = "en"  # Default to English

# Define API endpoint
@chatbot_router.post("/")
async def chat_with_bot(request: ChatRequest):
    chatbot = AgricultureChatbot(language=request.language)
    response = chatbot.handle_user_input(request.user_input)
    return {"response": response}

if __name__ == "__main__":
    chatbot = AgricultureChatbot()
    chatbot.start_chat()