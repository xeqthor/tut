#!/bin/bash
set -eu
shopt -s extglob

while true; do
    echo -e "\033[1;32m[$(date -Iseconds)] Waiting for changes ...\033[0m"
    fswatch --recursive --extende --exclude '\.git|__pycache__|\.pyc|\.egg-info|___jb_' \
            --event Created \
            --event Updated \
            --event Removed \
            --event Renamed \
            --event MovedFrom \
            --event MovedTo \
            --event Link \
            --event Overflow \
            --one-event --monitor ${RELOADER_MONITOR:-inotify}_monitor src | \
    while read event; do
        if [[ $event == /app/src ]]; then
            echo -e "\033[1;33m[$(date -Iseconds)] Skipping bogus change in:\033[0m $event"
            continue
        fi
        echo -e "\033[1;36m[$(date -Iseconds)] Detected change in:\033[0m $event"
        if [[ $event =~ .*/static(/|$) ]]; then
            echo -e "\033[1;34m[$(date -Iseconds)] Running collectstatic ..."
            docker exec tut_nginx_1 rm -rf static/!(placeholder) || echo -e "\033[1;31m[$(date -Iseconds)] Failed to delete static directory!"
            docker exec tut_nginx_1 django-admin collectstatic --no-input || echo -e "\033[1;31m[$(date -Iseconds)] Failed to run collectstatic!"
        else
            echo -e "\033[1;34m[$(date -Iseconds)] Attempting uWSGI restart ..."
            echo w > /var/shared/uwsgi.fifo
        fi
        break
    done
done
