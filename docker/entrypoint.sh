#!/usr/bin/env sh
set -ex

arg="$1"

HOST="${DB_HOST:-db}"
PORT="${DB_PORT:-5432}"

until nc -w 1 -z ${HOST} ${PORT}; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done
sleep 2
>&2 echo "Postgres is up - executing command"

alembic upgrade head
exec uvicorn --host 0.0.0.0 app.main:app