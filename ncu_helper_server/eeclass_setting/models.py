from django.db import models
from django.urls import reverse


# Create your models here.


class LineUser(models.Model):
    line_user_id = models.CharField(max_length=255, unique=True, null=False, blank=False)
    notion_token = models.TextField(max_length=255, blank=True, default='')
    notion_template_id = models.TextField(max_length=255, blank=True, default='')
    eeclass_username = models.CharField(max_length=255, default='')
    eeclass_password = models.CharField(max_length=255, default='')

    class Meta:
        ordering = ['-line_user_id']

    # Methods
    def get_absolute_url(self):
        """Returns the url to access a particular instance of MyModelName."""
        return reverse('model-detail-view', args=[str(self.id)])

    def __str__(self):
        """String for representing the MyModelName object (in Admin site etc.)."""
        return self.line_user_id
