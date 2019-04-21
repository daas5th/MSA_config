### 2 Dockerfiles

- Thing one for maven build(`Dockerfiile`) - Image size: 901MB
  - To get this docker image, run:
`docker build -t big:big .`

- Thing two for java run(`Dockerfile.java`) - Image size: 113MB
  - To get this docker image, run:
`docker build -t tiny:tiny -f Dockerfile.java .`

- To run the docker container as a daemon, run:
`docker run -d -p 8061:8061 $IMAGE_ID`

Those docker images serves same services in spite of size differences.

So, [Use multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/)!
