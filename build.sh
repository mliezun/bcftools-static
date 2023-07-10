#!/bin/sh

CURL_VERSION='8.1.2'
BCFTOOLS_VERSION='1.8'
TARGET='x86_64-linux'

[ "$1" != "" ] && BCFTOOLS_VERSION="$1"

set -exu

# Install required dependencies
apk update
apk add build-base clang openssl-dev openssl-libs-static \
    nghttp2-dev nghttp2-static libssh2-dev libssh2-static \
    zlib-dev zlib-static bzip2-dev bzip2-static xz-dev xz-static


# Install curl from source
wget https://curl.haxx.se/download/curl-${CURL_VERSION}.tar.gz

tar xzf curl-${CURL_VERSION}.tar.gz

cd curl-${CURL_VERSION}

LDFLAGS="-static" PKG_CONFIG="pkg-config --static" ./configure \
    --disable-shared --enable-static --disable-ldap --enable-ipv6 \
    --enable-unix-sockets --with-ssl --with-libssh2 \
    --prefix=/tmp/curl

make -j4 V=1 LDFLAGS="-static -all-static"

make install

cd ..

rm -rf curl-${CURL_VERSION} curl-${CURL_VERSION}.tar.gz


# Download htslib
wget https://github.com/samtools/htslib/releases/download/${BCFTOOLS_VERSION}/htslib-${BCFTOOLS_VERSION}.tar.bz2

tar xf htslib-${BCFTOOLS_VERSION}.tar.bz2

mv htslib-${BCFTOOLS_VERSION} htslib

rm -rf htslib-${BCFTOOLS_VERSION}.tar.bz2


# Download and compile bcftools
wget https://github.com/samtools/bcftools/releases/download/${BCFTOOLS_VERSION}/bcftools-${BCFTOOLS_VERSION}.tar.bz2

tar xf bcftools-${BCFTOOLS_VERSION}.tar.bz2

cd bcftools-${BCFTOOLS_VERSION}

export C_CURL_FLAGS="-L/tmp/curl/lib -lcurl -L/lib -lssl -lcrypto -lnghttp2 -lssh2 -lpthread -ldl -lz -DCURL_STATICLIB -I/tmp/curl/include"

make -j4 PLUGINS_ENABLED=no CFLAGS="-g0 -Wall -O3 -static $C_CURL_FLAGS" LDFLAGS="-g0 -O3 -static" ALL_LIBS="$C_CURL_FLAGS"

strip ./bcftools

mkdir -p /build/release

mv ./bcftools /build/release/bcftools-${BCFTOOLS_VERSION}-${TARGET}
