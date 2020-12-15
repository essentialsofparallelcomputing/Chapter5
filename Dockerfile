# Part of the examples from the Parallel and High Performance Computing
# Robey and Zamora, Manning Publications
#   https://github.com/EssentialsofParallelComputing/Chapter5
#
# The built image can be found at:
#
#   https://hub.docker.com/r/essentialsofparallelcomputing/chapter5
#
# To get the GPU available during build
# This does the same thing as --gpus all
# sudo vi /etc/docker/daemon.json
# sudo systemctl restart docker
#{
#    "runtimes": {
#        "nvidia": {
#            "path": "nvidia-container-runtime",
#            "runtimeArgs": []
#        }
#    },
#    "default-runtime": "nvidia"
#}
#
# Author:
# Bob Robey <brobey@earthlink.net>

FROM ubuntu:20.04 AS builder
LABEL maintainer Bob Robey <brobey@earthlink.net>

ARG DOCKER_LANG=en_US
ARG DOCKER_TIMEZONE=America/Denver

WORKDIR /tmp
RUN apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get -qq install -y locales tzdata && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV LANG=$DOCKER_LANG.UTF-8 \
    LANGUAGE=$DOCKER_LANG:UTF-8

RUN ln -fs /usr/share/zoneinfo/$DOCKER_TIMEZONE /etc/localtime && \
    locale-gen $LANG && update-locale LANG=$LANG && \
    dpkg-reconfigure -f noninteractive locales tzdata

ENV LC_ALL=$DOCKER_LANG.UTF-8

RUN apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get -qq install -y cmake git vim gcc g++ gfortran software-properties-common \
            python3 wget gnupg-agent xterm pciutils \
            mpich libmpich-dev \
            openmpi-bin openmpi-doc libopenmpi-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Installing latest GCC compiler (version 10)
RUN apt-get -qq update && \
    apt-get -qq install -y gcc-8 g++-8 gfortran-8 \
                           gcc-10 g++-10 gfortran-10 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Problem with compile of compact hash neighbor with gcc-10
RUN update-alternatives \
      --install /usr/bin/gcc      gcc      /usr/bin/gcc-8       90 \
      --slave   /usr/bin/g++      g++      /usr/bin/g++-8          \
      --slave   /usr/bin/gfortran gfortran /usr/bin/gfortran-8     \
      --slave   /usr/bin/gcov     gcov     /usr/bin/gcov-8      && \
    update-alternatives \
      --install /usr/bin/gcc      gcc      /usr/bin/gcc-9       80 \
      --slave   /usr/bin/g++      g++      /usr/bin/g++-9          \
      --slave   /usr/bin/gfortran gfortran /usr/bin/gfortran-9     \
      --slave   /usr/bin/gcov     gcov     /usr/bin/gcov-9      && \
    update-alternatives \
      --install /usr/bin/gcc      gcc      /usr/bin/gcc-10      70 \
      --slave   /usr/bin/g++      g++      /usr/bin/g++-10         \
      --slave   /usr/bin/gfortran gfortran /usr/bin/gfortran-10    \
      --slave   /usr/bin/gcov     gcov     /usr/bin/gcov-10     && \
    chmod u+s /usr/bin/update-alternatives

RUN apt-get update && apt-get install -y --no-install-recommends \
        ocl-icd-libopencl1 \
        clinfo \
        ocl-icd-opencl-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,graphics,display
# also could have graphics,video,display
# compute -- CUDA and OpenCL
# graphics -- OpenGL and Vulcan
# utility -- nvidia-smi (default)
# video -- video codec sdk
# display -- X11 display
# all -- enable all

## Intel graphics software for computation
#RUN wget -q https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2023.PUB
#RUN apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2023.PUB
#RUN rm -f GPG-PUB-KEY-INTEL-SW-PRODUCTS-2023.PUB
#RUN echo "deb https://apt.repos.intel.com/oneapi all main" >> /etc/apt/sources.list.d/oneAPI.list
#RUN echo "deb [trusted=yes arch=amd64] https://repositories.intel.com/graphics/ubuntu bionic main" >> /etc/apt/sources.list.d/intel-graphics.list
#
#RUN apt-get -qq update && \
#    apt-get -qq install -y \
#             intel-basekit-getting-started \
#             intel-hpckit-getting-started \
#             intel-oneapi-common-vars \
#             intel-oneapi-common-licensing \
#             intel-oneapi-dev-utilities \
#             intel-oneapi-compiler-dpcpp-cpp-and-cpp-classic \
#             intel-oneapi-ifort \
#             intel-opencl && \
#    apt-get clean && rm -rf /var/lib/apt/lists/*

## Generic OpenCL Loader
#RUN apt-get -qq update && \
#    apt-get -qq install -y clinfo ocl-icd-libopencl1 ocl-icd-* opencl-headers && \
#    apt-get clean && rm -rf /var/lib/apt/lists/*
#    #apt-get -qq install -y clinfo ocl-icd-libopencl1 ocl-icd opencl-headers && \

## Nvidia GPU software for computation
## See https://docs.nvidia.com/hpc-sdk/index.html for Nvidia install instructions
#RUN wget --no-verbose https://developer.download.nvidia.com/hpc-sdk/20.9/nvhpc-20-9_20.9_amd64.deb
#RUN wget --no-verbose https://developer.download.nvidia.com/hpc-sdk/20.9/nvhpc-2020_20.9_amd64.deb
#RUN DEBIAN_FRONTEND=noninteractive \
#    apt-get install -y ./nvhpc-20-9_20.9_amd64.deb ./nvhpc-2020_20.9_amd64.deb && \
#    apt-get clean && rm -rf /var/lib/apt/lists/*

## ROCm software installation
#RUN apt-get -qq update && \
#    apt-get -qq install -y libnuma-dev && \
#    apt-get clean && rm -rf /var/lib/apt/lists/*

#RUN wget -qO - http://repo.radeon.com/rocm/apt/debian/rocm.gpg.key | apt-key add -
#RUN echo 'deb [arch=amd64] http://repo.radeon.com/rocm/apt/debian/ xenial main' >> /etc/apt/sources.list.d/rocm.list
#RUN apt-get -qq update && \
#    apt-get -qq install -y rocm-opencl-dev rocm-dkms && \
#    apt-get clean && rm -rf /var/lib/apt/lists/*

## Vendor OpenCL
#RUN apt-get -qq update && \
#    apt-get -qq install -y mesa-opencl-icd && \
#    apt-get clean && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

RUN groupadd chapter5 && useradd -m -s /bin/bash -g chapter5 chapter5

RUN usermod -a -G video chapter5

WORKDIR /home/chapter5
RUN chown -R chapter5:chapter5 /home/chapter5
USER chapter5
#ENV PATH=${PATH}:/opt/rocm/bin:/opt/rocm/profiler/bin:/opt/rocm/opencl/bin/x86_64
#RUN source /opt/intel/oneapi/setvars.sh

RUN git clone --recursive https://github.com/essentialsofparallelcomputing/Chapter5.git

WORKDIR /home/chapter5/Chapter5

RUN clinfo

#RUN make

ENTRYPOINT ["bash"]
