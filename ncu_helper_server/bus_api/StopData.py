class StopData:
    def __init__(self, stop_name: str, stop_sequence: int, stop_status: int, next_bus_time: str):
        """
        公車站牌資訊
        :param stop_name: 站牌中文名稱
        :param stop_sequence: 站牌順序（0-index）
        :param stop_status: 1 - 正常, 2 - 不停靠, 3 - 末班駛離
        :param next_bus_time: 下次公車抵達此站牌的時間（ISO 8601 字串）
        """
        self.stop_name = stop_name
        self.stop_sequence = stop_sequence
        self.stop_status = ['正常', '不停靠', '末班駛離'][stop_status]
        self.next_bus_time = next_bus_time
