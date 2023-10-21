from .models import BasePool
from .langChainAgent import LangChainAgent
from enum import Enum
from langchain.memory import ConversationBufferMemory
from langchain.output_parsers import EnumOutputParser
from langchain.tools import BaseTool
from pydantic import BaseModel, Field, field_validator
from typing import Optional, Type, Any
from uuid import uuid4
from bus_api.api import BusAPI


def set_exit_state(user_id: str) -> None:
    from .chatBotModel import default_message
    from .chatBotExtension import jump_to
    jump_to(default_message, user_id, True)
    get_agent_pool_instance().remove(user_id)


def getExitTool(user_id: str):
    class ExitTool(BaseTool):
        name = "ExitTool"
        # description = "Useful when user want to exit or break this conversation in any situation."
        description = """
        Useful in the situations below:
        - The user has no high intention to book or search ticket. For example: '不查了', '不想要'
        - The user want to break or exit this conversation.
        - The topic of the conversation isn't highly related to bus.
        """

        def _run(self, *args: Any, **kwargs: Any) -> str:
            set_exit_state(user_id)
            return "The process exited successfully."
    return ExitTool()


class BusLine(str, Enum):
    line132 = "132"
    line133 = "133"
    line172 = "172"
    line173 = "173"
    other = None


class BusInfoInput(BaseModel):
    line: BusLine = Field(
        description="The bus line to search. must be in ['132', '133', '172', '173'].")
    stop: str = Field(
        description="The bus stop name to search.")
    direction: int = Field(
        description="If the bus is going to NCU(中央大學 or 中央), it should be 1; if the bus is leaving from NCU(中央大學 or 中央), it should be 0.")

    @field_validator("line", mode="before")
    def station_validator(cls, value):
        if value not in list(map(lambda x: x.value, BusLine)):
            value = BusLine.other
        return value


class BusInfoTool(BaseTool):
    name = "BusInfoTool"
    description = "Useful to get when the bus will arrive the bus stop. You have to ask the user '要搭哪條路線？', '要查哪個車站？', '是要前往中央大學還是離開？'."
    args_schema: Optional[Type[BaseModel]] = BusInfoInput

    def _run(self, line: BusLine, stop: str, direction: int) -> str:
        if line == BusLine.other:
            return f"Error! The `line` is not found, it should be in {list(map(lambda x: x.value, BusLine))}"
        stop_list = BusAPI.get_all_stops(line)

        parser = EnumOutputParser(
            enum=Enum("StopEnum", {"u_" + str(uuid4()): x for x in stop_list}))
        try:
            stop = parser.parse(stop).value
        except:
            return "Error! The `stop` is not exist in `line`"

        infos = BusAPI.get_bus_data(line, direction)
        for info in infos:
            if info.stop_name == stop:
                return f"The bus will arrive at {info.next_bus_time}, and the satus is {info.stop_status}"

        return "Error! Cannot find the bus info."


class BusAgentPool(BasePool):
    def add(self, user_id: str) -> LangChainAgent:
        agent = self.pool[user_id] = LangChainAgent(
            tools=[getExitTool(user_id), BusInfoTool()],
            memory=ConversationBufferMemory(
                memory_key="bus", return_messages=True),
        )
        return agent


__bus_agent_pool_instance = BusAgentPool()


def get_agent_pool_instance():
    return __bus_agent_pool_instance
