FROM golang:1.11 as builder
WORKDIR /go/src/github.com/acoustid/docker-https-proxy/
COPY ./ ./
RUN go build ./cmd/docker_https_proxy

FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y dumb-init software-properties-common ssl-cert && \
    add-apt-repository ppa:certbot/certbot && \
    add-apt-repository ppa:vbernat/haproxy-1.9 && \
    apt-get update && \
    apt-get install -y certbot haproxy && \
    mkdir -p /etc/https-proxy/sites

COPY --from=builder /go/src/github.com/acoustid/docker-https-proxy/docker_https_proxy /usr/local/bin/

# EXPOSE 80
# EXPOSE 443
# EXPOSE 7932

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["docker_https_proxy"]