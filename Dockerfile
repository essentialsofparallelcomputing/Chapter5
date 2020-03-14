FROM ubuntu:18.04 AS builder
WORKDIR /project
RUN apt-get update && \
    apt-get install -y bash cmake git vim gcc python3 apt-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

RUN groupadd -r chapter5 && useradd -r -s /bin/false -g chapter5 chapter5

WORKDIR /chapter5
RUN chown -R chapter5:chapter5 /chapter5
USER chapter5

RUN git clone --recursive https://github.com/essentialsofparallelcomputing/Chapter5.git

ENTRYPOINT ["bash"]
