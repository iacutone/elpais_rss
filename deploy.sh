#!/bin/bash

# Deploy script for ElpaisRSS using Kamal
set -e

echo "🚀 Starting deployment of ElpaisRSS..."

# Check if Kamal is installed
if ! command -v kamal &> /dev/null; then
    echo "❌ Kamal is not installed. Installing Kamal..."
    echo "Please install Kamal first: https://kamal-deploy.org/docs/installation/"
    echo "Or run: curl -fsSL https://kamal-deploy.org/install.sh | sh"
    exit 1
fi

# Check if we have the required environment variables
required_vars=("AWS_ACCESS_KEY" "AWS_SECRET_KEY" "EL_PAIS_RSS_URL" "MAILCHIMP_API_KEY" "GOOGLE_GEMINI_API_KEY")
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "❌ Environment variable $var is not set"
        exit 1
    fi
done

# Build and deploy
echo "📦 Building and deploying..."
kamal deploy

echo "✅ Deployment completed successfully!"
echo "🔍 You can check the status with: mix kamal status" 
