FROM tut_base

COPY docker/uwsgi/uwsgi.ini /etc/uwsgi.ini
COPY docker/uwsgi/start.sh /start.sh

# setup.py script and code
COPY setup.py /app/
COPY src /app/src
WORKDIR /app

# do an in-place install
RUN python3 setup.py develop
