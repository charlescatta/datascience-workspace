FROM nvidia/cuda:10.1-base-ubuntu18.04
LABEL com.nvidia.volumes.needed="nvidia_driver"

ENV LANG C.UTF-8
ENV SHELL=/bin/bash
ENV DEBIAN_FRONTEND noninteractive
ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH

RUN echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  cmake \
  git \
  curl \
  vim \
  libjpeg-dev \
  zip \
  unzip \
  libpng-dev && \
  rm -rf /var/lib/apt/lists/*

ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64
ENV PYTHON_VERSION=3.7

RUN curl -L https://repo.continuum.io/miniconda/Miniconda2-4.7.10-Linux-x86_64.sh -o miniconda.sh && \
  chmod +x ./miniconda.sh && \
  ./miniconda.sh -b -p /opt/conda && \
  rm ./miniconda.sh && \
  /opt/conda/bin/conda install conda-build

COPY environment.yaml environment.yaml
RUN conda env create -f ./environment.yaml
CMD echo "source activate dl" > ~/.bashrc
CMD source ~/.bashrc

RUN jupyter nbextensions_configurator enable --user
RUN jupyter nbextension enable code_prettify
RUN jupyter nbextension enable hinterland

WORKDIR /work
RUN chmod -R a+w /work
WORKDIR /work

EXPOSE 8888

ENTRYPOINT source activate fastai && jupyter lab --ip=0.0.0.0 --no-browser
