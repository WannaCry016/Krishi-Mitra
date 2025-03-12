import json
from groq import Groq
from datetime import datetime
from fastapi import FastAPI, APIRouter
from pydantic import BaseModel

cropplan_router = APIRouter()

GROQ_MODEL = "llama-3.3-70b-versatile"

# Initialize GROQ API client
client = Groq(api_key="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")

# Session string to hold entire conversation
session_history = "User-Bot Conversation History:\n"

crop_plan = {}

current_date = datetime.today()
date = current_date.strftime("%A, %B %d, %Y")


def chat_with_llm(user_input):
    """
    Process the user's input using LLM to determine the next action and provide responses.
    """
    global session_history
    session_history += f"User: {user_input}\n"

    prompt = (
        "Use clear, concise, and easy-to-understand language keep the response as short as possible and proper format. "
        "Guide the user by asking for necessary agricultural inputs and providing a detailed crop plan. "
        "The chatbot should cover all stages from soil preparation to harvesting. "
        "Ask for the following crucial parameters: "
        "'CropType': The type of crop the user wants to cultivate. "
        "'SoilType': The type of soil available. If unsure, guide the user on how to identify it. "
        "'LandArea': Total land area available for cultivation in acres or hectares. "
        "'Location': User's location to determine the climate and suitable crops. "
        "'WaterSource': Availability and type of irrigation. "
        "'Fertilizers': Any preferences or restrictions on fertilizers. "
        "'Pesticides': Any preferences or restrictions on pesticides. "
        "'Budget': Total budget for the entire farming process. "
        "If enough information is provided, generate a complete crop plan detailing soil preparation, sowing, irrigation schedules, fertilization, pest management, and harvesting. "
        "Once the user confirms they are satisfied with the plan, respond with 'OK PLAN' without any other sentence or explanation. Ensure that the response is in this exact format only.\n\n"
        f"Conversation:\n{session_history}"
    )

    response = client.chat.completions.create(
        model=GROQ_MODEL,
        messages=[{"role": "user", "content": prompt}],
        temperature=1,
        max_tokens=1024,
        top_p=1,
        stream=False
    )

    bot_response = response.choices[0].message.content.strip()
    session_history += f"Bot: {bot_response}\n"
    return bot_response


def parse_crop_details(bot_response):
    """
    Parse the crop details from the bot response into a dictionary.
    """
    global crop_plan
    try:
        bot_response = bot_response.strip()

        if not bot_response.startswith("{") or not bot_response.endswith("}"):
            raise ValueError("Bot response is not valid JSON.")

        crop_plan = json.loads(bot_response)

    except json.JSONDecodeError as e:
        print(f"Error parsing crop details: {e}")
        crop_plan = {}
    except ValueError as e:
        print(f"Error: {e}")
        crop_plan = {}


# Request body structure for the user's input
class UserInput(BaseModel):
    text: str


@cropplan_router.post("/")
def chatbot(input: UserInput):
    """
    Main chatbot loop to interact with the user.
    """
    global session_history
    print("Welcome to the Agriculture Chatbot! Type 'exit' to end the session.")

    while True:
        # user_input = input("You: ")
        user_input = input.text
        if user_input.lower() in ["exit", "quit"]:
            print("Goodbye! Happy farming!")
            break

        bot_response = chat_with_llm(user_input)

        if "OK PLAN" in bot_response.upper():
            prompt_for_details = (
                "Provide crop plan details strictly in a dictionary format as follows. Do not include any additional text or explanation, only the dictionary. The key names must be the same as provided in the following format and should be in double quotes:\n"
                "'CropType': Name of the crop, "
                "'SoilPreparation': Steps and methods for soil preparation, "
                "'Sowing': Recommended sowing techniques and timeline, "
                "'Irrigation': Irrigation schedule and methods, "
                "'Fertilization': Fertilizer types and application schedule, "
                "'PestManagement': Pest control methods and schedules, "
                "'Harvesting': Harvesting techniques and timeline.\n"
                f"Conversation:\n{session_history}"
            )

            response = client.chat.completions.create(
                model=GROQ_MODEL,
                messages=[{"role": "user", "content": prompt_for_details}],
                temperature=1,
                max_tokens=1024,
                top_p=1,
                stream=False
            )

            parse_crop_details(response.choices[0].message.content.strip())
            break
        else:
            print(f"Bot: {bot_response}")

        # Return the bot's response to the frontend
        return {"response": bot_response}


def main():
    chatbot()
    print("\nFinal Crop Plan:")
    print(json.dumps(crop_plan, indent=4))


if __name__ == "__main__":
    main()