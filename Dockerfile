FROM alpine:edge

ARG AUUID="ddc6e5cc-c0f1-4fc1-ab7c-12aba58d8bdc"
ARG ParameterSSENCYPT="chacha20-ietf-poly1305"


ADD etc/xray.json /tmp/xray.json
ADD etc/v2ray.ca.crt /etc/v2ray.ca.crt
ADD etc/v2ray.ca.key /etc/v2ray.ca.key
ADD start.sh /start.sh

RUN apk update && \
    apk add --no-cache ca-certificates wget && \
    wget -O Xray-linux-64.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip Xray-linux-64.zip && \
    chmod +x /xray && \
    rm -rf /var/cache/apk/* && \
    rm -f Xray-linux-64.zip && \
    cat /tmp/xray.json | sed -e "s/\$AUUID/$AUUID/g" -e "s/\$ParameterSSENCYPT/$ParameterSSENCYPT/g" >/xray.json

RUN chmod +x /start.sh

CMD /start.sh
