#!/bin/bash

# Script Setup Server untuk Partek Assistant
# Jalankan script ini sekali untuk setup awal VPS Ubuntu
# Usage: sudo ./server-setup.sh

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}🚀 Partek Assistant - Server Setup${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}❌ Please run this script as root or with sudo${NC}"
    exit 1
fi

# Step 1: Update System
echo -e "${YELLOW}📦 Step 1/8: Updating system packages...${NC}"
apt update && apt upgrade -y
echo -e "${GREEN}✅ System updated${NC}"
echo ""

# Step 2: Install Node.js
echo -e "${YELLOW}📦 Step 2/8: Installing Node.js...${NC}"
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt install -y nodejs
    echo -e "${GREEN}✅ Node.js installed${NC}"
else
    echo -e "${GREEN}✅ Node.js already installed: $(node --version)${NC}"
fi
echo ""

# Step 3: Install Nginx
echo -e "${YELLOW}📦 Step 3/8: Installing Nginx...${NC}"
if ! command -v nginx &> /dev/null; then
    apt install -y nginx
    systemctl enable nginx
    systemctl start nginx
    echo -e "${GREEN}✅ Nginx installed and started${NC}"
else
    echo -e "${GREEN}✅ Nginx already installed${NC}"
fi
echo ""

# Step 4: Install Git
echo -e "${YELLOW}📦 Step 4/8: Installing Git...${NC}"
if ! command -v git &> /dev/null; then
    apt install -y git
    echo -e "${GREEN}✅ Git installed${NC}"
else
    echo -e "${GREEN}✅ Git already installed${NC}"
fi
echo ""

# Step 5: Install Certbot
echo -e "${YELLOW}📦 Step 5/8: Installing Certbot for SSL...${NC}"
if ! command -v certbot &> /dev/null; then
    apt install -y certbot python3-certbot-nginx
    echo -e "${GREEN}✅ Certbot installed${NC}"
else
    echo -e "${GREEN}✅ Certbot already installed${NC}"
fi
echo ""

# Step 6: Setup Firewall
echo -e "${YELLOW}📦 Step 6/8: Configuring firewall...${NC}"
if command -v ufw &> /dev/null; then
    ufw allow 'Nginx Full'
    ufw allow OpenSSH
    ufw --force enable
    echo -e "${GREEN}✅ Firewall configured${NC}"
else
    echo -e "${YELLOW}⚠️  UFW not found, skipping firewall setup${NC}"
fi
echo ""

# Step 7: Create Application Directory
echo -e "${YELLOW}📦 Step 7/8: Creating application directory...${NC}"
APP_DIR="/var/www/partek"
mkdir -p "$APP_DIR"
chown -R $SUDO_USER:$SUDO_USER "$APP_DIR"
echo -e "${GREEN}✅ Directory created: $APP_DIR${NC}"
echo ""

# Step 8: Install Fail2ban (Security)
echo -e "${YELLOW}📦 Step 8/8: Installing Fail2ban (security)...${NC}"
if ! command -v fail2ban-client &> /dev/null; then
    apt install -y fail2ban
    systemctl enable fail2ban
    systemctl start fail2ban
    echo -e "${GREEN}✅ Fail2ban installed and started${NC}"
else
    echo -e "${GREEN}✅ Fail2ban already installed${NC}"
fi
echo ""

# Summary
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Server setup completed successfully!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}📋 Installed Components:${NC}"
echo "   - Node.js: $(node --version 2>/dev/null || echo 'Not installed')"
echo "   - npm: $(npm --version 2>/dev/null || echo 'Not installed')"
echo "   - Nginx: $(nginx -v 2>&1 | cut -d'/' -f2 || echo 'Not installed')"
echo "   - Git: $(git --version 2>/dev/null | cut -d' ' -f3 || echo 'Not installed')"
echo "   - Certbot: $(certbot --version 2>/dev/null | cut -d' ' -f2 || echo 'Not installed')"
echo ""
echo -e "${BLUE}📝 Next Steps:${NC}"
echo "   1. Configure DNS A record for partek.farzani.space"
echo "   2. Clone/upload your project to $APP_DIR"
echo "   3. Copy nginx-config.conf to /etc/nginx/sites-available/partek.farzani.space"
echo "   4. Enable Nginx site: sudo ln -s /etc/nginx/sites-available/partek.farzani.space /etc/nginx/sites-enabled/"
echo "   5. Test Nginx: sudo nginx -t"
echo "   6. Install SSL: sudo certbot --nginx -d partek.farzani.space"
echo "   7. Run deploy.sh to build and deploy the application"
echo ""
echo -e "${YELLOW}⚠️  Important:${NC}"
echo "   - Make sure DNS is configured before installing SSL"
echo "   - Update nginx-config.conf with your actual paths"
echo ""

