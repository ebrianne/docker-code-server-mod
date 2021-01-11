FROM lsiobase/alpine:3.12 as buildstage

ENV ARCH=amd64
ENV OS=linux

RUN apk add --no-cache git curl
RUN git clone https://github.com/ohmyzsh/ohmyzsh.git /root-layer/.oh-my-zsh
RUN git clone --depth 1 https://github.com/romkatv/powerlevel10k.git /root-layer/.oh-my-zsh/custom/themes/powerlevel10k
RUN git clone https://github.com/zsh-users/zsh-autosuggestions /root-layer/.oh-my-zsh/custom/plugins/zsh-autosuggestions/
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /root-layer/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
COPY zshrc.zsh-template /root-layer/.oh-my-zsh/templates/zshrc.zsh-template
COPY root/ /root-layer/

# runtime stage
FROM scratch

# Add files from buildstage
COPY --from=buildstage /root-layer/ /