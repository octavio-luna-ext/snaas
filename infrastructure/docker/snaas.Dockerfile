FROM alpine:3.5
MAINTAINER Tapglue "docker@tapglue.com"

ARG CONSOLE_BINARY
ARG GATEWAY_HTTP_BINARY
ARG SIMS_BINARY

RUN echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

RUN apk add --update ca-certificates && rm -rf /var/cache/apk/*

ADD infrastructure/certs/self/self.crt /tapglue/self.crt
ADD infrastructure/certs/self/self.key /tapglue/self.key

ADD $CONSOLE_BINARY /tapglue/console
ADD $GATEWAY_HTTP_BINARY /tapglue/gateway-http
ADD $SIMS_BINARY /tapglue/sims

RUN chmod +x /tapglue/console /tapglue/gateway-http /tapglue/sims

