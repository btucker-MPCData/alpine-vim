FROM benjamint/alpine:latest

MAINTAINER JAremko <w3techplaygound@gmail.com>

ADD tidy-viml /util/

RUN apk update && apk add ca-certificates && update-ca-certificates && apk add openssl

RUN apk add --update --virtual build-deps python python-dev ctags build-base \
      make mercurial libxpm-dev libx11-dev libxt-dev ncurses-dev git gtk+2.0-dev && \
    cd /tmp                                                                    && \
    git clone https://github.com/vim/vim.git vim                               && \
    cd /tmp/vim                                                                && \
    git fetch https://github.com/btucker-MPCData/vim.git master:custom         && \
    git config --global user.email "you@example.com"                           && \
    git config --global user.name "Your Name"                                  && \
    git checkout custom                                                        && \
    git rebase master                                                          && \
    ./configure --with-features=big \
                #needed for editing text in languages which have many characters
                --enable-multibyte \
                #python interop needed for some of my plugins
                --enable-pythoninterp \
                --with-python-config-dir=/usr/lib/python2.7/config \
                --enable-gui \
                --disable-netbeans \
                --prefix /usr                                                  && \
    make VIMRUNTIMEDIR=/usr/share/vim/vim80                                    && \
    make install                                                               && \
    apk del build-deps                                                         && \
    apk add libsm libice libxt libx11 ncurses gtk+2.0                          && \
    #deleting docs, tutorials, icons and lang
    rm -rf /tmp/* /var/cache/* /var/log/* /var/tmp/*                           && \
    mkdir /var/cache/apk                                                       && \
    cd /usr/share/vim/vim80/                                                   && \
    rm -rf tutor/* gvimrc_example.vim vimrc_example.vim

ENTRYPOINT ["vim"]
