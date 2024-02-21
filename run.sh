#!/bin/sh
set -ex
cd "$(dirname "$0")"

# . ./.env

docker rm -f dialog dialog-vscode

MEDIASOUP_ANNOUNCED_IP=$(curl "https://ipinfo.io/ip")

# --network="host" 사용하는 이유
# dialog는 40000-49999/tcp/udp를 사용한다.
# 그러나 포트 맵핑을 하면 시간이 오래 걸린다.
# 그리고 사용 중인 포트가 있을 가능성이 높다.
# 그래서 실행에 실패하다.
docker run --log-opt max-size=10m --log-opt max-file=3 -d --restart=always --name dialog \
--network="host" \
-v $(pwd)/certs/cert.pem:/app/certs/fullchain.pem \
-v $(pwd)/certs/key.pem:/app/certs/privkey.pem \
-v $(pwd)/certs/perms.pub.pem:/app/certs/perms.pub.pem \
-e MEDIASOUP_LISTEN_IP="0.0.0.0" \
-e MEDIASOUP_ANNOUNCED_IP=${MEDIASOUP_ANNOUNCED_IP} \
-e INTERACTIVE="false" \
dialog

docker logs dialog
