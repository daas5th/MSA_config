### Dockerfiles

- For java run(`Dockerfile`)
  - To get the docker image, run:
`docker build -t config-service:latest .`

- To run the docker container as a daemon, run:
`docker run -d -p 8088:8088 $IMAGE_ID`
