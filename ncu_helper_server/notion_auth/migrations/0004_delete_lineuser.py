# Generated by Django 4.2.2 on 2023-10-13 15:35

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('notion_auth', '0003_lineuser_eeclass_db_id'),
    ]

    operations = [
        migrations.DeleteModel(
            name='LineUser',
        ),
    ]
