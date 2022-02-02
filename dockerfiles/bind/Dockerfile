FROM alpine:latest
RUN apk --update --no-cache add bind bind-tools
RUN rm -rf /var/cache/apk/*
VOLUME /etc/bind
EXPOSE 53/udp
EXPOSE 53/tcp
EXPOSE 953/tcp
CMD ["named", "-c", "/etc/bind/named.conf", "-g", "-u", "named"]
