FROM rust:latest AS build

ENV RUSTFLAGS="-C target-feature=+crt-static"
ENV TARGET=x86_64-unknown-linux-musl

RUN apt-get update && apt-get install -y musl-tools

WORKDIR /
COPY . .

RUN rustup target add $TARGET \
    && cargo build --release --target $TARGET

FROM docker:24.0.6-dind-alpine3.18

COPY --from=build /target/x86_64-unknown-linux-musl/release/plogger /bin/plogger
