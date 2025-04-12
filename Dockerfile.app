FROM python:3.11-slim

WORKDIR /app
COPY app/requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY app/ .
COPY app/templates/ templates/

CMD ["python", "app.py"]