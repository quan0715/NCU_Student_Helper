import requests

from ncu_helper_server.bus_api.Auth import Auth
from ncu_helper_server.bus_api.StopData import StopData


class BusAPI:
    @staticmethod
    def get_bus_data(bus: str, direction: int) -> list[StopData]:
        """
        取得單向公車站牌資訊
        :param bus: 172, 173, 或 5053
        :param direction: 0 - 去程, 1 - 返程
        :return: 站牌資訊的串列
        """
        api_url = f'https://tdx.transportdata.tw/api/basic/v2/Bus/EstimatedTimeOfArrival/City/Taoyuan/{bus}'
        params = {
            "$select": "StopName,EstimateTime,StopStatus,NextBusTime",
            "$filter": f"Direction eq {direction}",
            "$orderby": "StopSequence",
            "$format": "JSON"
        }
        response = requests.get(api_url, params=params, headers=Auth.get_headers()).json()
        return [
            StopData(
                stop_name=r['StopName']['Zh_tw'],
                stop_sequence=i,
                stop_status=r['StopStatus'],
                next_bus_time=r['NextBusTime'],
            )
            for i, r in enumerate(response)
        ]

    @staticmethod
    def get_circuit_bus_data(bus):
        """
        取得循環公車站牌資訊
        :param bus: 132 或 133
        :return: 站牌資訊的串列
        """
        if bus not in ['132', '133']:
            raise ValueError('Only buses \'132\' and \'133\' are accepted.')
        data = BusAPI.get_bus_data(bus, 0) + BusAPI.get_bus_data(bus, 1)[1:]
        return data
