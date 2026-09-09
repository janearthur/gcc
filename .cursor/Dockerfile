# Cursor Cloud Agent image for building GCC.
# Do not COPY the project; Cursor checks out the repo on the VM.
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    g++ \
    make \
    flex \
    bison \
    gawk \
    m4 \
    python3 \
    git \
    wget \
    curl \
    ca-certificates \
    xz-utils \
    bzip2 \
    unzip \
    patch \
    file \
    rsync \
    libgmp-dev \
    libmpfr-dev \
    libmpc-dev \
    libisl-dev \
    zlib1g-dev \
    gettext \
    texinfo \
    dejagnu \
    expect \
    tcl \
    autogen \
    sudo \
    && rm -rf /var/lib/apt/lists/*

RUN id -u ubuntu >/dev/null 2>&1 || useradd -m -s /bin/bash ubuntu \
    && echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu \
    && chmod 0440 /etc/sudoers.d/ubuntu
