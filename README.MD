![ ](https://img.shields.io/github/v/tag/agpsn/prowlarr-develop?color=00CCFF&label=:develop&style=plastic&logo=%20) 
 

```
docker run -d \
  --name=prowlarr \
  -e PUID=99 \
  -e PGID=100 \
  -e TZ=UTC \ #optional
  -e UMASK=022 \  #optional
  -p <hostport>:9696 \
  -v <hostconfigpath>:/config \
  --restart unless-stopped \  #optional
  ghcr.io/agpsn/docker-prowlarr:develop
```
