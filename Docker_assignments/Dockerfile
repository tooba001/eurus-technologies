# question Create a dockerfile from alpine base image and install and configure awscli. The proposal for this container is to run awscli commands, after that it should die. You must provide the awscli command via entrypoint
# Use Alpine Linux as base image
FROM alpine:latest

# Use the RUN instruction to execute commands within the Docker image
RUN apk add --no-cache aws-cli

# Set the entrypoint to aws
ENTRYPOINT ["aws"]

CMD ["--version"]




