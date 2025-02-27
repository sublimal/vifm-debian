FROM debian:12

ARG VIFM_VERSION=0.14
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y install --no-install-recommends libncursesw5-dev vim-tiny curl bzip2 build-essential pkg-config libx11-dev libmagic-dev file && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /tmp/src && \
    curl -kSsL "https://prdownloads.sourceforge.net/vifm/vifm-${VIFM_VERSION}.tar.bz2?download" | tar -C /tmp/src --strip-components=1 -xjf -

RUN cd /tmp/src && \
    ./configure --with-X11 --with-dyn-X11 --without-glib --disable-build-timestamp

RUN cd /tmp/src && \
    make

RUN mkdir -p /tmp/vifm-${VIFM_VERSION}/DEBIAN
# https://salsa.debian.org/debian/vifm/-/raw/master/debian/control
COPY control /tmp/vifm-${VIFM_VERSION}/DEBIAN/control

RUN cd /tmp/src && \
    make DESTDIR=/tmp/vifm-${VIFM_VERSION} install || true

RUN dpkg-deb -b /tmp/vifm-${VIFM_VERSION}
