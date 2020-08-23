# Part of the examples from the Parallel and High Performance Computing
# Robey and Zamora, Manning Publications
#   https://github.com/EssentialsofParallelComputing/Chapter4
#
# The built image can be found at:
#
#   https://hub.docker.com/r/essentialsofparallelcomputing/chapter4
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
            python3 wget gnupg-agent \
            mpich libmpich-dev \
            openmpi-bin openmpi-doc libopenmpi-dev

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

# Intel graphics software for computation
RUN wget -q https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2023.PUB
RUN apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2023.PUB
RUN rm -f GPG-PUB-KEY-INTEL-SW-PRODUCTS-2023.PUB
RUN echo "deb https://apt.repos.intel.com/oneapi all main" >> /etc/apt/sources.list.d/oneAPI.list
RUN echo "deb [trusted=yes arch=amd64] https://repositories.intel.com/graphics/ubuntu bionic main" >> /etc/apt/sources.list.d/intel-graphics.list

RUN apt-get -qq update && \
    apt-get -qq install -y \
             intel-basekit-getting-started \
             intel-hpckit-getting-started \
             intel-oneapi-common-vars \
             intel-oneapi-common-licensing \
             intel-oneapi-dev-utilities \
             intel-oneapi-icc \
             intel-oneapi-ifort \
             intel-opencl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Generic OpenCL Loader
RUN apt-get -qq update && \
    apt-get -qq install -y clinfo ocl-icd-libopencl1 ocl-icd-* opencl-headers && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
    #apt-get -qq install -y clinfo ocl-icd-libopencl1 ocl-icd opencl-headers && \

# Nvidia GPU software for computation
RUN wget -q https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.2.89-1_amd64.deb
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
RUN dpkg -i cuda-repo-ubuntu1804_10.2.89-1_amd64.deb
RUN apt-get -qq update && \
    apt-get -qq install -y cuda-toolkit-10-2 cuda-tools-10-2 cuda-compiler-10-2 \
        cuda-libraries-10-2 cuda-libraries-dev-10-2 libnvidia-compute-450 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

#RUN wget -q https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804-11-0-local_11.0.1-450.36.06-1_amd64.deb
#RUN dpkg -i cuda-repo-ubuntu1804-11-0-local_11.0.1-450.36.06-1_amd64.deb
#RUN wget -q https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.2.89-1_amd64.deb
#RUN wget -q https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-11-0_11.0.1-1_amd64.deb
#RUN dpkg -i cuda-11-0_11.0.1-1_amd64.deb

# ROCm software installation
RUN apt-get -qq update && \
    apt-get -qq install -y libnuma-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN wget -qO - http://repo.radeon.com/rocm/apt/debian/rocm.gpg.key | apt-key add -
RUN echo 'deb [arch=amd64] http://repo.radeon.com/rocm/apt/debian/ xenial main' >> /etc/apt/sources.list.d/rocm.list
RUN apt-get -qq update && \
    apt-get -qq install -y rocm-opencl-dev rocm-dkms && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Vendor OpenCL
RUN apt-get -qq update && \
    apt-get -qq install -y mesa-opencl-icd && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

RUN groupadd chapter5 && useradd -m -s /bin/bash -g chapter5 chapter5

RUN usermod -a -G video chapter5

WORKDIR /home/chapter5
RUN chown -R chapter5:chapter5 /home/chapter5
USER chapter5
ENV PATH=${PATH}:/opt/rocm/bin:/opt/rocm/profiler/bin:/opt/rocm/opencl/bin/x86_64
ENV PATH=/usr/local/cuda-10.2/bin:/usr/local/cuda-10.2/NsightCompute-2019.1${PATH:+:${PATH}}
ENV LD_LIBRARY_PATH=/usr/local/cuda-10.2/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
#RUN source /opt/intel/oneapi/setvars.sh

RUN git clone --recursive https://github.com/essentialsofparallelcomputing/Chapter5.git

WORKDIR /home/chapter5/Chapter5
#RUN make

ENTRYPOINT ["bash"]
