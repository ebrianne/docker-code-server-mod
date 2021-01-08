FROM lsiobase/alpine:3.12 as buildstage

ENV HELM_VERSION=3.4.2
ENV ARCH=amd64
ENV OS=linux

RUN apk add --no-cache git curl wget
RUN git clone https://github.com/ohmyzsh/ohmyzsh.git /root-layer/.oh-my-zsh
RUN git clone --depth 1 https://github.com/romkatv/powerlevel10k.git /root-layer/.oh-my-zsh/custom/themes/powerlevel10k
RUN git clone https://github.com/zsh-users/zsh-autosuggestions /root-layer/.oh-my-zsh/custom/plugins/zsh-autosuggestions/
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /root-layer/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && mv kubectl /root-layer/
RUN wget https://get.helm.sh/helm-v${HELM_VERSION}-${OS}-${ARCH}.tar.gz && tar --strip-components=1 -xvzf helm-v${HELM_VERSION}-${OS}-${ARCH}.tar.gz ${OS}-${ARCH}/helm && mv helm /root-layer/

COPY zshrc.zsh-template /root-layer/.oh-my-zsh/templates/zshrc.zsh-template
COPY root/ /root-layer/

# runtime stage
FROM scratch

# Add files from buildstage
COPY --from=buildstage /root-layer/ /