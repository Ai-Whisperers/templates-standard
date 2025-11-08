FROM mcr.microsoft.com/devcontainers/python:3.11

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Install additional tools
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    vim \
    htop \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Install Python dependencies (if requirements.txt exists)
# COPY requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt

# Install Node dependencies (if package.json exists)
# COPY package.json package-lock.json .
# RUN npm ci

# CUSTOMIZATION NOTES:
# - Add project-specific system dependencies
# - Uncomment and configure dependency installation
# - Add build tools if needed
# - Configure timezone, locale, etc.
# - Install language-specific tools (go, rust, java, etc.)
