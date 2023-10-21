from typing import Any, List
from dotenv import load_dotenv
from langchain.agents import initialize_agent, AgentType
from langchain.chat_models import ChatOpenAI
from langchain.tools import BaseTool

from pydantic import BaseModel

load_dotenv()

class DefaultTool(BaseTool):
    name = "DefaultTool"
    description = "user this to response everything"
    return_direct = False

    def _run(self, *args: Any, **kwargs: Any) -> str:
        print('你在使用白癡回答器')
        return '此問題不在我的能力範圍內'
    
class LangChainAgent:
    def __init__(self, tools:List[BaseModel] = [], openai_api_key=None) -> None:
        self.tools = tools.copy()
        if openai_api_key is None:
            self.llm = ChatOpenAI(model="gpt-3.5-turbo-0613")
        else:
            self.llm = ChatOpenAI(model="gpt-3.5-turbo-0613", openai_api_key=openai_api_key)
        if len(tools)==0: 
            self.tools.append(DefaultTool())
        self.agent = None
        self.__update_agent()

    def __update_agent(self):
        self.agent = initialize_agent(
            self.tools,
            self.llm,
            agent=AgentType.OPENAI_FUNCTIONS,
            verbose=True,
        )
    
    def add_tools(self, tool: BaseModel):
        self.tools.append(tool)
        self.__update_agent()

    def run(self, message)->str:
        return self.agent.run('(請使用繁體中文回答)\n'+message)


agent = LangChainAgent()
while True:
    agent.run(input())
