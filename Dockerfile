FROM ubuntu:24.04

LABEL maintainer="atik@we2app.com" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.name="Base Image" \
      org.label-schema.description="Base Image for all images - base on Ubuntu 20.04" 
      
ENV DEBIAN_FRONTEND=noninteractive \
      TERM=xterm

# Set working directory
WORKDIR /home/node

# Install OS dependencies (glibc, build tools)
RUN apt-get update && apt-get install -y \
    build-essential \
    python3 \
    git \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install n8n globally
RUN npm install -g n8n

# Switch to non-root user (optional but recommended)
USER node

# Install Kokoro TTS node
RUN npm install n8n-nodes-kokoro

# Expose n8n port
EXPOSE 5678

# Start n8n
ENTRYPOINT ["n8n"]
