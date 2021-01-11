FROM lsiobase/alpine:3.12 as buildstage

ENV HELM_VERSION=3.4.2
ENV ARCH=amd64
ENV OS=linux
ENV DOCKER_VERSION=20.10.2
ENV HADOLINT_VERSION=1.19.0
ENV KUBESEAL_VERSION=0.13.1

RUN apk add --no-cache git curl
RUN git clone https://github.com/ohmyzsh/ohmyzsh.git /root-layer/.oh-my-zsh
RUN git clone --depth 1 https://github.com/romkatv/powerlevel10k.git /root-layer/.oh-my-zsh/custom/themes/powerlevel10k
RUN git clone https://github.com/zsh-users/zsh-autosuggestions /root-layer/.oh-my-zsh/custom/plugins/zsh-autosuggestions/
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /root-layer/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && mv kubectl /root-layer/
RUN curl -LO https://get.helm.sh/helm-v${HELM_VERSION}-${OS}-${ARCH}.tar.gz && tar --strip-components=1 -xvzf helm-v${HELM_VERSION}-${OS}-${ARCH}.tar.gz ${OS}-${ARCH}/helm && mv helm /root-layer/
RUN curl -LO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz && tar --strip-components=1 -xvzf docker-${DOCKER_VERSION}.tgz docker/docker && mv docker /root-layer/
RUN cutl -LO https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-${OS}-${ARCH} && mv kubeseal-${OS}-${ARCH} /root-layer/kubeseal
RUN curl -LO https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64 && mv hadolint-Linux-x86_64 /root-layer/hadolint
COPY zshrc.zsh-template /root-layer/.oh-my-zsh/templates/zshrc.zsh-template
COPY root/ /root-layer/

# runtime stage
FROM scratch

# Add files from buildstage
COPY --from=buildstage /root-layer/ /