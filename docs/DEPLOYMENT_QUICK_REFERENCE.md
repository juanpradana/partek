# Deployment Quick Reference

Quick reference untuk perintah-perintah penting saat deployment.

## Perintah Umum

### Setup Awal Server
```bash
# Jalankan script setup (sekali saja)
sudo bash server-setup.sh
```

### Deployment
```bash
# Jalankan script deployment
bash deploy.sh

# Atau manual
cd /var/www/partek
git pull origin main
npm install
npm run build
sudo systemctl reload nginx
```

### Nginx Commands
```bash
# Test konfigurasi
sudo nginx -t

# Reload Nginx (tanpa downtime)
sudo systemctl reload nginx

# Restart Nginx
sudo systemctl restart nginx

# Check status
sudo systemctl status nginx

# View error logs
sudo tail -f /var/log/nginx/error.log

# View access logs
sudo tail -f /var/log/nginx/access.log
```

### SSL Certificate
```bash
# Install SSL certificate
sudo certbot --nginx -d partek.farzani.space

# Check certificate status
sudo certbot certificates

# Renew certificate (manual)
sudo certbot renew

# Test renewal
sudo certbot renew --dry-run
```

### File Permissions
```bash
# Set ownership untuk www-data
sudo chown -R www-data:www-data /var/www/partek/dist

# Set permissions
sudo chmod -R 755 /var/www/partek/dist
```

### Troubleshooting

#### Check Ports
```bash
# Check if port 80 and 443 are open
sudo netstat -tulpn | grep :80
sudo netstat -tulpn | grep :443

# Or using ss
sudo ss -tulpn | grep :80
sudo ss -tulpn | grep :443
```

#### Check DNS
```bash
# Check DNS resolution
dig partek.farzani.space
nslookup partek.farzani.space
ping partek.farzani.space
```

#### Check Application
```bash
# Check if build directory exists
ls -la /var/www/partek/dist

# Check if index.html exists
ls -la /var/www/partek/dist/index.html

# Check file sizes
du -sh /var/www/partek/dist/*
```

#### Check Node.js
```bash
# Check Node.js version
node --version

# Check npm version
npm --version

# Check global packages
npm list -g --depth=0
```

### Backup
```bash
# Manual backup
sudo tar -czf /var/backups/partek_$(date +%Y%m%d).tar.gz /var/www/partek

# Restore backup
sudo tar -xzf /var/backups/partek_YYYYMMDD.tar.gz -C /
```

### Logs Location
```bash
# Nginx logs
/var/log/nginx/access.log
/var/log/nginx/error.log

# System logs
/var/log/syslog

# Application (if using PM2)
~/.pm2/logs/
```

### Common Issues & Solutions

#### Issue: 502 Bad Gateway
```bash
# Check Nginx error logs
sudo tail -f /var/log/nginx/error.log

# Check if directory exists
ls -la /var/www/partek/dist

# Check permissions
ls -la /var/www/partek/dist
```

#### Issue: SSL Certificate Error
```bash
# Renew certificate
sudo certbot renew

# Check certificate expiry
sudo certbot certificates
```

#### Issue: Build Fails
```bash
# Clear npm cache
npm cache clean --force

# Delete node_modules and reinstall
rm -rf node_modules package-lock.json
npm install

# Check Node.js version (should be 16+)
node --version
```

#### Issue: PWA Not Working
- Check HTTPS is enabled
- Check browser console for errors
- Verify service worker in DevTools > Application > Service Workers
- Clear browser cache

### Monitoring

#### Disk Space
```bash
# Check disk usage
df -h

# Check directory size
du -sh /var/www/partek
```

#### Memory Usage
```bash
# Check memory
free -h

# Check top processes
top
```

#### System Resources
```bash
# System overview
htop

# Or
sudo apt install htop
htop
```

### Security Checks

#### Check Firewall
```bash
# UFW status
sudo ufw status

# Check iptables
sudo iptables -L -n -v
```

#### Check SSH
```bash
# SSH status
sudo systemctl status ssh

# Check SSH config
sudo nano /etc/ssh/sshd_config
```

### Update System
```bash
# Update packages
sudo apt update && sudo apt upgrade -y

# Update Node.js (if needed)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
```

## File Locations

### Application
- Project directory: `/var/www/partek`
- Build output: `/var/www/partek/dist`
- Nginx config: `/etc/nginx/sites-available/partek.farzani.space`
- Nginx enabled: `/etc/nginx/sites-enabled/partek.farzani.space`

### SSL Certificates
- Certificate: `/etc/letsencrypt/live/partek.farzani.space/fullchain.pem`
- Private key: `/etc/letsencrypt/live/partek.farzani.space/privkey.pem`
- Chain: `/etc/letsencrypt/live/partek.farzani.space/chain.pem`

### Logs
- Nginx access: `/var/log/nginx/access.log`
- Nginx error: `/var/log/nginx/error.log`
- System: `/var/log/syslog`

## Quick Deployment Checklist

- [ ] DNS A record configured
- [ ] Server setup completed (`server-setup.sh`)
- [ ] Project cloned/uploaded to `/var/www/partek`
- [ ] Nginx config created and enabled
- [ ] SSL certificate installed
- [ ] Application built (`npm run build`)
- [ ] Permissions set correctly
- [ ] Nginx reloaded
- [ ] Application accessible via HTTPS
- [ ] PWA tested and working

## Emergency Rollback

Jika ada masalah setelah deployment:

```bash
# 1. Disable site
sudo rm /etc/nginx/sites-enabled/partek.farzani.space
sudo systemctl reload nginx

# 2. Restore from backup
sudo tar -xzf /var/backups/partek_YYYYMMDD.tar.gz -C /

# 3. Re-enable site
sudo ln -s /etc/nginx/sites-available/partek.farzani.space /etc/nginx/sites-enabled/
sudo systemctl reload nginx
```

---

**Tip**: Bookmark halaman ini untuk referensi cepat saat deployment!

