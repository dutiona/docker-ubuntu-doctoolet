FROM ubuntu:bionic
LABEL maintainer="Michaël Roynard <mroynard@lrde.epita.fr>"

ENV container docker
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Install all pkg
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get update && apt-get dist-upgrade -y && apt-get upgrade -y
RUN apt-get install -y \
    build-essential binutils git ninja-build cmake python python3 python-pip python3-pip
RUN export DEBIAN_FRONTEND_BACKUP=$DEBIAN_FRONTEND && export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y tzdata && \
    ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    export DEBIAN_FRONTEND=$DEBIAN_FRONTEND_BACKUP
RUN apt-get install -y \
    texlive-full
RUN apt-get install -y \
    htmldoc pandoc npm doxygen graphviz tree
RUN apt-get update && apt-get upgrade -y

# Clean
RUN apt-get autoremove -y && apt-get autoclean -y
# RUN rm -rf /var/lib/apt/lists/

RUN npm install -g markdown-pdf

# Install python packages
RUN echo y | pip install -U pip six wheel setuptools
RUN echo y | pip install sphinx breathe exhale sphinx_rtd_theme conan
RUN echo y | pip3 install -U pip six wheel setuptools
RUN echo y | pip3 install sphinx breathe exhale sphinx_rtd_theme conan

WORKDIR /root/.conan/profiles
COPY conan-profiles/* ./

WORKDIR /workspace

CMD ["/bin/bash"]
