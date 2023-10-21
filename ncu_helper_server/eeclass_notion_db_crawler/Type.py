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
