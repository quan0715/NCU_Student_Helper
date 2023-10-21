from tools.exit_tool import ExitTool
from tools.hsr_tool import HsrSearchTool, HsrBookTool

from langchain.agents import initialize_agent, AgentType
from langchain.chat_models import ChatOpenAI
from langchain.memory import ConversationBufferMemory
from langchain.prompts import MessagesPlaceholder


tools = [ExitTool(), HsrSearchTool(), HsrBookTool()]
agent_kwargs = {
    "extra_prompt_messages": [MessagesPlaceholder(variable_name="hsr")],
}


class HsrBot:
    def __init__(self, openai_api_key: str, *, verbose: bool = False) -> None:
        llm = ChatOpenAI(model="gpt-3.5-turbo-0613",
                         temperature=0,
                         openai_api_key=openai_api_key)

        self.memory = ConversationBufferMemory(
            memory_key="hsr", return_messages=True)

        self.agent = initialize_agent(
            tools=tools,
            llm=llm,
            agent=AgentType.OPENAI_FUNCTIONS,
            verbose=verbose,
            agent_kwargs=agent_kwargs,
            handle_parsing_errors=True,
            memory=self.memory,
        )

    def reply(self, message: str) -> str:
        reply = self.agent.run(message)
        return reply
