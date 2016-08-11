FROM benjamint/vim-wrapper:latest

MAINTAINER JAremko <w3techplaygound@gmail.com>

LABEL jare-compatible-dockerized-vim="true"

ADD bundle /home/developer/bundle

#Plugins deps
RUN apk --update add curl ctags git python bash ncurses-terminfo                                                && \
#Build YouCompleteMe
    apk add --virtual build-deps go llvm-dev clang-dev perl cmake python-dev build-base                                       && \
    cd /home/developer/bundle/YouCompleteMe                                                                     && \
    /home/developer/bundle/YouCompleteMe/install.py --gocode-completer --clang-completer --system-libclang      && \
#Node.js deps (needed only if you're planning to mount and run jare/typescript)
    apk add libgcc libstdc++ libuv                                                                              && \
#Compile procvim.vim
    cd /home/developer/bundle/vimproc.vim                                                                       && \
    make                                                                                                        && \
#    ls -la  /home/developer/bundle/vimproc.vim/lib/    && \
#    mv /home/developer/bundle/vimproc.vim/lib/vimproc_linux64.so                                                   \
#      /home/developer/bundle/vimproc.vim/lib/vimproc_unix.so                                                    && \
#Change Dos to Unix line endings for the drools syntax
    sed -i $'s/\r$//' /home/developer/bundle/drools.vim/syntax/drools.vim                                       && \
#Cleanup
    rm -rf /home/developer/bundle/YouCompleteMe/third_party/ycmd/cpp /usr/lib/go  \
      /home/developer/bundle/YouCompleteMe/third_party/ycmd/clang_includes                                      && \
    apk del build-deps                                                                                          && \
    apk add libxt libx11 libstdc++ llvm clang the_silver_searcher grep                                          && \
    sh /util/ocd-clean / > /dev/null 2>&1 									&& \
    apk --update add libc-dev																					&& \
    cd /home/developer/bundle/                                                                                  && \
    sh /util/ocd-clean /home/developer/bundle/  > /dev/null 2>&1

#Install the Hack font
RUN cd /home/developer                                                                                          && \
    git clone --depth 1 https://github.com/chrissimpkins/Hack.git Hack                                          && \
    mkdir -p /usr/share/fonts                                                                                   && \
    cp -r Hack/build/ttf /usr/share/fonts/ttf-hack                                                              && \
    fc-cache -sv                                                                                                && \
    rm -fr /home/developer/Hack

#Build the default .vimrc
COPY .vimrc /home/developer/my.vimrc
RUN  mv -f /home/developer/.vimrc /home/developer/.vimrc~                                                       && \
     curl -s https://raw.githubusercontent.com/amix/vimrc/master/vimrcs/basic.vim >> /home/developer/.vimrc~    && \
     curl -s https://raw.githubusercontent.com/amix/vimrc/master/vimrcs/extended.vim >> /home/developer/.vimrc~ && \
     cat  /home/developer/my.vimrc >> /home/developer/.vimrc~                                                   && \
     rm /home/developer/my.vimrc                                                                                && \
     sh /util/tidy-viml /home/developer/.vimrc~     

#Pathogen help tags generation
RUN vim -E -c 'execute pathogen#helptags()' -c q ; return 0

ENV GOPATH /home/developer/workspace
ENV GOROOT /usr/lib/go
ENV GOBIN $GOROOT/bin
ENV NODEBIN /usr/lib/node_modules/bin
ENV PATH $PATH:$GOBIN:$GOPATH/bin:$NODEBIN
ENV HOME /home/developer
