# [run] Fedora

ARG IMAGE="fedora:28"

#---

FROM $IMAGE AS mcode

RUN dnf --nodocs -y install \
    diffutils \
    gcc \
    libgnat \
    make \
 && dnf clean all --enablerepo=\*

#---

FROM mcode as common

RUN dnf --nodocs -y install \
    zlib-devel \
 && dnf clean all --enablerepo=\*

#---

FROM common AS llvm

RUN dnf --nodocs -y install \
    llvm-libs \
 && dnf clean all --enablerepo=\*

#---

FROM common AS gcc

RUN dnf --nodocs -y install \
    libstdc++ \
    lcov \
 && dnf clean all --enablerepo=\*

ENV CC=gcc
