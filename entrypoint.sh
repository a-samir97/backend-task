#!/bin/bash

set -e

# If the database exists, migrate. Otherwise setup (create and migrate)
echo "Running database migrations..."

bundle exec rails db:migrate 2>/dev/null || bundle exec rails db:create db:migrate

echo "Finished running database migrations."

# Remove a potentially pre-existing server.pid for Rails.

echo "Deleting server.pid file..."
if [ -f tmp/pids/server.pid ]; then
    rm tmp/pids/server.pid
fi

exec bundle exec "$@"