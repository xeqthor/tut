FROM fin2018_base

RUN apt-get update \
 && apt-get install -yq --no-install-recommends nginx-core \
 && rm -rf /var/lib/apt/lists/*

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log \
 && echo "daemon off;" >> /etc/nginx/nginx.conf

ENV DJANGO_STATIC_ROOT=/var/static

COPY docker/nginx/nginx.conf /etc/nginx/sites-enabled/default
COPY docker/nginx/start.sh /

# setup.py script and code
COPY setup.py /app/
COPY src /app/src
WORKDIR /app

# do an in-place install
RUN python3 setup.py develop

RUN django-admin collectstatic --noinput -v0

EXPOSE 80
CMD ["/start.sh"]

