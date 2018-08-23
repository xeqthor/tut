FROM fin2018_base

COPY setup.py /app/
COPY src /app/src
WORKDIR /app

# do an in-place install
RUN python3 setup.py develop

