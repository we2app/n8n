FROM ubuntu:24.04

LABEL maintainer="atik@we2app.com" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.name="Base Image" \
      org.label-schema.description="Base Image for all images - base on Ubuntu 20.04" 
      
ENV DEBIAN_FRONTEND=noninteractive \
      TERM=xterm

# Set working directory
WORKDIR /home/node

# Install OS dependencies (glibc, build tools, native module dependencies)
RUN apt-get update && apt-get install -y \
    build-essential \
    python3 \
    python3-dev \
    git \
    curl \
    wget \
    ca-certificates \
    gnupg \
    libsqlite3-dev \
    libssl-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20.x (LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Update npm to latest version
RUN npm install -g npm@latest

# Create node user and set up directories
RUN groupadd -r node && useradd -r -g node -s /bin/bash node \
    && chown -R node:node /home/node

# Install n8n globally with better-sqlite3 instead of sqlite3
RUN npm install -g n8n --ignore-scripts \
    && npm rebuild --build-from-source

# Switch to non-root user (optional but recommended)
USER node

# Install Kokoro TTS node
RUN npm install n8n-nodes-kokoro

# Expose n8n port
EXPOSE 5678

# Start n8n
ENTRYPOINT ["n8n"]
