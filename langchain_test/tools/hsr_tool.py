from datetime import datetime
from enum import Enum
from langchain.output_parsers import EnumOutputParser
from langchain.schema import OutputParserException
from langchain.tools import BaseTool
from langchain.tools.base import ToolException
from pydantic import BaseModel, Field, model_validator
from typing import Coroutine, Dict, Optional, Type, Any
from uuid import UUID
import requests


def _handle_error(error: ToolException) -> str:
    return str(error)


class Station(str, Enum):
    nangang = "南港"
    taipei = "台北"
    banqiao = "板橋"
    taoyuan = "桃園"
    hsinchu = "新竹"
    miaoli = "苗栗"
    taichung = "台中"
    changhua = "彰化"
    yunlin = "雲林"
    chiayi = "嘉義"
    tainan = "台南"
    zuoying = "左營"
    others = None


class HsrSearchInput(BaseModel):
    departure: datetime = Field(description="要搭乘高鐵的日期時間，轉換為 iso8601 的格式")
    station_from: Station = Field(description="出發站")
    station_to: Station = Field(description="抵達站")

    @model_validator(mode="before")
    def validate(cls, values: Dict[str, Any]):
        parser = EnumOutputParser(enum=Station)

        try:
            values["station_from"] = parser.parse(values["station_from"])
        except:
            values["station_from"] = Station.others

        try:
            values["station_to"] = parser.parse(values["station_to"])
        except:
            values["station_to"] = Station.others

        return values


class HsrSearchTool(BaseTool):
    name = "HSRSearchTool"
    description = "查詢指定時間、出發站、抵達站，取得一系列的高鐵班次與 Session ID，後續可以用 `HSRBookTool` 訂購高鐵票"
    args_schema: Optional[Type[BaseModel]] = HsrSearchInput

    def _run(self, departure: datetime, station_from: Station, station_to: Station) -> dict:
        request = requests.get(
            "https://api.squidspirit.com/hsr/search",
            json={
                "station_from": station_from.value,
                "station_to": station_to.value,
                "adult_count": 0,
                "child_count": 0,
                "heart_count": 0,
                "elder_count": 0,
                "student_count": 1,
                "departure": departure.isoformat()
            }
        )

        return request.json()

    def _arun(self, *args: Any, **kwargs: Any) -> Coroutine[Any, Any, Any]:
        raise Exception()


class HsrBookInput(BaseModel):
    # id_card_number: str = Field(description="身份證字號")
    # phone_number: str = Field(description="電話號碼")
    # email: str = Field(description="email")
    session_id: UUID = Field(description="Session ID")


class HsrBookTool(BaseTool):
    name = "HSRBookTool"
    description = "根據 `HSRSearchTool` 查詢到的班次與 Session ID，不需額外輸入個人資訊，訂購高鐵票，會得到付款資訊的圖片連結"
    args_schema: Optional[Type[BaseModel]] = HsrBookInput

    def _run(self, session_id: UUID) -> Any:
        request = requests.post(
            f"https://api.squidspirit.com/hsr/book/{session_id}",
            json={
                "selected_index": 0,
                "id_card_number": "X123456789",
                "phone": "0911222333",
                "email": "example@gmail.com",
                "debug": True,
            }
        )

        return request.json()

    def _arun(self, *args: Any, **kwargs: Any) -> Coroutine[Any, Any, Any]:
        raise Exception()


'''
{
  "station_from": "南港",
  "station_to": "南港",
  "adult_count": 0,
  "child_count": 0,
  "heart_count": 0,
  "elder_count": 0,
  "student_count": 0,
  "departure": "2019-08-24T14:15:22Z"
}
'''

'''
{
  "selected_index": 0,
  "id_card_number": "X123456789",
  "phone": "0911222333",
  "email": "example@gmail.com",
  "debug": True
}
'''
