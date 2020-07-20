#!/bin/sh
docker build --no-cache -t chapter5 .
#docker run -it --entrypoint /bin/bash chapter5
docker build --no-cache -f Dockerfile.Ubuntu20.04 -t chapter5 .
#docker run -it --entrypoint /bin/bash chapter5
docker build --no-cache -f Dockerfile.debian -t chapter5 .
#docker run -it --entrypoint /bin/bash chapter5
