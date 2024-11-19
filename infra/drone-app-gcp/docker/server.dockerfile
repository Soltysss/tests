FROM golang:latest AS builder

ARG VERSION=1.9.0
WORKDIR /
RUN git clone https://github.com/drone/drone.git && \
    cd drone && \
    git checkout v$VERSION

# Drone upstream build instructions
# HEAD: e609b197ed426084b27e4bf7d959bf75e552f45c
# ----------------------------------------------

WORKDIR /drone/cmd/drone-server
ENV GOOS=linux
ENV GOARCH=amd64
RUN go build -ldflags "-extldflags \"-static\"" -tags "nolimit"

FROM alpine:3.16 as alpine
RUN apk add -U --no-cache ca-certificates

FROM alpine:3.16
EXPOSE 80 443
VOLUME /data

RUN [ ! -e /etc/nsswitch.conf ] && echo 'hosts: files dns' > /etc/nsswitch.conf

ENV GODEBUG netdns=go
ENV XDG_CACHE_HOME /data
ENV DRONE_DATABASE_DRIVER sqlite3
ENV DRONE_DATABASE_DATASOURCE /data/database.sqlite
ENV DRONE_RUNNER_OS=linux
ENV DRONE_RUNNER_ARCH=amd64
ENV DRONE_SERVER_PORT=:80
ENV DRONE_SERVER_HOST=localhost

COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# End-of: Drone upstream build instructions

COPY --from=builder /drone/cmd/drone-server/drone-server /bin/

ENTRYPOINT ["/bin/drone-server"]