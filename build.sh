#!/usr/bin/env bash

cd backend

pip install -r requirements.txt

python manage.py migrate

# Create superuser
python manage.py shell <<EOF
from django.contrib.auth import get_user_model
import os

User = get_user_model()

phone = os.environ.get("DJANGO_SUPERUSER_PHONE")
password = os.environ.get("DJANGO_SUPERUSER_PASSWORD")

if phone and password:
    if not User.objects.filter(phone_number=phone).exists():
        User.objects.create_superuser(phone_number=phone, password=password)
        print("Superuser created")
    else:
        print("Superuser already exists")
EOF

python manage.py collectstatic --no-input