# Use Alpine Linux as base image
FROM alpine:latest

# Install tzdata package to set timezone
RUN apk add --no-cache tzdata

# Set the timezone to Brussels
RUN cp /usr/share/zoneinfo/Europe/Brussels /etc/localtime && \
    echo "Europe/Brussels" > /etc/timezone

# Define the command to output the current date and time
CMD ["date"]

