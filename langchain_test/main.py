from tools.hsr_tool import HsrSearchTool, HsrBookTool
from tools.date_tool import CurrentDateTimeTool, DateTimeTool

from dotenv import load_dotenv
from langchain.agents import initialize_agent, AgentType, OpenAIFunctionsAgent, AgentExecutor
from langchain.chat_models import ChatOpenAI
from langchain.memory import ConversationEntityMemory, ConversationBufferMemory
from langchain.prompts import MessagesPlaceholder
from langchain.schema import AIMessage
from langchain.tools.base import ToolException


load_dotenv()

llm = ChatOpenAI(model="gpt-3.5-turbo-0613", temperature=0)

tools = [
    # DateTimeTool(),
    HsrSearchTool(), HsrBookTool()
]

agent_kwargs = {
    "extra_prompt_messages": [MessagesPlaceholder(variable_name="hsr")],
}
memory = ConversationBufferMemory(memory_key="hsr", return_messages=True)

agent = initialize_agent(
    tools=tools,
    llm=llm,
    agent=AgentType.OPENAI_FUNCTIONS,
    verbose=True,
    agent_kwargs=agent_kwargs,
    handle_parsing_errors=True,
    memory=memory,
)

<<<<<<< HEAD
# ai = agent.run("我要訂高鐵")
ai = agent.run("zh_tw\n你好")
while True:
    instruction = input(ai + "\n> ")
    ai = agent.run(instruction)
=======
while True:
    agent.run(input())
>>>>>>> cabc971 (langchangAgent class)
