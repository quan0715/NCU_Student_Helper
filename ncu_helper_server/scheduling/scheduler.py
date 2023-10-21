from enum import Enum
from apscheduler.schedulers.background import BackgroundScheduler

class SchedulerStatus(Enum):
    RUNNING=1
    STOP=2

class IntervalScheduler:
    """
    job_id is '\$\{user_id\}_\$\{job_func_id\}'
    """
    def __init__(self):
        self.__scheduler = BackgroundScheduler()
        self.__scheduler.start()

    def __get_job_id(self, user_id:str, job:callable):
        return f'{user_id}'

    def pause(self):
        self.__scheduler.pause()

    def resume(self):
        self.__scheduler.resume()

    def add_or_reschedule_job(self, user_id, job:callable, interval):
        """
        see apscheduler.schedulers.background.BackgroundScheduler
        """
        job_id = self.__get_job_id(user_id, job)
        if self.__scheduler.get_job(job_id):
            self.__scheduler.pause_job(job_id)
            self.__scheduler.reschedule_job(job_id, trigger='interval', seconds=interval)
            self.__scheduler.resume_job(job_id)
        else:
            self.__scheduler.add_job(job, trigger='interval', seconds=interval, id=job_id)
        

    def remove_job(self, user_id, job):
        job_id = self.__get_job_id(user_id, job)
        if self.__scheduler.get_job(job_id) is None:
            return False
        self.__scheduler.remove_job(job_id)
        return True

    def pause_job(self, user_id, job):
        job_id = self.__get_job_id(user_id, job)
        self.__scheduler.pause_job(job_id)

    def resume_job(self, user_id, job):
        job_id = self.__get_job_id(user_id, job)
        self.__scheduler.resume_job(job_id)

    def remove_all_jobs(self):
        self.__scheduler.remove_all_jobs()

    @property
    def status(self)->SchedulerStatus:
        if self.__scheduler.state==1:
            return SchedulerStatus.RUNNING
        else:
            return SchedulerStatus.STOP
        
__sys_scheduler = None
def get_scheduler()->IntervalScheduler:
    global __sys_scheduler
    if __sys_scheduler is None:
        __sys_scheduler = IntervalScheduler()
    return __sys_scheduler