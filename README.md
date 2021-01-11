# Mod for code-server (linuxserver/docker-code-server)

![Build/Push (master)](https://github.com/ebrianne/docker-code-server-mod/workflows/Build/Push%20(master)/badge.svg?branch=master)

The [Linuxserver.io](https://docs.linuxserver.io/) community enables the possibility of personalizing docker containers via [mods](https://github.com/linuxserver/docker-mods). This image is a mod for the docker image of [code-server](https://github.com/linuxserver/docker-code-server). It installs zsh shell with several other tools:
* [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)
* [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
* [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
* [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

You can add custom binaries to ~/.local/bin

## Building
Build the container image `code-server-mod:latest`:

    docker build -t code-server-mod:latest .
## Image
Ready made images are hosted on Docker Hub. Use at your own risk:

    ebrianne/code-server-mod
## Usage

The use of the mod is made easy by the small script called at the start of the container in code-server.

In code-server docker arguments, set an environment variable 

    DOCKER_MODS=ebrianne/code-server-mod
### Docker CLI

```bash
docker run -d \
--name=code-server \
-e PUID=1000 \
-e PGID=1000 \
-e TZ=Europe/London \
-e PASSWORD=password `#optional` \
-e SUDO_PASSWORD=password `#optional` \
-e SUDO_PASSWORD_HASH= `#optional` \
-e PROXY_DOMAIN=code-server.my.domain `#optional` \
-e DOCKER_MODS=ebrianne/code-server-mod
-p 8443:8443 \
-v /path/to/appdata/config:/config \
--restart unless-stopped \
ghcr.io/linuxserver/code-server
```
### Docker-Compose

```yml
---
version: "3.0"
services:
  code-server:
    image: ghcr.io/linuxserver/code-server
    container_name: code-server
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - PASSWORD=password #optional
      - SUDO_PASSWORD=password #optional
      - SUDO_PASSWORD_HASH= #optional
      - PROXY_DOMAIN=code-server.my.domain #optional
      - DOCKER_MODS=ebrianne/code-server-mod
    volumes:
      - /path/to/appdata/config:/config
    ports:
      - 8443:8443
    restart: unless-stopped
```

### Kubernetes

```yml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: code-server
  namespace: default
  labels:
    app: code-server
spec:
  replicas: 1
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: code-server
  minReadySeconds: 5
  template:
    metadata:
      labels:
        app: code-server
    spec:
      containers:
      - name: code-server
        image: ghcr.io/linuxserver/code-server
        ports:
          - containerPort: 8443
        env:
          - name: PUID
            value: "1000"
          - name: PGID
            value: "1000"
          - name: TZ
            value: "Europe/Berlin"
          - name: PASSWORD
            valueFrom:
              secretKeyRef:
                name: code-server-secret
                key: password
          - name: SUDO_PASSWORD
            valueFrom:
              secretKeyRef:
                name: code-server-secret
                key: sudo_password
          - name: DOCKER_MODS
            value: "ebrianne/code-server-mod:latest"
        resources:
          requests:
            memory: "200Mi"
            cpu: 0.5
          limits:
            memory: "500Mi"
            cpu: 2
        volumeMounts:
        - name: config
          mountPath: /config
      volumes:
        - name: config
          persistentVolumeClaim:
            claimName: nfs-pvc-code-server
```