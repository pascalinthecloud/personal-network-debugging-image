# Use the Ubuntu 24.10 base image
FROM ubuntu:24.10

# Update the package list and install iputils-ping and traceroute
RUN apt-get update && \
    apt-get install -y iputils-ping traceroute telnet dnsutils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the default command
