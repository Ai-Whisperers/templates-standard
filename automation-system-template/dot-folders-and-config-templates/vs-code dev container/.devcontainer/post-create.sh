#!/bin/bash

echo "Running post-create setup..."

# Install Python dependencies
if [ -f "requirements.txt" ]; then
    echo "Installing Python dependencies..."
    pip install -r requirements.txt
fi

# Install Node dependencies
if [ -f "package.json" ]; then
    echo "Installing Node dependencies..."
    npm install
fi

# Setup git hooks (if using husky)
if [ -f "package.json" ] && grep -q "husky" package.json; then
    echo "Setting up git hooks..."
    npx husky install
fi

# Create necessary directories
mkdir -p logs
mkdir -p data

# Set permissions
chmod +x scripts/**/*.sh 2>/dev/null || true

echo "Post-create setup complete!"

# CUSTOMIZATION NOTES:
# - Add database initialization scripts
# - Configure environment-specific settings
# - Download test data or fixtures
# - Initialize project-specific tools
# - Run database migrations
# - Seed development data
