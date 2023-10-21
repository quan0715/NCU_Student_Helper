import requests

from ncu_helper_server.bus_api.Auth import Auth
from ncu_helper_server.bus_api.StopData import StopData


class BusAPI:
    @staticmethod
    def _get_one_way_bus_data(bus: str, direction: int) -> list[StopData]:
        """
        取得單向公車站牌資訊
        :param bus: 172, 173, 或 5035
        :param direction: 0-去程, 1-返程
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
                stop_status=r['StopStatus'],
                next_bus_time=r['NextBusTime'],
            )
            for i, r in enumerate(response)
        ]

    @staticmethod
    def _get_loop_bus_data(bus: str) -> list[StopData]:
        """
        取得循環公車站牌資訊
        :param bus: 132 或 133
        :return: 站牌資訊的串列
        """
        data = BusAPI._get_one_way_bus_data(bus, 0) + BusAPI._get_one_way_bus_data(bus, 1)[1:]
        return data

    @staticmethod
    def get_bus_data(bus: str, direction: int = None) -> list[StopData]:
        """
        根據路線自動取得公車站牌資訊
        :param bus: 132, 133, 172, 173, 或 5035
        :param direction: 132 跟 133 不需要；其餘 0-去程, 1-返程
        :return: 站牌資訊的串列
        """
        if bus in ['132', '133']:
            return BusAPI._get_loop_bus_data(bus)
        elif bus in ['172', '173', '5035']:
            if direction is None:
                raise ValueError('該車次方向不可為空')
            return BusAPI._get_one_way_bus_data(bus, direction)
        raise ValueError('該車次暫不支援')

    @staticmethod
    def get_all_stops(bus: str) -> set[str]:
        """
        取得該路線所有站牌名稱
        :return: 站牌名稱的集合
        """
        return {
            stop.stop_name
            for stop in BusAPI.get_bus_data(bus, 0) + BusAPI.get_bus_data(bus, 1)
        }
