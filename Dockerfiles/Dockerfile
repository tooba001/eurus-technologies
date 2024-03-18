# question Create a dockerfile from alpine base image and install and configure awscli. The proposal for this container is to run awscli commands, after that it should die. You must provide the awscli command via entrypoint
# Use Alpine Linux as base image
FROM alpine:latest

# Install AWS CLI using package manager
RUN apk --no-cache add \
    aws-cli
# Set entrypoint to aws command
ENTRYPOINT ["aws"]


