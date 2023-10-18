from django.db import models
from django.urls import reverse


class SchedulingData(models.Model):
    line_user_id = models.CharField(max_length=255, unique=True, null=False, blank=False)
    is_auto_update: models.BooleanField(null=False, blank=False, default=False)
    scheduling_time: models.IntegerField(null=10, blank=10, default=10)

    

    class Meta:
        ordering = ['-line_user_id']

    # Methods
    def get_absolute_url(self):
        """Returns the url to access a particular instance of MyModelName."""
        return reverse('model-detail-view', args=[str(self.id)])

    def __str__(self):
        """String for representing the MyModelName object (in Admin site etc.)."""
        return self.line_user_id
