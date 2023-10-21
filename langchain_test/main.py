from dotenv import load_dotenv
import os

# Langchain entrance point
from bot import HsrBot


load_dotenv()

if __name__ == "__main__":
    bot = HsrBot(os.environ.get("OPENAI_API_KEY"))

    message = "我要訂高鐵票"
    while True:
        message = input(bot.reply(message))
