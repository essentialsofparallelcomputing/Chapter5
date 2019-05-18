#!/bin/sh
docker build --no-cache -t chapter5 .
docker run -it --entrypoint /bin/bash chapter5
