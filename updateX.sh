#!/bin/bash
set -eu

echo $(cat ~/.ghcr-token) | docker login ghcr.io -u $(cat ~/.ghcr-user) --password-stdin &>/dev/null
GBRANCH=$(git branch | grep "*" | rev | cut -f1 -d" " | rev)

LVERSION=$(curl -sL "https://lidarr.servarr.com/v1/update/develop/changes?runtime=netcore&os=linuxmusl" | jq -r '.[0].version')
RVERSION=$(curl -sL "https://radarr.servarr.com/v1/update/develop/changes?runtime=netcore&os=linuxmusl" | jq -r '.[0].version')
SVERSION=$(curl -sL "https://services.sonarr.tv/v1/releases | jq -r "first(.[] | select(.branch==\"develop\") | .version)");
PVERSION=$(curl -sL "https://prowlarr.servarr.com/v1/update/develop/changes?runtime=netcore&os=linuxmusl" | jq -r '.[0].version')

LRELEASE=$()
RRELEASE=$()
SRELEASE=$()
PRELEASE=$()

APP=prowlarr

if [ $GBRANCH != "develop" ]; then git checkout develop; fi
	echo "Building and Pushing 'ghcr.io/agpsn/docker-$APP:$PVERSION'"
	docker build --quiet  --force-rm --rm --tag ghcr.io/agpsn/docker-$APP:develop --tag ghcr.io/agpsn/docker-$APP:$PVERSION -f ./Dockerfile.develop .
	docker push --quiet ghcr.io/agpsn/docker-$APP:develop; docker push --quiet ghcr.io/agpsn/docker-orowlarr:$PVERSION && docker image rm -f ghcr.io/agpsn/docker-$APP:$PVERSION
	git tag -f $PVERSION && git push origin $PVERSION -f --tags
	echo ""
	git add . && git commit -m "Updated" && git push --quiet
