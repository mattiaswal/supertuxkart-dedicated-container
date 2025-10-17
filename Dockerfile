FROM ubuntu:24.04

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    sqlite3 \
    bash \
    subversion \
    pkg-config \
    libcurl4-openssl-dev \
    libssl-dev \
    libsqlite3-dev \
    zlib1g-dev \
    libenet-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /build

# Clone SuperTuxKart repository and assets
#RUN git clone --depth 1 https://github.com/supertuxkart/stk-code.git && \
#    cd stk-code && \
#    git submodule update --init --recursive
RUN git clone --depth 1  https://github.com/kimden/stk-code.git stk-code && \
    svn co https://svn.code.sf.net/p/supertuxkart/code/stk-assets stk-assets
RUN cd stk-code && \
    git submodule update --init --recursive

# Checkout stk-assets (must be in same parent directory as stk-code)

# Build SuperTuxKart server-only
WORKDIR /build/stk-code
RUN mkdir build && cd build && \
    cmake .. \
    -DSERVER_ONLY=ON \
    -DUSE_SQLITE3=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local && \
    make -j$(nproc) && \
    make install

# Create data directory
RUN mkdir -p /stk-data

# Clean up build files to reduce image size
WORKDIR /
RUN rm -rf /build
RUN rm -rf ../stk-assets

# Set root's home directory to /stk-data
ENV HOME=/stk-data
ENV SERVER_CONFIG=/stk-data/server_config.xml
WORKDIR /stk-data

# Expose default SuperTuxKart server port
EXPOSE 2759/udp

# Default command to run the server
CMD sh -c "supertuxkart --server-config=${SERVER_CONFIG}"
