# Based upon https://github.com/Starbix/dockerimages/commit/b0c3e408263a90ee467d30aed0e855a610eb537a

FROM cirrusci/flutter:stable AS builder

RUN mkdir /fluffychat
WORKDIR /fluffychat

COPY ./ /fluffychat

RUN ./scripts/prepare-web.sh
RUN ./scripts/build-web.sh

FROM nginx:alpine

COPY --from=builder /fluffychat/build/web/ /usr/share/nginx/html
COPY --from=builder /fluffychat/config.sample.json /usr/share/nginx/html/config.json
