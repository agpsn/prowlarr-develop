#!/bin/bash
clear; set -eu

echo $(cat ~/.ghcr-token) | docker login ghcr.io -u $(cat ~/.ghcr-user) --password-stdin &>/dev/null
GBRANCH=$(git branch | grep "*" | rev | cut -f1 -d" " | rev)
PVERSION=$(curl -sL "https://prowlarr.servarr.com/v1/update/${PROWLARR_BRANCH}/changes?runtime=netcore&os=linuxmusl" | jq -r '.[0].version')
APP=prowlarr

if [ $GBRANCH != "develop" ]; then git checkout develop; fi
	echo "Building and Pushing 'ghcr.io/agpsn/docker-$APP:$PVERSION'"
	docker build --quiet  --force-rm --rm --tag ghcr.io/agpsn/docker-$APP:develop --tag ghcr.io/agpsn/docker-$APP:$PVERSION -f ./Dockerfile.develop .
	docker push --quiet ghcr.io/agpsn/docker-$APP:develop; docker push --quiet ghcr.io/agpsn/docker-orowlarr:$PVERSION && docker image rm -f ghcr.io/agpsn/docker-$APP:$PVERSION
	git tag -f $PVERSION && git push origin $PVERSION -f --tags
	echo ""
	git add . && git commit -m "Updated" && git push --quiet
