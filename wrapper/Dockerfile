FROM benjamint/vim-pathogen:latest

MAINTAINER JAremko <w3techplaygound@gmail.com>

ENV TERM=xterm-256color
ENV DISABLE=""

RUN apk add --no-cache su-exec

COPY run /usr/local/bin/

#custom .vimrc stub
RUN mkdir -p /ext  && echo " " > /ext/.vimrc

ENTRYPOINT ["sh", "/usr/local/bin/run"]
