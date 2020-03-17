FROM ubuntu:18.04 AS builder
WORKDIR /project
RUN apt-get update && \
    apt-get install -y bash cmake git vim gcc python3 apt-utils software-properties-common && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update && \
    apt-get install -y gcc-9 g++-9 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 90 --slave /usr/bin/g++ g++ /usr/bin/g++-9 --slave /usr/bin/gcov gcov /usr/bin/gcov-9

SHELL ["/bin/bash", "-c"]

RUN groupadd chapter5 && useradd -m -s /bin/bash -g chapter5 chapter5

WORKDIR /home/chapter5
RUN chown -R chapter5:chapter5 /home/chapter5
USER chapter5

RUN git clone --recursive https://github.com/essentialsofparallelcomputing/Chapter5.git

ENTRYPOINT ["bash"]
