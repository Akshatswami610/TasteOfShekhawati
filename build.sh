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
    user, created = User.objects.get_or_create(phone_number=phone)

    user.set_password(password)  # IMPORTANT (hash password)
    user.is_staff = True
    user.is_superuser = True
    user.first_name = "Admin"
    user.last_name = "User"
    user.save()

    print("Superuser fixed/updated")
EOF

python manage.py collectstatic --no-input