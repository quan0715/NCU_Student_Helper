from typing import Any, List
from django.conf import settings
from langchain.agents import initialize_agent, AgentType
from langchain.chat_models import ChatOpenAI
from langchain.memory import ConversationBufferMemory
from langchain.prompts import MessagesPlaceholder
from langchain.tools import BaseTool

from pydantic import BaseModel


class DefaultTool(BaseTool):
    name = "DefaultTool"
    description = "user this to response everything"
    return_direct = False

    def _run(self, *args: Any, **kwargs: Any) -> str:
        print('你在使用白癡回答器')
        return '此問題不在我的能力範圍內'


class LangChainAgent:
    def __init__(self, tools: List[BaseModel] = [], memory: ConversationBufferMemory = None, timeout = 20, openai_api_key=None) -> None:
        self.tools = tools.copy()
        if openai_api_key is None:
            self.llm = ChatOpenAI(model="gpt-3.5-turbo-0613",
                                  openai_api_key=settings.OPEN_AI_API_KEY)
        else:
            self.llm = ChatOpenAI(model="gpt-3.5-turbo-0613",
                                  openai_api_key=openai_api_key)
        if len(tools) == 0:
            self.tools.append(DefaultTool())

        self.memory = memory
        self.agent_kwargs = {
            "extra_prompt_messages": [MessagesPlaceholder(variable_name=self.memory.memory_key)]
        } if self.memory is not None else None
        
        self.timeout = timeout

        self.agent = None
        self.__update_agent()

    def __update_agent(self):
        self.agent = initialize_agent(
            self.tools,
            self.llm,
            agent=AgentType.OPENAI_FUNCTIONS,
            verbose=True,
            max_execution_time=self.timeout if self.timeout > 0 else None,
            agent_kwargs=self.agent_kwargs,
            memory=self.memory
        )

    def add_tool(self, tool: BaseTool):
        self.tools.append(tool)
        self.__update_agent()

    def add_all_tools(self, tools: list[BaseTool]):
        self.tools.extend(tools)
        self.__update_agent()

    def run(self, message) -> str:
        print('agent.run')
        return self.agent.run('#zh_tw\n'+message)


__agent = LangChainAgent()


def get_system_agent():
    return __agent
