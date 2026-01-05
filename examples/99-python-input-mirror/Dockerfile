FROM python:3.11-slim

WORKDIR /app

ADD ./main.py .

RUN chmod +x main.py

ENTRYPOINT ["python3", "/app/main.py"]
