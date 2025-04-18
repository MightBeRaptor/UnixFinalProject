FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

RUN apt-get update && apt-get install -y stress-ng

COPY . .
COPY templates/ templates/

CMD ["python", "app.py"]