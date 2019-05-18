FROM ubuntu AS builder
WORKDIR /project
RUN apt-get update && \
    apt-get install -y bash cmake git vim gcc python3
RUN git clone --recursive https://github.com/essentialsofparallelcomputing/Chapter5.git

RUN bash

ENTRYPOINT ["bash"]
