FROM ubuntu:22.04
MAINTAINER ome-devel@lists.openmicroscopy.org.uk

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN echo 'APT::Install-Recommends 0;' > /etc/apt/apt.conf.d/01norecommends \
 && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends

RUN apt-get update && \
    apt-get install -y -q\
        unzip \
        wget \
        build-essential \
        db5.3-util \
        libbz2-dev \
        libdb++-dev \
        libdb-dev \
        libexpat-dev \
        libmcpp-dev \
        libssl-dev \
        mcpp \
        python3-dev \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        software-properties-common \
        zlib1g-dev

RUN mkdir /dist
ADD build.sh /
CMD ["/build.sh"]
