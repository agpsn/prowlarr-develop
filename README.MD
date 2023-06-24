![ ](https://ghcr-badge.egpl.dev/agpsn/docker-prowlarr/size?tag=develop&color=black&label=SIZE&ignore=latest)
![ ](https://ghcr-badge.egpl.dev/agpsn/docker-prowlarr/latest_tag?color=black&label=VERSION&ignore=latest)

```
docker run -d \
  --name=prowlarr \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=UTC \
  -e UMASK=022 \
  -p <hostport>:9696 \
  -v <hostconfigpath>:/config \
  --restart unless-stopped \
  ghcr.io/agpsn/docker-prowlarr:develop
```
