FROM gcr.io/learned-stone-189802/base-ide:latest

ENV \
    NVM_VERSION=v0.33.8 \
    NVM_DIR=/home/user/ts/src/.nvm \
    NODE_VERSION=8.9.4 \
    NPM_VERSION=5.8.0

#INSTALL nvm (node version manager) 
#INSTALL node (includes npm) and typescript server (TSServer)
#INSTALL webpack
#INSTALL prettier
#INSTALL specific version of npm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh | bash && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  && \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \ 
    nvm install ${NODE_VERSION} && \
    npm install -g typescript && \
    npm install -g webpack && \
    npm install -g prettier && \
    npm install -g npm@${NPM_VERSION} && \
    #SETUP YCM with js-completer
    cd /home/user/.vim/bundle/YouCompleteMe && \
    ./install.py --js-completer

COPY --chown=1000:1000 \
    .entrypoint.sh \
    /home/user/

VOLUME ["/home/user/ts/src"]

ENTRYPOINT ["/home/user/.entrypoint.sh"]

LABEL \
    NAME="tahurt/ts-ide" \
    RUN="docker run -it --rm --mount type=volume,source=ts-src,target=/home/user/ts/src --mount type=bind,source=\$HOME/Dropbox/Mackup,target=/home/user/Mackup tahurt/ts-ide" \
    RUN_WITH_SSH_AGENT="docker run -it --rm --mount type=volume,source=ts-src,target=/home/user/go/src --mount type=bind,source=\$HOME/Dropbox/Mackup,target=/home/user/Mackup --mount type=bind,source=\$SSH_AUTH_SOCK,target=/tmp/ssh_auth.sock --env SSH_AUTH_SOCK=/tmp/ssh_auth.sock tahurt/ts-ide" \
    MAINTAINER="taylor.a.hurt@gmail.com"
