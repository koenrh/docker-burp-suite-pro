#!/usr/bin/env sh

set -e

exec java "$JAVA_OPTS" -jar "$@"
