#!/bin/bash
ver=0.14
docker build -t vifm:${ver} .
docker run -d --name vifm-build --rm vifm:${ver} bash -c 'sleep 60s'
docker cp vifm-build:/tmp/vifm-${ver}.deb ./
