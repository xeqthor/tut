#!/bin/bash
set -eux
django-admin migrate --noinput
rm -f /var/shared/uwsgi.fifo
chmod g+rwx /var/shared
chgrp django /var/shared
exec uwsgi --ini /etc/uwsgi.ini "$@"
