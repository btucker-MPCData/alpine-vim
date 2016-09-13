FROM benjamint/vim-wrapper:latest

MAINTAINER JAremko <w3techplaygound@gmail.com>

LABEL jare-compatible-dockerized-vim="true"

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk/jre
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

ENV JAVA_VERSION 8u101
ENV JAVA_ALPINE_VERSION 8.101.13-r1

RUN set -x \
	&& apk add --no-cache \
		openjdk8-jre="$JAVA_ALPINE_VERSION" \
	&& [ "$JAVA_HOME" = "$(docker-java-home)" ]

ADD bundle /home/developer/bundle

RUN wget http://www.languagetool.org/download/LanguageTool-stable.zip -O /tmp/lt.zip && \
	mkdir -p /home/developer/bundle/vim-grammarous/misc && \
    unzip /tmp/lt.zip -d /home/developer/bundle/vim-grammarous/misc && \
	rm /tmp/lt.zip

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

#help tags generation
RUN vim -c 'helptags ALL' -c q

#Build the default .vimrc
COPY .vimrc /home/developer/my.vimrc
RUN  mv -f /home/developer/.vimrc /home/developer/.vimrc~                                                       && \
     curl -s https://raw.githubusercontent.com/amix/vimrc/master/vimrcs/basic.vim >> /home/developer/.vimrc~    && \
     curl -s https://raw.githubusercontent.com/amix/vimrc/master/vimrcs/extended.vim >> /home/developer/.vimrc~ && \
     cat  /home/developer/my.vimrc >> /home/developer/.vimrc~                                                   && \
     rm /home/developer/my.vimrc                                                                                && \
     sh /util/tidy-viml /home/developer/.vimrc~     

ENV GOPATH /home/developer/workspace
ENV GOROOT /usr/lib/go
ENV GOBIN $GOROOT/bin
ENV NODEBIN /usr/lib/node_modules/bin
ENV PATH $PATH:$GOBIN:$GOPATH/bin:$NODEBIN
ENV HOME /home/developer
