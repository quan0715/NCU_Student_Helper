from typing import Dict
import aiohttp
from NotionBot import *
from NotionBot.base.Database import *
from NotionBot.object import *
from NotionBot.object.BlockObject import *
from NotionBot.NotionClient import Notion
from eeclass_bot.EEAsyncBot import EEAsyncBot
from eeclass_setting.models import LineUser

async def eeclass_test_login(account, password):
    async with aiohttp.ClientSession(connector=aiohttp.TCPConnector(ssl=False)) as session:
        bot = EEAsyncBot(session, account, password)
        return await bot.login()


async def eeclass_pipeline(user: LineUser):
    # TODO: update new version pipline
    async with aiohttp.ClientSession(connector=aiohttp.TCPConnector(ssl=False)) as session:
        bot = EEAsyncBot(session, user.eeclass_username, user.eeclass_password)
        result = await bot.login()
        if not result:
            return "login failed"
        reply_message: List[str] = []
        await bot.retrieve_all_course(check=True, refresh=True)
        # reply_message.append('\n'.join(str(c) for c in bot.courses_list))
        await bot.retrieve_all_bulletins()
        all_bulletins_detail = await bot.retrieve_all_bulletins_details()
        reply_message.append('\n'.join(f'公告：{str(b)}' for b in bot.bulletins_list))
        await bot.retrieve_all_homeworks()
        all_homework_detail = await bot.retrieve_all_homeworks_details()
        reply_message.append('\n'.join(f'作業：{str(h)}' for h in bot.homeworks_list))
        await bot.retrieve_all_material()
        all_material_detail = await bot.retrieve_all_materials_details()
        reply_message.append('\n'.join(f'教材：{str(m)}' for m in bot.material_list))
        notion_bot = Notion(user.notion_token)
        db = notion_bot.get_database(user.eeclass_db_id)
        await update_all_bulletin_info_to_notion_db(bot.bulletins_detail_list, db)
        await update_all_homework_info_to_notion_db(bot.homeworks_detail_list, db)
        await update_all_material_info_to_notion_db(bot.materials_detail_list, db)
        # print('\n'.join(reply_message))
        notion_db_url = f"https://www.notion.so/{user.eeclass_db_id.replace('-', '')}"
        notion_message = f"已更新到Notion DB\n{notion_db_url}\n---\n"
        return notion_message + '\n'.join(reply_message)


# async def eeclass_test(account, password, user: LineUser):
#     async with aiohttp.ClientSession(connector=aiohttp.TCPConnector(ssl=False)) as session:
#         bot = EEAsyncBot(session, account, password)
#         await bot.login()
#         await bot.retrieve_all_course(check=True, refresh=True)
#         await bot.retrieve_all_bulletins()
#         all_bulletins_detail = await bot.retrieve_all_bulletins_details()
#         await bot.retrieve_all_homeworks()
#         all_homework_detail = await bot.retrieve_all_homeworks_details()
#         await bot.retrieve_all_material()
#         all_material_detail = await bot.retrieve_all_materials_details()
#         notion_bot = Notion(user.notion_token)
#         db = notion_bot.get_database(user.eeclass_db_id)
#         await update_all_bulletin_info_to_notion_db(bot.bulletins_detail_list , db)
#         await update_all_homework_info_to_notion_db(bot.homeworks_detail_list, db)
#         await update_all_material_info_to_notion_db(bot.materials_detail_list, db)

def builtin_in_notion_template(db: Database, target):
    return BaseObject(
        parent=Parent(db),
        properties=Properties(
            Title=TitleValue(target['title']),
            Course=SelectValue(target['course']),
            ID=TextValue(target['ID']),
            Announce_Date=DateValue(NotionDate(**target['date'])),
            link=UrlValue(target['url']),
            label=SelectValue("公告")
        ),
        children=Children(
            CallOutBlock(f"發佈人 {target['發佈人']}  人氣 {target['人氣']}", color=Colors.Background.green),
            QuoteBlock(f"內容"),
            ParagraphBlock(target['content']["公告內容"]),
            ParagraphBlock(" "),
            QuoteBlock(f"連結"),
            *[ParagraphBlock(TextBlock(content=links['名稱'], link=links['連結'])) for links in
              target['content']['連結']],
            ParagraphBlock(" "),
            QuoteBlock(f"附件"),
            *[ParagraphBlock(TextBlock(content=links['名稱'], link=links['連結'])) for links in
              target['content']['附件']],
        ),
        icon=Emoji("🐶"),
    )


def homework_in_notion_template(db: Database, target):
    cover_file_url = "https://images.pexels.com/photos/13010695/pexels-photo-13010695.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
    children_list = []
    for key, value in target['content'].items():
        children_list.append(QuoteBlock(TextBlock(key.capitalize()), color=Colors.Text.red))
        if key == 'attach' or key == 'link':
            children_list.extend([
                BulletedBlock(TextBlock(content=a['title'], link=a['link'])) for a in value
            ])
        else:
            result = TextBlock.check_length_and_split(value)
            text = [TextBlock(r) for r in result] if result else [TextBlock(value)]
            children_list.append(ParagraphBlock(*text)),

        children_list.append(DividerBlock()),

    return BaseObject(
        parent=Parent(db),
        properties=Properties(
            Title=TitleValue(target['title']),
            Course=SelectValue(target['course']),
            ID=TextValue(target['ID']),
            Deadline=DateValue(NotionDate(**target['date'])),
            link=UrlValue(target['url']),
            label=SelectValue("作業")
        ),
        children=Children(*children_list),
        icon=Emoji("🐶"),
        cover=FileValue(cover_file_url)
    )

def material_in_notion_template(db: Database, target):
    complete_emoji = "✅" if target['已完成'] else "❎"
    return BaseObject(
        parent = Parent(db),
        properties = Properties(
            Title = TitleValue(target['title']),
            Course = SelectValue(target['course']),
            ID = TextValue(target['ID']),
            # Deadline = DateValue(NotionDate(**target['deadline'])),
            link = UrlValue(target['url']),
            label = SelectValue("教材")
        ),
        children = Children(
            # CallOutBlock(f"發佈人 {target['發佈者']}  觀看數 {target['觀看數']}  教材類型 {target['subtype']}", color=Colors.Background.green),
            CallOutBlock(f"教材類型 {target['subtype']}", color=Colors.Background.green),
            CallOutBlock(f"完成條件: {target['完成條件']}  進度: {target['完成度']}  已完成: " + complete_emoji, color=Colors.Background.red),

        )
    )

# just for testing

def get_id_col(db_col: List[Dict]) -> List[str]:
    return [p['properties']['ID']['rich_text'][0]['plain_text'] for p in db_col]


async def update_all_homework_info_to_notion_db(homeworks: List[Dict], db: Database):
    async with aiohttp.ClientSession(connector=aiohttp.TCPConnector(ssl=False)) as session:
        object_index = get_id_col(db.query())
        tasks = []
        for r in homeworks:
            if r['ID'] not in object_index:
                print(f"upload homework : {r['title']} to homework database")
                tasks.append(db.async_post(homework_in_notion_template(db, r), session))
        await asyncio.gather(*tasks)


async def update_all_bulletin_info_to_notion_db(bulletins: List[Dict], db: Database):
    async with aiohttp.ClientSession(connector=aiohttp.TCPConnector(ssl=False)) as session:
        object_index = get_id_col(db.query())
        tasks = []
        for r in bulletins:
            if r['ID'] not in object_index:
                print(f"upload bulletin : {r['title']} to bulletin database")
                tasks.append(db.async_post(builtin_in_notion_template(db, r), session))
        await asyncio.gather(*tasks)

async def update_all_material_info_to_notion_db(materials: List[Dict], db: Database):
    async with aiohttp.ClientSession(connector=aiohttp.TCPConnector(ssl=False)) as session:
        object_index = get_id_col(db.query())
        tasks = []
        for r in materials:
            if r != None and r['ID'] not in object_index:
                print(f"upload material : {r['title']} to material database")
                tasks.append(db.async_post(material_in_notion_template(db, r), session))
        await asyncio.gather(*tasks)