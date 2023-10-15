from datetime import datetime
from enum import Enum
from langchain.tools import BaseTool
from pydantic import BaseModel, Field
from typing import Optional, Type, Any
import requests


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


class HsrInput(BaseModel):
    departure: datetime = Field(
        ...,
        description="要搭乘高鐵的日期時間，轉換為 iso8601 的格式"
    )
    station_from: Station = Field(
        ...,
        description="出發站"
    )
    station_to: Station = Field(
        ...,
        description="抵達站"
    )


class HsrTool(BaseTool):
    name = "HSRTool"
    description = "如果想要查詢高鐵的班次，請使用它。"
    args_schema: Optional[Type[BaseModel]] = HsrInput
    return_direct = True

    def _run(self, departure: datetime, station_from: Station, station_to: Station) -> Any:
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
