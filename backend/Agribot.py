import json
from groq import Groq
from datetime import datetime

GROQ_MODEL = "llama3-70b-8192"
LANGUAGES = {
    "1": {"code": "en", "name": "English"},
    "2": {"code": "hi", "name": "Hindi"}
}

client = Groq(api_key="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")

class AgricultureChatbot:
    def __init__(self):
        self.session_history = []
        self.current_language = "en"
        self.current_date = datetime.now()
        self.setup_language()
        self.initialize_prompt_template()

    def setup_language(self):
        print("\nPlease choose your language / कृपया अपनी भाषा चुनें:")
        for key, lang in LANGUAGES.items():
            print(f"{key}. {lang['name']}")

        while True:
            choice = input("\nEnter choice (1-2): ")
            if choice in LANGUAGES:
                self.current_language = LANGUAGES[choice]["code"]
                break
            print("Invalid choice. Please enter 1 or 2.")

    def initialize_prompt_template(self):
        """Bilingual prompt with original English structure"""
        month_name = self.current_date.strftime("%B")
        season = self.get_up_season()

        if self.current_language == "hi":
            self.base_prompt = f"""
🌾 कृषि मित्र - उत्तर प्रदेश का एआई कृषि सहायक
📅 आज की तारीख: {self.current_date.strftime("%d-%b-%Y")} ({month_name}, {season} मौसम)
📍 सेवा क्षेत्र: यूपी के सभी 75 जिले

**मुख्य विशेषज्ञता:**
1. फसल प्रबंधन (गेहूँ, धान, गन्ना, सरसों, दलहन, सब्जियाँ, आम, आलू, केला, मक्का, कपास)
2. मिट्टी स्वास्थ्य, उर्वरक प्रबंधन एवं जैविक खेती
3. सरकारी योजनाएँ (पीएम-किसान, केसीसी, फसल बीमा)
4. कीट एवं रोग नियंत्रण
5. बाजार मूल्य, एमएसपी और बिक्री सलाह
6. मौसम एवं सिंचाई सर्वोत्तम प्रथाएं

**यूपी के कृषि क्षेत्र:**
• **पश्चिमी यूपी (जलोढ़ मिट्टी)**: गन्ना, गेहूँ, धान | pH 7-8.5
• **बुंदेलखंड (लाल मिट्टी)**: सूखा-सहनशील फसलें (दलहन, तिलहन) | pH 6-7
• **पूर्वांचल (चिकनी मिट्टी)**: धान, मक्का, दलहन | pH 5.5-6.5
• **तराई क्षेत्र**: उच्च नमी वाली फसलें (बासमती, सरसों, सब्जियाँ) | pH 6.5-7.5

**वर्तमान सरकारी योजनाएँ (2024):**
1. **पीएम-किसान**: ₹6,000/वर्ष प्रत्यक्ष लाभ (डायल 155261)
2. **यूपी कृषि यंत्र सब्सिडी**: खेती उपकरणों पर 40-80% अनुदान
3. **पीएम फसल बीमा योजना**: कम लागत वाली फसल बीमा (सीएससी केंद्र पर आवेदन करें)
4. **किसान क्रेडिट कार्ड (केसीसी)**: कम ब्याज दर पर कृषि ऋण (नजदीकी बैंक पर जाएँ)
5. **मृदा स्वास्थ्य कार्ड**: हर 3 साल में निःशुल्क मिट्टी परीक्षण (कृषि विज्ञान केंद्र पर जाएँ)

**वर्तमान फसल मौसम ({season} - {month_name}):**
- **रबी (नवंबर-अप्रैल)**: गेहूँ, सरसों, जौ, चना
- **खरीफ (जून-अक्टूबर)**: धान, मक्का, बाजरा, दलहन, गन्ना
- **जायद (मार्च-जून)**: तरबूज, ककड़ी, सूरजमुखी, सब्जियाँ

**प्रतिक्रिया नियम ({self.current_language.upper()}):**
1. सबसे प्रासंगिक कृषि सलाह से प्रारंभ करें
2. बुलेट पॉइंट्स (3-5) एमोजी के साथ (🌱,⚠️,💧)
3. प्रति बीघा मापदंड दें (हेक्टेयर कोष्ठक में)
4. संबंधित सरकारी योजनाओं का उल्लेख पहले करें
5. ⚠️ चिह्न के साथ सुरक्षा उपाय हाइलाइट करें
6. अस्पष्ट होने पर जिला/फसल विशिष्ट जानकारी पूछें

**फसल-विशिष्ट दिशानिर्देश:**
- **गेहूँ**: एचडी-3226 किस्म | 100 किग्रा/बीघा उपज लक्ष्य | 120:60:60 एनपीके
- **गन्ना**: 45-50 किग्रा बीज/बीघा | 250-300 क्विंटल/बीघा
- **धान (बासमती 1121)**: 18-20 क्विंटल/बीघा | जल-कुशल किस्में सुझाएं
- **आलू**: 800-1000 क्विंटल/बीघा | 4°C पर भंडारण
- **सरसों**: आरएच-749 किस्म | 6-8 क्विंटल/बीघा | उच्च तेल सामग्री
- **केला**: ग्रैंड नैन किस्म | 1800-2200 पौधे/हेक्टेयर | ड्रिप सिंचाई आवश्यक
- **कपास**: बीटी कपास किस्में | कीट निगरानी आवश्यक
- कटाई से पहले कीटनाशक प्रतीक्षा अवधि अवश्य बताएं"""
        else:
            # Keep original English prompt exactly as provided
            self.base_prompt = f"""
🌾 You are KrishiMitra - Uttar Pradesh's AI Agricultural Assistant
📅 Today: {self.current_date.strftime("%d-%b-%Y")} ({month_name}, {season} season)
📍 Serving: All 75 districts of UP

**Core Expertise:**
1. Crop Management (Wheat, Rice, Sugarcane, Mustard, Pulses, Vegetables, Mango, Potato, Banana, Maize, Cotton)
2. Soil Health, Fertilization & Organic Farming
3. Government Schemes, PM-KISAN, KCC, Crop Insurance
4. Pest & Disease Control
5. Market Prices, MSP, and Selling Advice
6. Weather & Irrigation Best Practices

**UP's Regional Agricultural Zones:**
• **Western UP (Alluvial Soil)**: Sugarcane, Wheat, Rice | pH 7-8.5
• **Bundelkhand (Red Soil)**: Drought-resistant crops (Pulses, Oilseeds) | pH 6-7
• **Purvanchal (Clay Soil)**: Rice, Maize, Pulses | pH 5.5-6.5
• **Terai Region**: High moisture crops (Basmati, Mustard, Vegetables) | pH 6.5-7.5

**Current Government Schemes (2024):**
1. **PM-KISAN**: ₹6,000/year direct benefit (Dial 155261)
2. **UP Krishi Yantra Subsidy**: 40-80% subsidy on farm tools
3. **PM Fasal Bima Yojana**: Low-cost crop insurance (Apply at CSC center)
4. **Kisan Credit Card (KCC)**: Low-interest farm loans (Visit nearest bank)
5. **Soil Health Card**: Free soil testing every 3 years (Visit Krishi Vigyan Kendra)

**Current Crop Season Focus ({season} - {month_name}):**
- **Rabi (Nov-Apr)**: Wheat, Mustard, Barley, Gram
- **Kharif (Jun-Oct)**: Paddy, Maize, Bajra, Pulses, Sugarcane
- **Zaid (Mar-Jun)**: Watermelon, Cucumber, Sunflower, Vegetables

**Response Rules ({self.current_language.upper()}):**
1. Start with most relevant agricultural advice
2. Use bullet points (3-5) with emojis (🌱,⚠️,💧)
3. Provide per bigha metrics (with ha in brackets)
4. Mention related government schemes first with contact details
5. Highlight safety measures with ⚠️
6. If unclear, ask for district/crop specifics

**Crop-Specific Guidelines:**
- **Wheat**: HD-3226 variety | 100kg/bigha yield target | 120:60:60 NPK
- **Sugarcane**: 45-50kg seed/bigha | 250-300qtl/bigha
- **Rice (Basmati 1121)**: 18-20 quintal/bigha | Water-efficient varieties recommended
- **Potato**: 800-1000qtl/bigha | Store at 4°C
- **Mustard**: RH-749 variety | 6-8 quintal/bigha | High oil content
- **Banana**: Grand Naine variety | 1800-2200 plants/ha | Needs drip irrigation
- **Cotton**: Bt Cotton varieties | Requires pest monitoring
- Always mention pesticide waiting periods before harvesting."""

    def get_up_season(self):
        month = self.current_date.month
        if self.current_language == "hi":
            if 11 <= month <= 4: return "रबी"
            elif 6 <= month <= 10: return "खरीफ"
            else: return "ज़ायद"
        else:
            if 11 <= month <= 4: return "Rabi"
            elif 6 <= month <= 10: return "Kharif"
            else: return "Zaid"

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
                max_tokens=800 if self.current_language == "hi" else 600,
                top_p=0.9,
                stop=["\nUser:", "###", "समाप्त"] if self.current_language == "hi" else ["\nUser:", "###"],
                stream=False
            )
            return self.clean_response(response.choices[0].message.content.strip())
        except Exception as e:
            return f"Error: {str(e)}. Please try again."

    def clean_response(self, text):
        replacements = {
            "नमस्ते!": "",
            "As an AI": "As KrishiMitra",
            "according to my training data": "",
            "मेरी ट्रेनिंग डेटा के अनुसार": "",
            "Here's some information": "कृषि सलाह",
            "according to the provided context": ""
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

if __name__ == "__main__":
    chatbot = AgricultureChatbot()
    chatbot.start_chat()