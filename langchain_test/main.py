from tools.hsr_tool import HsrSearchTool, HsrBookTool
from tools.date_tool import CurrentDateTool, DateTool

from dotenv import load_dotenv
from langchain.agents import initialize_agent, AgentType
from langchain.chat_models import ChatOpenAI
from langchain.schema import AIMessage
from langchain.tools.base import ToolException


load_dotenv()

llm = ChatOpenAI(model="gpt-3.5-turbo-0613", temperature=0.5)

tools = [
    CurrentDateTool(), DateTool(),
    HsrSearchTool(), HsrBookTool()
]

# agent = AgentExecutor(
#     tools=tools,
#     verbose=True,
#     handle_parsing_errors=True,
# )

agent = initialize_agent(
    tools=tools,
    llm=llm,
    agent=AgentType.OPENAI_FUNCTIONS,
    verbose=True,
)

# agent.run("幫我查詢下週三中午12點，從臺北到桃園的高鐵班次")
# agent.run("幫我訂購下週三中午12點，從臺北到桃園的高鐵票，直接訂購查到的第1筆資料")
result = agent.run("幫我查詢下週三中午12點，從花蓮到高雄的高鐵班次")
# except Exception as error:
#     print(llm([AIMessage(content=str(error), example=False)]))

# print(result)
