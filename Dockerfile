ARG DISTRIBUTION=ubuntu:jammy
FROM ${DISTRIBUTION}
ARG RUBY_VERSION=3.2
LABEL maintainer="github@github.com"

RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y build-essential ca-certificates wget libssl-dev default-libmysqlclient-dev clang clang-tools llvm valgrind netcat

RUN wget https://www.openssl.org/source/openssl-1.0.1u.tar.gz && \
    tar -xf openssl-1.0.1u.tar.gz && \
    cd openssl-1.0.1u && \
    ./config shared --prefix=/usr/local/openssl-1.0.1 && \
    make && \
    make install && \
    rm -rf /tmp/openssl-1.0.1u*

RUN update-ca-certificates

RUN wget https://github.com/postmodern/ruby-install/releases/download/v0.9.0/ruby-install-0.9.0.tar.gz && \
    tar -xzvf ruby-install-0.9.0.tar.gz && \
    cd ruby-install-0.9.0/ && \
    make install && \
    ruby-install --system ruby ${RUBY_VERSION} -- --with-openssl-dir=/usr/local/openssl-1.0.1

RUN ruby --version

WORKDIR /app
COPY . .

CMD ["script/test"]
