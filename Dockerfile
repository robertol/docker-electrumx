ARG VERSION=1.17.0

FROM python:3.10-alpine3.16
LABEL maintainer="Roberto Oliveira <smuxbr@gmail.com>"

ARG VERSION

COPY ./bin /usr/local/bin

RUN chmod a+x /usr/local/bin/* && \
    apk add --no-cache git build-base openssl && \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.16/main leveldb-dev && \
    pip install aiohttp pylru plyvel websockets uvloop && \
    git clone -b $VERSION https://github.com/spesmilo/electrumx.git && \
    cd electrumx && \
    pip install . && \
    apk del git build-base && \
    rm -rf /tmp/*

VOLUME ["/data"]
ENV HOME /data
ENV ALLOW_ROOT 1
ENV EVENT_LOOP_POLICY uvloop
ENV DB_DIRECTORY /data
ENV SERVICES=tcp://:50001,ssl://:50002,wss://:50004,rpc://0.0.0.0:8000
ENV SSL_CERTFILE ${DB_DIRECTORY}/electrumx.crt
ENV SSL_KEYFILE ${DB_DIRECTORY}/electrumx.key
ENV HOST ""
WORKDIR /data

EXPOSE 50001 50002 50004 8000

CMD ["init"]
