from NotionBot import Notion
from NotionBot.base import Database


class EEClassNotionDBCrawler:
    def __init__(self, auth: str, page_id: str):
        """

        :param auth: Notion Integration Secret
        :param page_id: EEClass Notion Page ID

        :raises ValueError: 當有 Database 的標題名稱錯誤
        """
        self.notion = Notion(auth=auth)
        self.page = self.notion.get_page(page_id=page_id)
        self.bulletinDB: Database | None = None
        self.homeworkDB: Database | None = None
        self.materialDB: Database | None = None
        for child in self.page.retrieve_children()['results']:
            if child['type'] == 'child_database':
                database = self.notion.get_database(child['id'])
                match child['child_database']['title']:
                    case 'EECLASS 公告':
                        self.bulletinDB = database
                    case 'EECLASS 作業':
                        self.homeworkDB = database
                    case 'EECLASS 教材':
                        self.materialDB = database
        if self.bulletinDB is None or self.homeworkDB is None or self.materialDB is None:
            raise ValueError('Database 標題名稱錯誤')

    def get_bulletin(self):
        return [date['properties'] for date in self.bulletinDB.query()]

    def get_homework(self):
        return [date['properties'] for date in self.homeworkDB.query()]

    def get_material(self):
        return [date['properties'] for date in self.materialDB.query()]
