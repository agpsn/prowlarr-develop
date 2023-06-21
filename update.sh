#!/bin/bash
set -eu

PVERSION=$(curl -sL "https://prowlarr.servarr.com/v1/update/develop/changes?runtime=netcore&os=linuxmusl" | jq -r '.[0].version')

echo $(cat ../.token) | docker login ghcr.io -u $(cat ../.user) --password-stdin &>/dev/null

echo "Updating Prowlarr: v$PVERSION"
docker build --quiet --force-rm --rm --tag ghcr.io/agpsn/docker-prowlarr:develop --tag ghcr.io/agpsn/docker-prowlarr:$PVERSION -f ./Dockerfile.develop .
git tag -f $PVERSION && git push --quiet origin $PVERSION -f --tags
git add . && git commit -m "Updated" && git push --quiet
docker push --quiet ghcr.io/agpsn/docker-prowlarr:develop; docker push --quiet ghcr.io/agpsn/docker-prowlarr:$PVERSION && docker image rm -f ghcr.io/agpsn/docker-prowlarr:$PVERSION
echo ""
