from django.db import models
from django.urls import reverse


# Create your models here.

class ChatStatus(models.Model):
    line_user_id = models.CharField(max_length=255, unique=True)
    status = models.TextField(null=True, blank=True)
    propagation = models.BooleanField(null=False, blank=False, default=False)
    # eeclass_username = models.CharField(max_length=255)
    # eeclass_password = models.CharField(max_length=255)

    class Meta:
        ordering = ['-line_user_id']

    # Methods
    def get_absolute_url(self):
        """Returns the url to access a particular instance of MyModelName."""
        return reverse('model-detail-view', args=[str(self.id)])

    def __str__(self):
        """String for representing the MyModelName object (in Admin site etc.)."""
        return f'user: {self.line_user_id}, status: {self.status}'