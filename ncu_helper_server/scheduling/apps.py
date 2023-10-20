from django.apps import AppConfig


class SchedulingConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'scheduling'

    def ready(self):
        from .appModel import init_scheduler_tasks_from_db
        init_scheduler_tasks_from_db()

