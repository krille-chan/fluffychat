### STAGE 1: Build do Web ###
FROM dart:stable AS builder

RUN apt-get update && apt-get install -y \
    curl wget jq build-essential git

RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
RUN flutter precache && flutter config --enable-web

WORKDIR /tmp
RUN wget https://github.com/mikefarah/yq/releases/download/v4.40.5/yq_linux_amd64.tar.gz \
 && tar -xzvf yq_linux_amd64.tar.gz \
 && mv yq_linux_amd64 /usr/bin/yq

COPY . /app
WORKDIR /app
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup component add rust-src --toolchain nightly-x86_64-unknown-linux-gnu

RUN ./scripts/prepare-web.sh
COPY config.* /app/
RUN flutter pub get
RUN flutter build web \
    --dart-define=FLUTTER_WEB_CANVASKIT_URL=canvaskit/ \
    --release --source-maps

### STAGE 2: Imagem Final ###
FROM nginx:1.25-alpine

# Criar usuário não-root
RUN addgroup -S app && adduser -S app -G app \
 && apk add --no-cache dumb-init \
 && rm -rf /var/cache/apk/*

# Criar diretórios esperados pelo nginx (com permissão apropriada)
RUN mkdir -p /var/cache/nginx/client_temp /var/run/nginx \
 && chown -R app:app /var/cache/nginx /var/run/nginx

# Limpar conteúdo padrão
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/build/web /usr/share/nginx/html
RUN chown -R app:app /usr/share/nginx/html

# Substituir configuração NGINX
COPY nginx.conf /etc/nginx/nginx.conf

# Usar usuário não-root
USER app

EXPOSE 80

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["nginx", "-g", "daemon off;"]
