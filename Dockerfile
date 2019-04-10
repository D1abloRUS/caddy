FROM alpine

COPY Caddyfile /etc/caddy/Caddyfile

RUN apk --update upgrade \
    && apk add --no-cache --no-progress \
         tini \
         ca-certificates \
         curl \
    && apk add --no-cache --no-progress --virtual \
         .build_tools \
         wget \
         tar \
         bash \
    && wget -qO- https://getcaddy.com \
      | bash -s personal http.ratelimit \
    && apk del --purge .build_tools \
    && mkdir /.caddy \
    && rm -rf \
      /usr/share/doc \
      /usr/share/man \
      /tmp/* \
      /var/cache/apk/*

EXPOSE 80 443


ENTRYPOINT ["/sbin/tini", "--"]
CMD ["caddy", "-agree", "--conf", "/etc/caddy/Caddyfile"]
