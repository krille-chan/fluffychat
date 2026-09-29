# SPDX-FileCopyrightText: 2019-Present Christian Kußowski
# SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
#
# SPDX-License-Identifier: AGPL-3.0-or-later

FROM ubuntu:26.04 AS builder
RUN apt-get update && apt-get install -y curl wget git unzip xz-utils jq build-essential pkg-config libssl-dev ca-certificates

ARG TARGETARCH
WORKDIR /tmp
RUN wget https://github.com/mikefarah/yq/releases/download/v4.40.5/yq_linux_${TARGETARCH}.tar.gz
RUN tar -xzvf ./yq_linux_${TARGETARCH}.tar.gz
RUN mv yq_linux_${TARGETARCH} /usr/bin/yq

# Install the Flutter version defined in .tool_versions.yaml
WORKDIR /app
COPY .tool_versions.yaml /app/
RUN git clone --depth 1 --branch "$(yq '.environment.flutter' .tool_versions.yaml)" \
      https://github.com/flutter/flutter.git /opt/flutter
ENV PATH="/opt/flutter/bin:${PATH}"
RUN flutter precache --web

RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup component add rust-src --toolchain nightly

COPY . /app
RUN ./scripts/prepare-web.sh
COPY config.* /app/
RUN flutter pub get
RUN flutter build web --dart-define=FLUTTER_WEB_CANVASKIT_URL=canvaskit/ --release --source-maps

FROM docker.io/nginx:alpine
RUN rm -rf /usr/share/nginx/html
COPY --from=builder /app/build/web /usr/share/nginx/html
