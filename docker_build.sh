VERSION=$(date "+%Y%m%d%H%M%S")

docker build -t docker.radiohemp.buzzlabs.com.br/apps/fluffychat:$VERSION .
docker push docker.radiohemp.buzzlabs.com.br/apps/fluffychat:$VERSION

echo docker.radiohemp.buzzlabs.com.br/apps/fluffychat:$VERSION
