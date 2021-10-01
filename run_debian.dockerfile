# [run] Debian or Ubuntu

ARG IMAGE="debian:stretch-slim"
ARG LLVM_VER="4.0"
ARG GNAT_VER="6"

#---

FROM $IMAGE AS mcode

ARG GNAT_VER

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    gcc \
    libc6-dev \
    libgnat-$GNAT_VER \
    make \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/*

#---

FROM mcode AS zlib

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    zlib1g-dev \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/*

#---

FROM zlib AS gcc

# make sure proper GCC version is used for linking (elaborate)
RUN cd /usr/local/bin && ln -s gcc cc

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    lcov \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/*

#---

FROM zlib AS llvm

ARG LLVM_VER

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    libllvm$LLVM_VER \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/*
