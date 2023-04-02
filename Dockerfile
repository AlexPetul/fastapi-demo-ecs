FROM python:3.10-alpine

COPY . .

RUN \
	pip install --upgrade pip setuptools-scm pipenv \
    && pipenv install --system --ignore-pipfile --dev \
    && rm -rf /root/.cache

WORKDIR /app

EXPOSE 8000

CMD uvicorn main:app --reload --host 0.0.0.0 --port 8000