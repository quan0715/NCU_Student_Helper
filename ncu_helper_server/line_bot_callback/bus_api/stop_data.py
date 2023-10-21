class StopData:
    def __init__(self, stop_name: str, stop_status: int, next_bus_time: str):
        """
        公車站牌資訊
        :param stop_name: 站牌中文名稱
        :param stop_status: 0-正常, 1-尚未發車, 2-交管不停靠, 3-末班車已過, 4-今日未營運
        :param next_bus_time: 下次公車抵達此站牌的時間（ISO 8601 字串）
        """
        self.stop_name = stop_name
        self.stop_status = ['正常', '尚未發車', '交管不停靠', '末班車已過', '今日未營運'][stop_status]
        self.next_bus_time = next_bus_time

    def __repr__(self):
        return str({
            'Stop Name': self.stop_name,
            'Stop Status': self.stop_status,
            'Next Bus Time': self.next_bus_time
        })
