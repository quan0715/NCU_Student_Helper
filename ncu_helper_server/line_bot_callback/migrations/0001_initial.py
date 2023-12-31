# Generated by Django 4.2.2 on 2023-10-20 16:49

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='ChatStatus',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('line_user_id', models.CharField(max_length=255, unique=True)),
                ('status', models.TextField(blank=True, null=True)),
                ('propagation', models.BooleanField(default=False)),
            ],
            options={
                'ordering': ['-line_user_id'],
            },
        ),
    ]
