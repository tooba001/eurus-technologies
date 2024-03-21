# Use Alpine Linux as base image
FROM alpine:latest

# Install Docker and necessary dependencies
RUN apk add --no-cache docker

# Set the entrypoint to start Docker in the foreground
ENTRYPOINT ["dockerd", "--host=unix:///var/run/docker.sock", "--host=tcp://0.0.0.0:237"]  
