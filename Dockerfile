# Use the Ubuntu 24.10 base image
FROM ubuntu:24.10

# Update the package list and install packages
RUN apt-get update && \
    apt-get install -y \
    # Common utilities
    gpg jq vim \
    # Network utilities
    iputils-ping traceroute telnet dnsutils mtr tcpdump curl wget nmap whois speedtest-cli \
    # Database clients
    postgresql-client \
    # Performance testing
    iperf3 \
    # File utilities
    rsync 

# Import the public repository GPG keys & Register the Microsoft Ubuntu repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc |  tee /etc/apt/trusted.gpg.d/microsoft.asc && \ 
    curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | tee /etc/apt/sources.list.d/mssql-release.list

# Import the public repository GPG keys & Register the Kubernetes repository
RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
RUN echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
RUN chmod 644 /etc/apt/sources.list.d/kubernetes.list


# Update the package list and install mssql-tools18, unixodbc-dev and kubectl
RUN apt-get update && \
    ACCEPT_EULA=Y apt-get install mssql-tools18 unixodbc-dev kubectl -y

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add mssql-tools to PATH environment variable permanently
RUN echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bash_profile \
&& echo 'source ~/.bash_profile' >> ~/.bashrc

# Set the default command
CMD ["/bin/bash"]