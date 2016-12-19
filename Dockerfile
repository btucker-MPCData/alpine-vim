FROM benjamint/vim-wrapper:latest

MAINTAINER JAremko <w3techplaygound@gmail.com>

LABEL jare-compatible-dockerized-vim="true"

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# Install node
ENV NODE_VERSION=v7.2.1 NPM_VERSION=3
RUN apk add --no-cache curl make gcc g++ python linux-headers paxctl libgcc libstdc++ gnupg && \
  gpg --keyserver ha.pool.sks-keyservers.net --recv-keys \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 && \
  curl -o node-${NODE_VERSION}.tar.gz -sSL https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}.tar.gz && \
  curl -o SHASUMS256.txt.asc -sSL https://nodejs.org/dist/${NODE_VERSION}/SHASUMS256.txt.asc && \
  gpg --verify SHASUMS256.txt.asc && \
  grep node-${NODE_VERSION}.tar.gz SHASUMS256.txt.asc | sha256sum -c - && \
  tar -zxf node-${NODE_VERSION}.tar.gz && \
  cd node-${NODE_VERSION} && \
  export GYP_DEFINES="linux_use_gold_flags=0" && \
  ./configure --prefix=/usr ${CONFIG_FLAGS} && \
  NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
  make -j${NPROC} -C out mksnapshot BUILDTYPE=Release && \
  paxctl -cm out/Release/mksnapshot && \
  make -j${NPROC} && \
  make install && \
  paxctl -cm /usr/bin/node && \
  cd / && \
  if [ -x /usr/bin/npm ]; then \
    npm install -g npm@${NPM_VERSION}; \
  fi

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

ENV JAVA_VERSION 8u111
ENV JAVA_ALPINE_VERSION 8.111.14-r1

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

# Restore the standard C header files for YCM C code checking
RUN apk --update fix musl-dev

#Install the Hack font
RUN cd /home/developer                                                                                          && \
    git clone --depth 1 https://github.com/chrissimpkins/Hack.git Hack                                          && \
    mkdir -p /usr/share/fonts                                                                                   && \
    cp -r Hack/build/ttf /usr/share/fonts/ttf-hack                                                              && \
    fc-cache -sv                                                                                                && \
    rm -fr /home/developer/Hack

# Add the shared files
ADD share /usr/share

# Install Checkstyle for syntastic
RUN mkdir -p /usr/share/java && \
    wget 'http://downloads.sourceforge.net/project/checkstyle/checkstyle/7.1.1/checkstyle-7.1.1-all.jar?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fcheckstyle%2Ffiles%2Fcheckstyle%2F&ts=1473774619&use_mirror=netix' -O /usr/share/java/checkstyle-all.jar

# Install eslint and jshint
RUN npm install -g eslint jshint
ADD .eslintrc.js /home/developer/.eslintrc

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
