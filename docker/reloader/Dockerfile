FROM ubuntu:bionic

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
                    fswatch docker.io dumb-init \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY start.sh /

ENTRYPOINT ["dumb-init"]
CMD ["/start.sh"]
