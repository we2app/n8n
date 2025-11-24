FROM node:20-bookworm-slim

LABEL maintainer="atik@we2app.com" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.name="n8n Docker Image" \
      org.label-schema.description="n8n workflow automation with Kokoro TTS support"

# Install only required runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV NODE_ENV=production \
    N8N_PORT=5678

# Set working directory
WORKDIR /home/node

# Install n8n globally (standard npm installation)
RUN npm install -g n8n

# Switch to non-root user
USER node

# Expose n8n port
EXPOSE 5678

# Start n8n
CMD ["n8n"]
