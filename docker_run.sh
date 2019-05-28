#!/bin/sh

docker run -d -p 8060-8061:8060-8061 -p 8088:8088 -p 8090-8092:8090-8092 -p 9090:9090 --name config-service config-service:latest
