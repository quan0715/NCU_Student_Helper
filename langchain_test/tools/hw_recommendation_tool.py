from langchain.tools import BaseTool
from NotionBot import *
from NotionBot.base.Database import *
# from ncu_helper_server.eeclass_notion_db_crawler.EEClassNotionDBCrawler import EEClassNotionDBCrawler

from typing import Any, Optional, Type
from pydantic import BaseModel, Field
from langchain.prompts import PromptTemplate
from langchain.output_parsers import PydanticOutputParser
import datetime
import os
from fuzzywuzzy import fuzz
import aiohttp
from datetime import datetime, timezone, timedelta, date
from dotenv import load_dotenv

from NotionBot import Notion
from NotionBot.base import Database

from NotionBot import Notion
from NotionBot.base import Database
import enum, random
# from ncu_helper_server.eeclass_notion_db_crawler.Type import Bulletin, Homework, Material

import NotionBot


class Bulletin:
    def __init__(self, announce_date: NotionBot.object.DateValue, content: str, course: str, id: str, link: str,
                 title: str, read_check: bool, created_time: str, last_edited_time: str, details: dict):
        self.announce_date = announce_date
        self.content = content
        self.course = course
        self.id = id
        self.link = link
        self.title = title
        self.read_check = read_check
        self.created_time = created_time
        self.last_edited_time = last_edited_time
        self.details = details

    def __repr__(self):
        return str({
            'announce_date': self.announce_date,
            'content': self.content,
            'course': self.course,
            'id': self.id,
            'link': self.link,
            'title': self.title,
            'read_check': self.read_check,
            'created_time': self.created_time,
            'last_edited_time': self.last_edited_time,
            'details': self.details
        })


class Homework:
    def __init__(self, content: str, course: str, deadline: NotionBot.object.DateValue, homework_type: str, id: str,
                 link: str, status: str, submission: int, title: str, user_status: str, read_check: bool,
                 created_time: str, last_edited_time: str, details: dict):
        self.content = content
        self.course = course
        self.deadline = deadline
        self.homework_type = homework_type
        self.id = id
        self.link = link
        self.status = status
        self.submission = submission
        self.title = title
        self.user_status = user_status
        self.read_check = read_check
        self.created_time = created_time
        self.last_edited_time = last_edited_time
        self.details = details

    def __repr__(self):
        return str({
            'content': self.content,
            'course': self.course,
            'deadline': self.deadline,
            'homework_type': self.homework_type,
            'id': self.id,
            'link': self.link,
            'status': self.status,
            'submission': self.submission,
            'title': self.title,
            'user_status': self.user_status,
            'read_check': self.read_check,
            'created_time': self.created_time,
            'last_edited_time': self.last_edited_time,
            'details': self.details
        })


class Material:
    def __init__(self, announcer: str, content: str, course: str, goal: str, id: str, link: str, material_type: str,
                 read_time: str, study_status: str, title: str, views: int, read_check: bool, created_time: str,
                 last_edited_time: str, details: dict):
        self.announcer = announcer
        self.content = content
        self.course = course
        self.goal = goal
        self.id = id
        self.link = link
        self.material_type = material_type
        self.read_time = read_time
        self.study_status = study_status
        self.title = title
        self.views = views
        self.read_check = read_check
        self.created_time = created_time
        self.last_edited_time = last_edited_time
        self.details = details

    def __repr__(self):
        return str({
            'announcer': self.announcer,
            'content': self.content,
            'course': self.course,
            'goal': self.goal,
            'id': self.id,
            'link': self.link,
            'material_type': self.material_type,
            'read_time': self.read_time,
            'study_status': self.study_status,
            'title': self.title,
            'views': self.views,
            'read_check': self.read_check,
            'created_time': self.created_time,
            'last_edited_time': self.last_edited_time,
            'details': self.details
        })


class EEClassNotionDBCrawler:
    def __init__(self, auth: str, page_id: str):
        """

        :param auth: Notion Integration Secret
        :param page_id: EEClass Notion Page ID

        :raises ValueError: 當有 Database 的標題名稱錯誤
        """
        self._notion = Notion(auth=auth)
        self._page = self._notion.get_page(page_id=page_id)
        self._bulletinDB: Database | None = None
        self._homeworkDB: Database | None = None
        self._materialDB: Database | None = None
        for child in self._page.retrieve_children()['results']:
            if child['type'] == 'child_database':
                database = self._notion.get_database(child['id'])
                match child['child_database']['title']:
                    case 'EECLASS 公告':
                        self._bulletinDB = database
                    case 'EECLASS 作業':
                        self._homeworkDB = database
                    case 'EECLASS 教材':
                        self._materialDB = database
        if self._bulletinDB is None or self._homeworkDB is None or self._materialDB is None:
            raise ValueError('Database 標題名稱錯誤')

    def _get_details(self, data: dict) -> dict:
        details = {}
        quote, paragraph = None, None
        for block in self._notion.get_page(data['id']).retrieve_children()['results']:
            if block['type'] == 'quote':
                quote = block['quote']['rich_text'][0]['plain_text']
            elif block['type'] == 'paragraph':
                paragraph = block['paragraph']['rich_text'][0]['plain_text']
            if quote is not None and paragraph is not None:
                details[quote] = paragraph
        return details

    def get_bulletin(self) -> list[Bulletin]:
        bulletins = []
        for data in self._bulletinDB.query():
            bulletins.append(Bulletin(
                announce_date=data['properties']['Announced_Date'],
                content=data['properties']['Content']['rich_text'][0]['plain_text'],
                course=data['properties']['Course']['select']['name'],
                id=data['properties']['ID']['rich_text'][0]['plain_text'],
                link=data['properties']['Link']['url'],
                title=data['properties']['Title']['title'][0]['plain_text'],
                read_check=data['properties']['read_check']['checkbox'],
                created_time=data['properties']['建立時間']['created_time'],
                last_edited_time=data['properties']['更新時間']['last_edited_time'],
                details=self._get_details(data)
            ))
        return bulletins

    def get_homework(self) -> list[Homework]:
        homeworks = []
        for data in self._homeworkDB.query():
            homeworks.append(Homework(
                content=data['properties']['Content']['rich_text'][0]['plain_text'],
                course=data['properties']['Course']['select']['name'],
                deadline=data['properties']['Deadline']['date'],
                homework_type=data['properties']['Homework_Type']['select']['name'],
                id=data['properties']['ID']['rich_text'][0]['plain_text'],
                link=data['properties']['Link']['url'],
                status=data['properties']['Status']['select']['name'],
                submission=data['properties']['Submission']['number'],
                title=data['properties']['Title']['title'][0]['plain_text'],
                user_status=data['properties']['User_Status']['status']['name'],
                read_check=data['properties']['read_check']['checkbox'],
                created_time=data['properties']['建立時間']['created_time'],
                last_edited_time=data['properties']['更新時間']['last_edited_time'],
                details=self._get_details(data)
            ))
        return homeworks

    def get_material(self) -> list[Material]:
        materials = []
        for data in self._materialDB.query():
            materials.append(Material(
                announcer=data['properties']['Announcer']['rich_text'][0]['plain_text'],
                content=data['properties']['Content']['rich_text'][0]['plain_text'],
                course=data['properties']['Course']['select']['name'],
                goal=data['properties']['Goal']['rich_text'][0]['plain_text'],
                id=data['properties']['ID']['rich_text'][0]['plain_text'],
                link=data['properties']['Link']['url'],
                material_type=data['properties']['Material_Type']['select']['name'],
                read_time=data['properties']['Read_Time']['rich_text'][0]['plain_text'],
                study_status=data['properties']['Study_Status']['select']['name'],
                title=data['properties']['Title']['title'][0]['plain_text'],
                views=data['properties']['Views']['number'],
                read_check=data['properties']['read_check']['checkbox'],
                created_time=data['properties']['建立時間']['created_time'],
                last_edited_time=data['properties']['更新時間']['last_edited_time'],
                details=self._get_details(data)
            ))
        return materials

    def get_all_courses(self) -> set[str]:
        return {
            data['properties']['Course']['select']['name']
            for data in self._bulletinDB.query() + self._homeworkDB.query() + self._materialDB.query()
        }


