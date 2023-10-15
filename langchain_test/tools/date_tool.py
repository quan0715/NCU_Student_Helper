from datetime import datetime, timedelta
from typing import Any, Optional, Type
from langchain.tools import BaseTool
from pydantic import BaseModel, Field


class DateInput(BaseModel):
    current: datetime = Field(
        ...,
        description="現在的日期時間，以 iso8601 的格式表示"
    )
    delta: timedelta = Field(
        ...,
        description="目標時間與現在時間的差，deltatime 以 iso8601 的格式表示"
    )


class CurrentDateTool(BaseTool):
    name = "CurrentDateTool"
    description = "直接取得現在的「日期」、「時間」與「星期」"
    return_direct = False

    def _run(self, *args: Any, **kwargs: Any) -> str:
        return datetime.now().strftime("%c")


class DateTool(BaseTool):
    name = "DateTool"
    description = "根據當前的 datetime，取得目標「日期」、「時間」與「星期」"
    args_schema: Optional[Type[BaseModel]] = DateInput
    return_direct = False

    def _run(self, current: datetime, delta: timedelta) -> str:
        return (current + delta).strftime("%c")
