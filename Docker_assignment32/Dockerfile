# Use a minimal Linux distribution as the base image
FROM alpine:latest

# Download and install the AWS ECS CLI binary
RUN wget -O /usr/local/bin/ecs-cli https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-latest && \
    chmod +x /usr/local/bin/ecs-cli

# Create necessary configuration directories for ecs-cli
RUN mkdir -p /root/.aws /root/.ecs

# Set the entrypoint to the ecs-cli binary
ENTRYPOINT ["ecs-cli"]

# By default, display the usage information when the container is run without any command
CMD ["--version"]

