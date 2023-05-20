FROM ubuntu:22.04

WORKDIR /usr/local/http3

# Install required packages
RUN apt-get update && apt-get install -y \
    g++ \
    clang \
    make \
    binutils \
    autoconf \
    automake \
    autotools-dev \
    libtool \
    pkg-config \
    zlib1g-dev \
    libcunit1-dev \
    libssl-dev \
    libxml2-dev \
    libev-dev \
    libevent-dev \
    libjansson-dev \
    libc-ares-dev \
    libjemalloc-dev \
    libsystemd-dev \
    ruby-dev \
    bison \
    libelf-dev \
    git && \
    rm -rf /var/lib/apt/lists/*

# Clone and build custom OpenSSL
RUN git clone --depth 1 -b OpenSSL_1_1_1t+quic https://github.com/quictls/openssl && \
    cd openssl && \
    ./config --prefix=$PWD/build --openssldir=/etc/ssl && \
    make -j$(nproc) && \
    make install_sw

# Clone and build nghttp3
RUN git clone --depth 1 -b v0.11.0 https://github.com/ngtcp2/nghttp3 && \
    cd nghttp3 && \
    autoreconf -i && \
    ./configure --prefix=$PWD/build --enable-lib-only && \
    make -j$(nproc) && \
    make install

# Clone and build ngtcp2
RUN git clone --depth 1 -b v0.15.0 https://github.com/ngtcp2/ngtcp2 && \
    cd ngtcp2 && \
    autoreconf -i && \
    ./configure --prefix=$PWD/build --enable-lib-only PKG_CONFIG_PATH="$PWD/../openssl/build/lib/pkgconfig" && \
    make -j$(nproc) && \
    make install

# If your Linux distribution does not have libbpf-dev >= 0.7.0, build from source
RUN git clone --depth 1 -b v1.1.0 https://github.com/libbpf/libbpf && \
    cd libbpf && \
    PREFIX=$PWD/build make -C src install

# Clone and build nghttp2
RUN git clone https://github.com/nghttp2/nghttp2 && \
    cd nghttp2 && \
    git submodule update --init && \
    autoreconf -i && \
    ./configure --with-mruby --with-neverbleed --enable-http3 --with-libbpf CC=clang-14 CXX=clang++-14 PKG_CONFIG_PATH="$PWD/../openssl/build/lib/pkgconfig:$PWD/../nghttp3/build/lib/pkgconfig:$PWD/../ngtcp2/build/lib/pkgconfig:$PWD/../libbpf/build/lib64/pkgconfig" LDFLAGS="$LDFLAGS -Wl,-rpath,$PWD/../openssl/build/lib -Wl,-rpath,$PWD/../libbpf/build/lib64" && \
    make -j$(nproc) && \
    make install

ENV LD_LIBRARY_PATH=/usr/local/http3/nghttp2/lib/.libs:${LD_LIBRARY_PATH}

# Clone and build curl with http3 support
RUN git clone https://github.com/curl/curl && \
    cd curl && \
    autoreconf -fi && \
    LDFLAGS="-Wl,-rpath,$PWD/../openssl/build/lib" ./configure --with-openssl=$PWD/../openssl/build --with-nghttp3=$PWD/../nghttp3/build --with-ngtcp2=$PWD/../ngtcp2/build && \
    make -j$(nproc) && \
    make install

ENV LD_LIBRARY_PATH=/usr/local/http3/nghttp2/lib/.libs:/usr/local/http3/curl/lib/.libs:${LD_LIBRARY_PATH}
