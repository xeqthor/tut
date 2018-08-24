##################################
FROM buildpack-deps:bionic AS deps
##################################

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
                    python3-dev libgraphviz-dev \
 && rm -rf /var/lib/apt/lists/*

ENV PYTHON_PIP_VERSION 9.0.2
RUN bash -o pipefail -c "curl -fSL 'https://bootstrap.pypa.io/get-pip.py' | python3 - --no-cache-dir --upgrade pip==$PYTHON_PIP_VERSION"

COPY test-reqs.txt /
RUN mkdir /wheels \
 && pip wheel --no-cache --wheel-dir=/wheels -rtest-reqs.txt


################
FROM gctest_base
################

RUN mkdir /deps
COPY --from=deps /wheels/* /deps/
RUN pip install --force-reinstall --ignore-installed --upgrade --no-index --use-wheel --no-deps /deps/* \
 && rm -rf /deps


ARG LOCAL_USER
ARG LOCAL_UID
ARG LOCAL_GID
ENV LOCAL_USER=$LOCAL_USER

RUN echo "User name: $LOCAL_USER ($LOCAL_UID:$LOCAL_GID)" \
 && mkdir -p /home/app \
 && getent passwd $LOCAL_USER || ( \
      echo "Creating user: $LOCAL_USER ($LOCAL_UID:$LOCAL_GID)" && \
      groupadd --system --gid=$LOCAL_GID $LOCAL_USER && \
      useradd --system --home-dir=/home/app --gid=$LOCAL_GID --uid=$LOCAL_UID $LOCAL_USER \
    ) \
 && chown $LOCAL_USER /home/app

COPY docker/test/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# setup.py script and code
COPY setup.py /app/
COPY pytest.ini /app/
COPY src /app/src
COPY docker/test/.coveragerc /app/
WORKDIR /app

# do an in-place install
RUN python3 setup.py develop
