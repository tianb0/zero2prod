#!/usr/bin/env bash
set -x # print a trace of simple commands
set -eo pipefail # end script if any command or pipe exits with error

# check if psql and sqlx-cli are installed
# if ! [ -x "$(command -v psql)"]; then
#   echo >&2 "Error: psql is not installed."
#   exit 1
# fi

# if ! [ -x "$(command -v sqlx)"]; then
#   echo >&2 "Error: sqlx is not installed."
#   exit 1
# fi

# check if a custom env value has been set, otherwise use default
DB_USER=${POSTGRES_USER:=postgres}
DB_PASSWORD="${POSTGRES_PASSWORD:=password}"
DB_NAME="${POSTGRES_DB:=newsletter}"
DB_PORT="${POSTGRES_PORT:=5432}"
DB_HOST="${POSTGRES_HOST:=localhost}"

if [[ -z "${SKIP_DOCKER}" ]] 
then

  # launch postgres using Docker
  docker run \
    -e POSTGRES_USER=${DB_USER} \
    -e POSTGRES_PASSWORD=${DB_PASSWORD} \
    -e POSTGRES_DB=${DB_NAME} \
    -p "${DB_PORT}":5432 \
    -d postgres \
    postgres -N 1000 # increase the maximum number of connections for testing purposes

fi

# keep pinging postgres until it's ready to accept commands
export PGPASSWORD="${DB_PASSWORD}"
until psql -h "${DB_HOST}" -U "${DB_USER}" -p "${DB_PORT}" -d "postgres" -c '\q'; do
  >&2 echo "Postgres is still unavailable - sleeping"
  sleep 1
done

>&1 echo "Postgres is up and running on port ${DB_PORT}!"
>&1 echo "running migrations"

DATABASE_URL=postgres://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}
export DATABASE_URL
sqlx database create
sqlx migrate run

>&1 echo "migration done"
