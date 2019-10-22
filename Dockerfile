FROM nvidia/cuda:10.1-cudnn7-runtime-ubuntu18.04

ENV LANG C.UTF-8
ENV SHELL=/bin/bash

LABEL com.nvidia.volumes.needed="nvidia_driver"

RUN echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  cmake \
  git \
  curl \
  vim \
  libjpeg-dev \
  zip \
  unzip \
  libpng-dev &&\
  rm -rf /var/lib/apt/lists/*

ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64
ENV PYTHON_VERSION=3.7

RUN curl -L https://repo.continuum.io/miniconda/Miniconda2-4.7.10-Linux-x86_64.sh -o miniconda.sh && \
  chmod +x ./miniconda.sh && \
  ./miniconda.sh -b -p /opt/conda && \
  rm ./miniconda.sh && \
  /opt/conda/bin/conda install conda-build

ENV PATH=$PATH:/opt/conda/bin/
ENV USER scientist

COPY environment.yaml environment.yaml
RUN conda env create -f ./environment.yaml
CMD conda activate dl
RUN conda install jupyter
CMD source ~/.bashrc

RUN jupyter nbextensions_configurator enable --user
RUN jupyter nbextension enable code_prettify
RUN jupyter nbextension enable hinterland

WORKDIR /work
RUN chmod -R a+w /work
WORKDIR /work

ENTRYPOINT jupyter lab --ip=0.0.0.0 --no-browser
