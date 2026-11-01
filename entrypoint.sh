#!/bin/sh
set -e

# Fallback to Railway PG* variables if POSTGRES_* are unset
if [ -z "$POSTGRES_HOST" ] && [ -n "$PGHOST" ]; then
  POSTGRES_HOST="$PGHOST"
fi
if [ -z "$POSTGRES_PORT" ] && [ -n "$PGPORT" ]; then
  POSTGRES_PORT="$PGPORT"
fi
if [ -z "$POSTGRES_DATABASE" ] && [ -n "$PGDATABASE" ]; then
  POSTGRES_DATABASE="$PGDATABASE"
fi
if [ -z "$POSTGRES_USERNAME" ] && [ -n "$PGUSER" ]; then
  POSTGRES_USERNAME="$PGUSER"
fi
if [ -z "$POSTGRES_PASSWORD" ] && [ -n "$PGPASSWORD" ]; then
  POSTGRES_PASSWORD="$PGPASSWORD"
fi

# Fallback to parsing DATABASE_URL if POSTGRES_HOST is still unset
if [ -z "$POSTGRES_HOST" ] && [ -n "$DATABASE_URL" ]; then
  userpass="$(echo "$DATABASE_URL" | sed -E "s|.*://([^@]+)@.*|\1|")"
  POSTGRES_USERNAME="$(echo "$userpass" | cut -d: -f1)"
  POSTGRES_PASSWORD="$(echo "$userpass" | cut -d: -f2-)"
  hostportdb="$(echo "$DATABASE_URL" | sed -E "s|.*://[^@]+@([^/]+)/(.*)|\1 \2|")"
  hostport="$(echo "$hostportdb" | awk '{print $1}')"
  POSTGRES_DATABASE="$(echo "$hostportdb" | awk '{print $2}' | cut -d\? -f1)"
  POSTGRES_HOST="$(echo "$hostport" | cut -d: -f1)"
  POSTGRES_PORT="$(echo "$hostport" | cut -d: -f2)"
  [ "$POSTGRES_PORT" = "$POSTGRES_HOST" ] && POSTGRES_PORT="5432"
fi

export POSTGRES_HOST
export POSTGRES_PORT="${POSTGRES_PORT:-5432}"
export POSTGRES_DATABASE
export POSTGRES_USERNAME
export POSTGRES_PASSWORD

# Substitute environment variables into secrets.yaml at runtime
envsubst < /comentario/secrets.template.yaml > /comentario/secrets.yaml

# Execute Comentario
exec /comentario/comentario "$@"
