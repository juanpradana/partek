#!/bin/bash

# Script Troubleshooting untuk Error 500
# Jalankan script ini di VPS untuk mendiagnosis masalah

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}🔍 Troubleshooting Error 500${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

APP_DIR="/var/www/partek"
DIST_DIR="$APP_DIR/dist"

# Check 1: Directory exists
echo -e "${YELLOW}1. Checking directories...${NC}"
if [ ! -d "$DIST_DIR" ]; then
    echo -e "${RED}❌ Directory $DIST_DIR tidak ditemukan!${NC}"
    echo "   Solusi: Jalankan npm run build"
    exit 1
else
    echo -e "${GREEN}✅ Directory $DIST_DIR ada${NC}"
fi

# Check 2: Index.html exists
echo -e "${YELLOW}2. Checking index.html...${NC}"
if [ ! -f "$DIST_DIR/index.html" ]; then
    echo -e "${RED}❌ index.html tidak ditemukan di $DIST_DIR${NC}"
    echo "   Solusi: Rebuild aplikasi dengan npm run build"
    exit 1
else
    echo -e "${GREEN}✅ index.html ada${NC}"
    ls -lh "$DIST_DIR/index.html"
fi

# Check 3: Favicon exists
echo -e "${YELLOW}3. Checking favicon.ico...${NC}"
if [ ! -f "$DIST_DIR/favicon.ico" ]; then
    echo -e "${YELLOW}⚠️  favicon.ico tidak ditemukan di $DIST_DIR${NC}"
    echo "   Checking di public folder..."
    if [ -f "$APP_DIR/public/favicon.ico" ]; then
        echo -e "${YELLOW}   favicon.ico ada di public/, akan di-copy...${NC}"
        cp "$APP_DIR/public/favicon.ico" "$DIST_DIR/favicon.ico"
        echo -e "${GREEN}✅ favicon.ico di-copy ke dist/${NC}"
    else
        echo -e "${RED}   favicon.ico juga tidak ada di public/${NC}"
        echo "   Membuat dummy favicon..."
        # Create empty favicon as fallback
        touch "$DIST_DIR/favicon.ico"
        echo -e "${YELLOW}   Dummy favicon dibuat${NC}"
    fi
else
    echo -e "${GREEN}✅ favicon.ico ada${NC}"
    ls -lh "$DIST_DIR/favicon.ico"
fi

# Check 4: Permissions
echo -e "${YELLOW}4. Checking permissions...${NC}"
echo "   Current ownership:"
ls -ld "$DIST_DIR" | awk '{print "   " $3 ":" $4 " " $1}'

# Fix permissions
echo -e "${YELLOW}   Fixing permissions...${NC}"
sudo chown -R www-data:www-data "$DIST_DIR"
sudo chmod -R 755 "$DIST_DIR"
echo -e "${GREEN}✅ Permissions updated${NC}"

# Verify permissions
if [ -r "$DIST_DIR/index.html" ]; then
    echo -e "${GREEN}✅ Nginx (www-data) dapat membaca index.html${NC}"
else
    echo -e "${RED}❌ Nginx tidak dapat membaca index.html${NC}"
    echo "   Checking detailed permissions..."
    ls -la "$DIST_DIR/index.html"
fi

# Check 5: Nginx user can access
echo -e "${YELLOW}5. Testing Nginx access...${NC}"
if sudo -u www-data test -r "$DIST_DIR/index.html"; then
    echo -e "${GREEN}✅ www-data dapat membaca file${NC}"
else
    echo -e "${RED}❌ www-data tidak dapat membaca file${NC}"
    echo "   Fixing..."
    sudo chmod -R o+r "$DIST_DIR"
    sudo chmod -R o+x "$APP_DIR"
fi

# Check 6: Nginx configuration
echo -e "${YELLOW}6. Checking Nginx configuration...${NC}"
if sudo nginx -t 2>&1 | grep -q "successful"; then
    echo -e "${GREEN}✅ Nginx configuration valid${NC}"
else
    echo -e "${RED}❌ Nginx configuration error${NC}"
    sudo nginx -t
fi

# Check 7: Nginx error logs
echo -e "${YELLOW}7. Checking recent Nginx errors...${NC}"
if [ -f "/var/log/nginx/error.log" ]; then
    echo "   Last 10 error log lines:"
    sudo tail -n 10 /var/log/nginx/error.log | sed 's/^/   /'
else
    echo -e "${YELLOW}   Error log tidak ditemukan${NC}"
fi

# Check 8: SELinux (if applicable)
echo -e "${YELLOW}8. Checking SELinux (if applicable)...${NC}"
if command -v getenforce &> /dev/null; then
    SELINUX_STATUS=$(getenforce)
    echo "   SELinux status: $SELINUX_STATUS"
    if [ "$SELINUX_STATUS" != "Disabled" ]; then
        echo -e "${YELLOW}   SELinux enabled, setting context...${NC}"
        sudo chcon -R -t httpd_sys_content_t "$DIST_DIR" 2>/dev/null || echo "   SELinux context update skipped"
    fi
else
    echo -e "${GREEN}   SELinux tidak terinstall${NC}"
fi

# Check 9: File structure
echo -e "${YELLOW}9. Checking dist directory structure...${NC}"
echo "   Files in dist/:"
ls -lh "$DIST_DIR" | head -10 | sed 's/^/   /'

# Check 10: Missing static assets
echo -e "${YELLOW}10. Checking for missing static assets...${NC}"
MISSING_FILES=()

if [ ! -f "$DIST_DIR/favicon.ico" ]; then
    MISSING_FILES+=("favicon.ico")
fi

if [ ! -f "$DIST_DIR/pwa-192x192.png" ]; then
    MISSING_FILES+=("pwa-192x192.png")
fi

if [ ! -f "$DIST_DIR/pwa-512x512.png" ]; then
    MISSING_FILES+=("pwa-512x512.png")
fi

if [ ${#MISSING_FILES[@]} -gt 0 ]; then
    echo -e "${YELLOW}   Missing files: ${MISSING_FILES[*]}${NC}"
    echo "   Copying from public/ if available..."
    for file in "${MISSING_FILES[@]}"; do
        if [ -f "$APP_DIR/public/$file" ]; then
            cp "$APP_DIR/public/$file" "$DIST_DIR/$file"
            echo -e "${GREEN}   ✅ Copied $file${NC}"
        fi
    done
    # Fix permissions again after copying
    sudo chown -R www-data:www-data "$DIST_DIR"
else
    echo -e "${GREEN}✅ All required static assets present${NC}"
fi

# Final fix: Ensure all parent directories are accessible
echo -e "${YELLOW}11. Ensuring parent directory access...${NC}"
sudo chmod o+x "$APP_DIR"
sudo chmod o+x /var/www
echo -e "${GREEN}✅ Parent directories accessible${NC}"

# Summary
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Troubleshooting completed!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}📝 Next steps:${NC}"
echo "   1. Reload Nginx: sudo systemctl reload nginx"
echo "   2. Test: curl -I https://partek.farzani.space"
echo "   3. Check browser console for any remaining errors"
echo ""
echo -e "${YELLOW}💡 If error persists:${NC}"
echo "   - Check Nginx error log: sudo tail -f /var/log/nginx/error.log"
echo "   - Rebuild application: cd $APP_DIR && npm run build"
echo "   - Verify file ownership: ls -la $DIST_DIR"
echo ""

