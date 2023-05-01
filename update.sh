#!/bin/bash
set -eu

[ ! -d "/mnt/user/system/agpsn-github/prowlarr-develop" ] && echo "No repo!" && exit 1
cd "/mnt/user/system/agpsn-github/prowlarr-develop"

echo $(cat ~/.ghcr-token) | docker login ghcr.io -u $(cat ~/.ghcr-user) --password-stdin &>/dev/null

PVERSION=$(curl -sL "https://prowlarr.servarr.com/v1/update/develop/changes?runtime=netcore&os=linuxmusl" | jq -r '.[0].version')

echo "Building and Pushing 'ghcr.io/agpsn/docker-prowlarr:$PVERSION'"
docker build --quiet  --force-rm --rm --tag ghcr.io/agpsn/docker-prowlarr:develop --tag ghcr.io/agpsn/docker-prowlarr:$PVERSION -f ./Dockerfile.develop .
docker push --quiet ghcr.io/agpsn/docker-prowlarr:develop; docker push --quiet ghcr.io/agpsn/docker-prowlarr:$PVERSION && docker image rm -f ghcr.io/agpsn/docker-prowlarr:$PVERSION
git tag -f $PVERSION && git push --quiet origin $PVERSION -f --tags
git add . && git commit -m "Updated" && git push --quiet
echo ""
