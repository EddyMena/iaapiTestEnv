FROM python:3.9-slim-bullseye

ENV PYTHONUNBUFFERED 1

EXPOSE 8000
WORKDIR /app


RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        netcat \
        build-essential \
        libffi-dev \
        libssl-dev \
        python3-dev && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY poetry.lock pyproject.toml ./
RUN pip install poetry==1.0.* && \
    poetry config virtualenvs.create false && \
    poetry install --no-dev

COPY docker/entrypoint.sh docker/entrypoint.sh

COPY . ./

RUN chmod +x ./docker/entrypoint.sh

CMD alembic upgrade head && \
    uvicorn --host=0.0.0.0 app.main:app
