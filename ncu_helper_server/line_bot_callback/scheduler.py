

from enum import Enum
from apscheduler.schedulers.background import BackgroundScheduler

class SchedulerStatus(Enum):
    RUNNING=1
    STOP=2

__sys_scheduler = None
def get_scheduler():
    global __sys_scheduler
    if __sys_scheduler is None:
        __sys_scheduler = Scheduler()
    return __sys_scheduler

class Scheduler:
    def __init__(self):
        self.__scheduler = BackgroundScheduler()
        self.__scheduler.start()

    def pause(self):
        self.__scheduler.pause()

    def resume(self):
        self.__scheduler.resume()

    def add_jobs(self, *a, **b):
        """
        see apscheduler.schedulers.background.BackgroundScheduler
        """
        self.__scheduler.add_job(*a, **b)

    def remove_jobs(self, job_id):
        self.__scheduler.remove_job(job_id)

    def pause_jobs(self, job_id):
        self.__scheduler.pause_job(job_id)

    def resume_jobs(self, job_id):
        self.__scheduler.resume_job(job_id)
        
    def reschedule_job(self, job_id, *a, **b):
        """
        see apscheduler.schedulers.background.BackgroundScheduler
        """
        self.__scheduler.pause_job(job_id)
        self.__scheduler.reschedule_job(job_id, *a, **b)
        self.__scheduler.resume_job(job_id)

    def remove_all_jobs(self):
        self.__scheduler.remove_all_jobs()

    @property
    def status(self)->SchedulerStatus:
        if self.__scheduler.state==1:
            return SchedulerStatus.RUNNING
        else:
            return SchedulerStatus.STOP
        