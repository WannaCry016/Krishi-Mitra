# import json
# from groq import Groq
# from datetime import datetime
# from fastapi import APIRouter
# from pydantic import BaseModel

# chatbot_router = APIRouter()

# GROQ_MODEL = "llama-3.3-70b-versatile"

# # Initialize GROQ API client
# client = Groq(api_key="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")

# # Session string to hold entire conversation
# session_history = "User-Bot Conversation History:\n"

# current_date = datetime.today()
# date = current_date.strftime("%A, %B %d, %Y")

# def chat_with_llm(user_input):
#     """
#     Process the user's input using LLM to provide responses and guidance.
#     """
#     global session_history
#     session_history += f"User: {user_input}\n"

#     prompt = (
#         "Act as an agriculture expert chatbot. Provide concise, practical, and short to the point relevant answers "
#         "to farming-related queries. Support queries about crop selection, soil health, irrigation, "
#         "weather conditions, fertilizers, pest control, market trends, and other general agriculture topics. "
#         "Ensure the responses are clear and actionable.\n\n"
#         f"Conversation:\n{session_history}"
#     )

#     response = client.chat.completions.create(
#         model=GROQ_MODEL,
#         messages=[{"role": "user", "content": prompt}],
#         temperature=1,
#         max_tokens=1024,
#         top_p=1,
#         stream=False
#     )

#     bot_response = response.choices[0].message.content.strip()
#     session_history += f"Bot: {bot_response}\n"
#     return bot_response

# # Request body structure for the user's input
# class UserInput(BaseModel):
#     text: str

# @chatbot_router.post("/")
# def chatbot(input: UserInput):
#     print(input)
#     """
#     Main chatbot loop for user interaction.
#     """
#     global session_history
#     print("Welcome to the Agriculture Chatbot! Ask me anything related to farming. Type 'exit' to end the session.")

#     # while True:
#     #     # user_input = input("You: ")
#     #     user_input = input.text
#     #     if user_input.lower() in ["exit", "quit"]:
#     #         print("Goodbye! Happy farming!")
#     #         break

#     #     bot_response = chat_with_llm(user_input)
#     #     print(f"Bot: {bot_response}")

#     user_input = input.text  # Get input from API request
#     if user_input.lower() in ["exit", "quit"]:
#         print("Goodbye! Happy farming!")
#         return {"response": "Goodbye! Happy farming!"}

#     bot_response = chat_with_llm(user_input)

#     # Return the bot's response to the frontend
#     return {"response": bot_response}

# if __name__ == "__main__":
#     chatbot()