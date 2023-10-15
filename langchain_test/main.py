from tools.hsr_tool import HsrTool
from tools.date_tool import CurrentDateTool, DateTool

from dotenv import load_dotenv
from langchain.agents import initialize_agent, AgentType
from langchain.chat_models import ChatOpenAI


load_dotenv()

llm = ChatOpenAI(model="gpt-3.5-turbo-0613")

tools = [
    CurrentDateTool(), DateTool(),
    HsrTool(),
]

agent = initialize_agent(
    tools,
    llm,
    agent=AgentType.OPENAI_FUNCTIONS,
    verbose=True,
)

agent.run("幫我查詢下週三中午12點，從新竹到桃園的高鐵班次")
