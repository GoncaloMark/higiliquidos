FROM python:3.13-alpine

WORKDIR /app
COPY register-payments-app.py .

RUN pip install requests

CMD ["python", "register-payments-app.py"]
