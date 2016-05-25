FROM benjamint/vim-wrapper:latest

MAINTAINER JAremko <w3techplaygound@gmail.com>

LABEL jare-compatible-dockerized-vim="true"

COPY .vimrc /home/developer/my.vimrc

#Plugins deps
RUN apk --update add curl ctags git python bash ncurses-terminfo                                                && \
#Build YouCompleteMe
    apk add --virtual build-deps go llvm-dev clang-dev perl cmake python-dev build-base                                       && \
    git clone --depth 1  https://github.com/Valloric/YouCompleteMe.git /home/developer/bundle/YouCompleteMe/    && \
    cd /home/developer/bundle/YouCompleteMe                                                                     && \
    git submodule update --init --recursive                                                                     && \
    /home/developer/bundle/YouCompleteMe/install.py --gocode-completer --clang-completer --system-libclang      && \
#Node.js deps (needed only if you're planning to mount and run jare/typescript)
    apk add libgcc libstdc++ libuv                                                                              && \
#Install and compile procvim.vim                                                                               
    git clone --depth 1 https://github.com/Shougo/vimproc.vim.git /home/developer/bundle/vimproc.vim            && \
    cd /home/developer/bundle/vimproc.vim                                                                       && \
    make                                                                                                        && \
#    ls -la  /home/developer/bundle/vimproc.vim/lib/    && \
#    mv /home/developer/bundle/vimproc.vim/lib/vimproc_linux64.so                                                   \
#      /home/developer/bundle/vimproc.vim/lib/vimproc_unix.so                                                    && \
#Cleanup
    rm -rf /home/developer/bundle/YouCompleteMe/third_party/ycmd/cpp /usr/lib/go  \
      /home/developer/bundle/YouCompleteMe/third_party/ycmd/clang_includes                                      && \
    apk del build-deps                                                                                          && \
    apk add libxt libx11 libstdc++ llvm clang the_silver_searcher grep                                          && \
    sh /util/ocd-clean / > /dev/null 2>&1 									&& \
    apk --update add libc-dev

RUN cd /home/developer/bundle/                                                                                  && \
    git clone --depth 1 https://github.com/pangloss/vim-javascript.git                                          && \
    git clone --depth 1 https://github.com/scrooloose/nerdcommenter.git                                         && \
    git clone --depth 1 https://github.com/godlygeek/tabular.git                                                && \
    git clone --depth 1 https://github.com/Raimondi/delimitMate.git                                             && \
    git clone --depth 1 https://github.com/nathanaelkane/vim-indent-guides.git                                  && \
    git clone --depth 1 https://github.com/groenewege/vim-less.git                                              && \
    git clone --depth 1 https://github.com/othree/html5.vim.git                                                 && \
    git clone --depth 1 https://github.com/elzr/vim-json.git                                                    && \
    git clone --depth 1 https://github.com/bling/vim-airline.git                                                && \
    git clone --depth 1 https://github.com/easymotion/vim-easymotion.git                                        && \
    git clone --depth 1 https://github.com/mbbill/undotree.git                                                  && \
    git clone --depth 1 https://github.com/majutsushi/tagbar.git                                                && \
    git clone --depth 1 https://github.com/vim-scripts/EasyGrep.git                                             && \
    git clone --depth 1 https://github.com/jlanzarotta/bufexplorer.git                                          && \
    git clone --depth 1 https://github.com/kien/ctrlp.vim.git                                                   && \
    git clone --depth 1 https://github.com/scrooloose/nerdtree.git                                              && \ 
    git clone --depth 1 https://github.com/jistr/vim-nerdtree-tabs.git                                          && \
    git clone --depth 1 https://github.com/scrooloose/syntastic.git                                             && \
    git clone --depth 1 https://github.com/tomtom/tlib_vim.git                                                  && \
    git clone --depth 1 https://github.com/marcweber/vim-addon-mw-utils.git                                     && \
    git clone --depth 1 https://github.com/altercation/vim-colors-solarized.git                                 && \
    git clone --depth 1 https://github.com/vim-scripts/taglist.vim.git                                          && \
    git clone --depth 1 https://github.com/terryma/vim-expand-region.git                                        && \
    git clone --depth 1 https://github.com/tpope/vim-fugitive.git                                               && \
    git clone --depth 1 https://github.com/airblade/vim-gitgutter.git                                           && \
    git clone --depth 1 https://github.com/fatih/vim-go.git                                                     && \
    git clone --depth 1 https://github.com/plasticboy/vim-markdown.git                                          && \
    git clone --depth 1 https://github.com/michaeljsmith/vim-indent-object.git                                  && \
    git clone --depth 1 https://github.com/terryma/vim-multiple-cursors.git                                     && \
    git clone --depth 1 https://github.com/tpope/vim-repeat.git                                                 && \
    git clone --depth 1 https://github.com/tpope/vim-surround.git                                               && \
    git clone --depth 1 https://github.com/vim-scripts/mru.vim.git                                              && \
    git clone --depth 1 https://github.com/vim-scripts/YankRing.vim.git                                         && \
    git clone --depth 1 https://github.com/tpope/vim-haml.git                                                   && \
    git clone --depth 1 https://github.com/SirVer/ultisnips.git                                                 && \
    git clone --depth 1 https://github.com/honza/vim-snippets.git                                               && \
    git clone --depth 1 https://github.com/derekwyatt/vim-scala.git                                             && \
    git clone --depth 1 https://github.com/leafgarland/typescript-vim.git                                       && \
    git clone --depth 1 https://github.com/christoomey/vim-tmux-navigator.git                                   && \
    git clone --depth 1 https://github.com/Quramy/tsuquyomi.git                                                 && \
    git clone --depth 1 https://github.com/vim-scripts/peaksea.git                                              && \
    git clone --depth 1 https://github.com/junegunn/rainbow_parentheses.vim.git                                 && \
    git clone --depth 1 https://github.com/sven-strothoff/vim-clang_doxygen.git                                 && \
    git clone --depth 1 https://github.com/kergoth/vim-bitbake.git                                              && \
    git clone --depth 1 https://github.com/vim-scripts/SearchComplete.git                                       && \
#Cleanup
    sh /util/ocd-clean /home/developer/bundle/  > /dev/null 2>&1
    
#Build the default .vimrc
RUN  mv -f /home/developer/.vimrc /home/developer/.vimrc~                                                       && \
     curl -s https://raw.githubusercontent.com/amix/vimrc/master/vimrcs/basic.vim >> /home/developer/.vimrc~    && \
     curl -s https://raw.githubusercontent.com/amix/vimrc/master/vimrcs/extended.vim >> /home/developer/.vimrc~ && \
     cat  /home/developer/my.vimrc >> /home/developer/.vimrc~                                                   && \
     rm /home/developer/my.vimrc                                                                                && \
     sh /util/tidy-viml /home/developer/.vimrc~     

#Pathogen help tags generation
RUN vim -E -c 'execute pathogen#helptags()' -c q ; return 0

#Install the Hack font
RUN cd /home/developer                                                                                          && \
    git clone --depth 1 https://github.com/chrissimpkins/Hack.git Hack                                          && \
    mkdir -p /usr/share/fonts                                                                                   && \
    cp -r Hack/build/ttf /usr/share/fonts/ttf-hack                                                              && \
    fc-cache -sv                                                                                                && \
    rm -fr /home/developer/Hack

ENV GOPATH /home/developer/workspace
ENV GOROOT /usr/lib/go
ENV GOBIN $GOROOT/bin
ENV NODEBIN /usr/lib/node_modules/bin
ENV PATH $PATH:$GOBIN:$GOPATH/bin:$NODEBIN
ENV HOME /home/developer
