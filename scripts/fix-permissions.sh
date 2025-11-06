#!/bin/bash

# Quick fix script untuk permission issues
# Usage: sudo bash fix-permissions.sh

set -e

APP_DIR="/var/www/partek"
DIST_DIR="$APP_DIR/dist"

echo "🔧 Fixing permissions..."

# Fix ownership
echo "Setting ownership to www-data..."
chown -R www-data:www-data "$DIST_DIR"

# Fix directory permissions
echo "Setting directory permissions..."
find "$DIST_DIR" -type d -exec chmod 755 {} \;

# Fix file permissions
echo "Setting file permissions..."
find "$DIST_DIR" -type f -exec chmod 644 {} \;

# Ensure parent directories are accessible
chmod o+x /var/www
chmod o+x "$APP_DIR"

echo "✅ Permissions fixed!"
echo ""
echo "Reloading Nginx..."
systemctl reload nginx

echo "✅ Done!"

