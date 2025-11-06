#!/bin/bash

# Script Deployment untuk Parameter Teknis Radio FM Assistant
# Usage: ./deploy.sh

set -e  # Exit on error

echo "🚀 Starting Parameter Teknis Radio FM Assistant Deployment..."
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if running as root or with sudo
if [ "$EUID" -eq 0 ]; then 
    echo -e "${RED}❌ Please don't run this script as root${NC}"
    exit 1
fi

# Variables
APP_DIR="/var/www/partek"
BUILD_DIR="$APP_DIR/dist"

echo -e "${YELLOW}📋 Checking prerequisites...${NC}"

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js is not installed. Please install Node.js first.${NC}"
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm is not installed. Please install npm first.${NC}"
    exit 1
fi

# Check if directory exists
if [ ! -d "$APP_DIR" ]; then
    echo -e "${YELLOW}⚠️  Directory $APP_DIR does not exist. Creating...${NC}"
    sudo mkdir -p "$APP_DIR"
    sudo chown -R $USER:$USER "$APP_DIR"
fi

# Navigate to app directory
cd "$APP_DIR"

echo -e "${GREEN}✅ Prerequisites check passed${NC}"
echo ""

# Step 1: Pull latest changes (if using git)
if [ -d ".git" ]; then
    echo -e "${YELLOW}📥 Pulling latest changes from git...${NC}"
    git pull origin main || git pull origin master
    echo -e "${GREEN}✅ Git pull completed${NC}"
else
    echo -e "${YELLOW}⚠️  Not a git repository, skipping git pull${NC}"
fi

echo ""

# Step 2: Install dependencies
echo -e "${YELLOW}📦 Installing/updating dependencies...${NC}"
npm install
echo -e "${GREEN}✅ Dependencies installed${NC}"
echo ""

# Step 3: Build application
echo -e "${YELLOW}🔨 Building application for production...${NC}"
npm run build

if [ ! -d "$BUILD_DIR" ]; then
    echo -e "${RED}❌ Build failed! dist directory not found.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Build completed successfully${NC}"
echo ""

# Step 4: Copy missing static files (if any)
echo -e "${YELLOW}📋 Checking for missing static files...${NC}"
if [ -d "$APP_DIR/public" ]; then
    # Copy favicon if missing
    if [ ! -f "$BUILD_DIR/favicon.ico" ] && [ -f "$APP_DIR/public/favicon.ico" ]; then
        cp "$APP_DIR/public/favicon.ico" "$BUILD_DIR/favicon.ico"
        echo -e "${GREEN}✅ Copied favicon.ico${NC}"
    fi
    # Copy PWA icons if missing
    if [ ! -f "$BUILD_DIR/pwa-192x192.png" ] && [ -f "$APP_DIR/public/pwa-192x192.png" ]; then
        cp "$APP_DIR/public/pwa-192x192.png" "$BUILD_DIR/pwa-192x192.png"
    fi
    if [ ! -f "$BUILD_DIR/pwa-512x512.png" ] && [ -f "$APP_DIR/public/pwa-512x512.png" ]; then
        cp "$APP_DIR/public/pwa-512x512.png" "$BUILD_DIR/pwa-512x512.png"
    fi
fi

# Step 5: Set correct permissions
echo -e "${YELLOW}🔐 Setting correct permissions...${NC}"
# Ensure parent directories are accessible
sudo chmod o+x /var/www 2>/dev/null || true
sudo chmod o+x "$APP_DIR" 2>/dev/null || true
# Set ownership and permissions for dist directory
sudo chown -R www-data:www-data "$BUILD_DIR"
sudo chmod -R 755 "$BUILD_DIR"
# Verify Nginx can read
if sudo -u www-data test -r "$BUILD_DIR/index.html"; then
    echo -e "${GREEN}✅ Permissions set correctly${NC}"
else
    echo -e "${YELLOW}⚠️  Fixing permissions...${NC}"
    sudo chmod -R o+r "$BUILD_DIR"
    sudo chmod o+x "$APP_DIR" /var/www
fi
echo ""

# Step 6: Test Nginx configuration
if command -v nginx &> /dev/null; then
    echo -e "${YELLOW}🔍 Testing Nginx configuration...${NC}"
    if sudo nginx -t; then
        echo -e "${GREEN}✅ Nginx configuration is valid${NC}"
        
        # Step 7: Reload Nginx
        echo -e "${YELLOW}🔄 Reloading Nginx...${NC}"
        sudo systemctl reload nginx
        echo -e "${GREEN}✅ Nginx reloaded${NC}"
    else
        echo -e "${RED}❌ Nginx configuration test failed!${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}⚠️  Nginx not found, skipping Nginx reload${NC}"
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Deployment completed successfully!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "🌐 Your application should be available at:"
echo "   https://partek.farzani.space"
echo ""
echo "📝 Next steps:"
echo "   - Verify the application is accessible"
echo "   - Test PWA functionality"
echo "   - Check browser console for any errors"
echo ""

