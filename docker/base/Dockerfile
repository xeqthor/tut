##################################
FROM buildpack-deps:bionic AS deps
##################################

ARG PROJECT_NAME
RUN if [ "$PROJECT_NAME" != "tut" ]; then \
    echo '\033[1;31m\n\tRefusing to build project. Please run `cp .env-PLATFORM .env` or similar first!\n'; exit 1; fi

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
                    python3-dev libgraphviz-dev \
                    curl \
 && rm -rf /var/lib/apt/lists/*

ENV PYTHON_PIP_VERSION 10.0.1
RUN bash -o pipefail -c "curl -fSL 'https://bootstrap.pypa.io/get-pip.py' | python3 - --no-cache-dir --upgrade pip==$PYTHON_PIP_VERSION"

COPY requirements.txt /
RUN mkdir /wheels \
 && pip wheel --no-cache --wheel-dir=/wheels -rrequirements.txt


##################
FROM ubuntu:bionic
##################

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ARG http_proxy
ARG https_proxy

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
                    locales software-properties-common \
                    ca-certificates \
                    strace gdb lsof locate net-tools htop iputils-ping dnsutils \
                    python3-distutils \
                    python3-dbg libpython3-dbg \
                    curl nano vim tree less telnet \
                    socat \
                    graphviz \
 && rm -rf /var/lib/apt/lists/*
RUN locale-gen en_US.UTF-8

ENV TERM=xterm
ENV PYTHON_PIP_VERSION 10.0.1
RUN bash -o pipefail -c "curl -fSL 'https://bootstrap.pypa.io/get-pip.py' | python3 - --no-cache-dir --upgrade pip==$PYTHON_PIP_VERSION"

RUN mkdir /deps
COPY --from=deps /wheels/* /deps/
RUN pip install --force-reinstall --ignore-installed --upgrade --no-index --no-deps /deps/* \
 && rm -rf /deps \
 && mkdir /app /var/app

# Create django user, will own the Django app
RUN adduser --no-create-home --disabled-login --group --system django
RUN chown -R django:django /app

ENV DJANGO_SETTINGS_MODULE=tut.settings