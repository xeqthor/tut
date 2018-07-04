#!/bin/sh
set -eux
[ -n "${COLLECTSTATIC:-}" ] && django-admin collectstatic --noinput -v1
exec nginx
