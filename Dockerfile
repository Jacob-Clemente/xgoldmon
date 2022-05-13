# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libosmocore-dev

## Add source code to the build stage.
ADD . /xgoldmon
WORKDIR /xgoldmon

## TODO: ADD YOUR BUILD INSTRUCTIONS HERE.
RUN make

#Package Stage
FROM --platform=linux/amd64 ubuntu:20.04

## TODO: Change <Path in Builder Stage>
COPY --from=builder /xgoldmon/xgoldmon /
COPY --from=builder /usr/lib/x86_64-linux-gnu/libosmocore.so.11 /usr/lib/x86_64-linux-gnu/libosmocore.so.11

COPY --from=builder /usr/lib/x86_64-linux-gnu/libtalloc.so.2 /usr/lib/x86_64-linux-gnu/libtalloc.so.2
