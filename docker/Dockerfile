# Multi-stage build for mysql-server
# Optimized for cross-platform container deployment
# -----------------------------------------------
# Stage 1: Build
# Stage 2: Runtime (minimal image)
# -----------------------------------------------

FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    libssl-dev \
    libncurses5-dev \
    libreadline-dev \
    bison \
    flex \
    git \
    libboost-all-dev \
    liblz4-dev \
    libzstd-dev \
    libprotobuf-dev \
    protobuf-compiler \
    libcurl4-openssl-dev \
    libkrb5-dev \
    libldap2-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY . .
RUN ./build.sh full --clean -b build_container -j $(nproc)

# Stage 2: Runtime
FROM ubuntu:22.04 AS runtime

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    libssl3 \
    libncurses6 \
    libreadline8 \
    libboost-system1.74.0 \
    liblz4-1 \
    libzstd1 \
    libprotobuf23 \
    libcurl4 \
    libkrb5-3 \
    libldap-2.5-0 \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -r mysql && useradd -r -g mysql mysql

# Copy only built artifacts and needed libraries
COPY --from=builder /src/build_container/sql/mysqld /usr/local/bin/mysqld
COPY --from=builder /src/build_container/sql/*.ini /etc/mysql/ 2>/dev/null || true
COPY --from=builder /src/build_container/libmysql/libmysqlclient.so* /usr/lib/ 2>/dev/null || true
COPY --from=builder /src/plugin_output_directory/*.so /usr/lib/mysql/plugin/ 2>/dev/null || true

RUN mkdir -p /var/lib/mysql /var/log/mysql /usr/lib/mysql/plugin \
    && chown -R mysql:mysql /var/lib/mysql /var/log/mysql /usr/lib/mysql/plugin

USER mysql
EXPOSE 3306
ENTRYPOINT ["mysqld"]
CMD ["--defaults-file=/etc/mysql/my.cnf", "--user=mysql"]
