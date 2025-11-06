# Panduan Deployment ke VPS Ubuntu

Panduan lengkap untuk mendeploy aplikasi Parameter Teknis Radio FM Assistant ke VPS Ubuntu dengan subdomain `partek.farzani.space`.

## Prasyarat

- VPS Ubuntu 20.04 atau lebih baru
- Akses root atau user dengan sudo privileges
- Domain `farzani.space` sudah terhubung ke IP VPS
- Port 80 dan 443 terbuka di firewall

## Langkah-langkah Deployment

### 1. Persiapan Server

#### 1.1 Update Sistem

```bash
sudo apt update && sudo apt upgrade -y
```

#### 1.2 Install Dependencies

```bash
# Install Node.js dan npm (untuk build aplikasi)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Verifikasi instalasi
node --version
npm --version

# Install Nginx
sudo apt install -y nginx

# Install Git (jika belum ada)
sudo apt install -y git

# Install Certbot untuk SSL
sudo apt install -y certbot python3-certbot-nginx
```

#### 1.3 Setup Firewall

```bash
# Aktifkan UFW jika belum aktif
sudo ufw allow 'Nginx Full'
sudo ufw allow OpenSSH
sudo ufw enable
sudo ufw status
```

### 2. Konfigurasi Domain DNS

Pastikan DNS A record untuk subdomain sudah dikonfigurasi:

```
Type: A
Name: partek
Value: [IP_VPS_ANDA]
TTL: 3600
```

Verifikasi dengan:

```bash
ping partek.farzani.space
```

### 3. Setup Repository dan Build Aplikasi

#### 3.1 Clone Repository

```bash
# Buat direktori untuk aplikasi
sudo mkdir -p /var/www/partek
sudo chown -R $USER:$USER /var/www/partek

# Clone repository (ganti dengan URL repo Anda)
cd /var/www/partek
git clone [URL_REPOSITORY_ANDA] .

# Atau jika menggunakan metode lain, upload file project ke direktori ini
```

#### 3.2 Build Aplikasi

```bash
cd /var/www/partek

# Install dependencies
npm install

# Build aplikasi untuk production
npm run build

# File hasil build akan ada di folder dist/
```

### 4. Konfigurasi Nginx

#### 4.1 Buat Konfigurasi Nginx

```bash
sudo nano /etc/nginx/sites-available/partek.farzani.space
```

Tambahkan konfigurasi berikut:

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name partek.farzani.space;

    root /var/www/partek/dist;
    index index.html;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/javascript application/json;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    # PWA support - cache service worker
    location ~* /sw\.js$ {
        expires off;
        add_header Cache-Control "no-cache, no-store, must-revalidate";
        add_header Pragma "no-cache";
    }

    # Cache static assets
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|woff|woff2|ttf|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # SPA routing - semua route mengarah ke index.html
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Error pages
    error_page 404 /index.html;
}
```

#### 4.2 Aktifkan Konfigurasi

```bash
# Buat symbolic link
sudo ln -s /etc/nginx/sites-available/partek.farzani.space /etc/nginx/sites-enabled/

# Test konfigurasi Nginx
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx
sudo systemctl enable nginx
```

### 5. Setup SSL dengan Let's Encrypt

#### 5.1 Install SSL Certificate

```bash
sudo certbot --nginx -d partek.farzani.space
```

Ikuti instruksi:
- Masukkan email Anda
- Setujui terms of service
- Pilih untuk redirect HTTP ke HTTPS (recommended: 2)

#### 5.2 Auto-renewal (Sudah Otomatis)

Certbot akan otomatis membuat cron job untuk renew certificate. Verifikasi:

```bash
sudo certbot renew --dry-run
```

### 6. Update Konfigurasi Nginx untuk HTTPS

Setelah SSL terinstall, Certbot akan otomatis mengupdate konfigurasi. File akan terlihat seperti ini:

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name partek.farzani.space;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name partek.farzani.space;

    ssl_certificate /etc/letsencrypt/live/partek.farzani.space/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/partek.farzani.space/privkey.pem;
    
    # SSL Configuration
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    root /var/www/partek/dist;
    index index.html;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/javascript application/json;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    # PWA support - cache service worker
    location ~* /sw\.js$ {
        expires off;
        add_header Cache-Control "no-cache, no-store, must-revalidate";
        add_header Pragma "no-cache";
    }

    # Cache static assets
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|woff|woff2|ttf|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # SPA routing
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Error pages
    error_page 404 /index.html;
}
```

### 7. Verifikasi Deployment

1. Akses `https://partek.farzani.space` di browser
2. Pastikan SSL certificate valid (gembok hijau)
3. Test fitur PWA:
   - Install prompt muncul
   - Offline mode berfungsi
   - Service worker terdaftar

### 8. Update Deployment (Setelah Ada Perubahan)

#### 8.1 Manual Update

```bash
cd /var/www/partek

# Pull perubahan terbaru (jika menggunakan Git)
git pull origin main

# Install dependencies baru (jika ada)
npm install

# Rebuild aplikasi
npm run build

# Restart Nginx (optional, biasanya tidak perlu)
sudo systemctl reload nginx
```

#### 8.2 Otomatisasi dengan Script

Buat script untuk memudahkan update:

```bash
sudo nano /usr/local/bin/deploy-partek.sh
```

Tambahkan isi berikut:

```bash
#!/bin/bash

echo "🚀 Starting deployment..."

cd /var/www/partek

# Pull latest changes
echo "📥 Pulling latest changes..."
git pull origin main

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Build application
echo "🔨 Building application..."
npm run build

# Reload Nginx
echo "🔄 Reloading Nginx..."
sudo systemctl reload nginx

echo "✅ Deployment completed!"
```

Beri permission:

```bash
sudo chmod +x /usr/local/bin/deploy-partek.sh
```

Jalankan dengan:

```bash
deploy-partek.sh
```

### 9. Monitoring dan Maintenance

#### 9.1 Check Nginx Status

```bash
sudo systemctl status nginx
```

#### 9.2 Check Nginx Logs

```bash
# Access logs
sudo tail -f /var/log/nginx/access.log

# Error logs
sudo tail -f /var/log/nginx/error.log
```

#### 9.3 Check Certificate Expiry

```bash
sudo certbot certificates
```

#### 9.4 Backup

Buat script backup sederhana:

```bash
sudo nano /usr/local/bin/backup-partek.sh
```

```bash
#!/bin/bash
BACKUP_DIR="/var/backups/partek"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR
tar -czf $BACKUP_DIR/partek_$DATE.tar.gz /var/www/partek

# Hapus backup lebih dari 7 hari
find $BACKUP_DIR -type f -mtime +7 -delete

echo "✅ Backup completed: partek_$DATE.tar.gz"
```

```bash
sudo chmod +x /usr/local/bin/backup-partek.sh
```

Jadwalkan dengan cron:

```bash
sudo crontab -e
```

Tambahkan (backup setiap hari jam 2 pagi):

```
0 2 * * * /usr/local/bin/backup-partek.sh
```

### 10. Troubleshooting

#### 10.1 Aplikasi tidak bisa diakses

```bash
# Check Nginx status
sudo systemctl status nginx

# Check Nginx configuration
sudo nginx -t

# Check error logs
sudo tail -f /var/log/nginx/error.log

# Check firewall
sudo ufw status
```

#### 10.2 SSL Certificate Error

```bash
# Renew certificate manually
sudo certbot renew

# Check certificate status
sudo certbot certificates
```

#### 10.3 Build Error

```bash
# Check Node.js version
node --version

# Clear npm cache
npm cache clean --force

# Delete node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
```

#### 10.4 PWA tidak berfungsi

- Pastikan menggunakan HTTPS (required untuk PWA)
- Check browser console untuk error
- Verify service worker terdaftar di DevTools > Application > Service Workers
- Clear browser cache dan hard reload

### 11. Security Best Practices

1. **Update sistem secara berkala:**
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

2. **Gunakan fail2ban untuk mencegah brute force:**
   ```bash
   sudo apt install -y fail2ban
   sudo systemctl enable fail2ban
   ```

3. **Setup SSH key authentication (lebih aman dari password)**

4. **Disable root login SSH:**
   ```bash
   sudo nano /etc/ssh/sshd_config
   # Set: PermitRootLogin no
   sudo systemctl restart sshd
   ```

5. **Regular backup** (sudah dijelaskan di section 9.4)

## Checklist Deployment

- [ ] VPS Ubuntu sudah terinstall
- [ ] Node.js dan npm terinstall
- [ ] Nginx terinstall dan running
- [ ] DNS A record untuk partek.farzani.space sudah dikonfigurasi
- [ ] Repository sudah di-clone/upload ke /var/www/partek
- [ ] Aplikasi sudah di-build (npm run build)
- [ ] Konfigurasi Nginx sudah dibuat dan diaktifkan
- [ ] SSL certificate sudah terinstall
- [ ] Aplikasi bisa diakses via https://partek.farzani.space
- [ ] PWA berfungsi dengan baik
- [ ] Backup script sudah dibuat
- [ ] Monitoring setup sudah dikonfigurasi

## Catatan Penting

1. **Base URL**: Pastikan aplikasi menggunakan relative paths, tidak hardcode domain
2. **Environment Variables**: Jika ada, gunakan file `.env` atau environment variables di Nginx
3. **File Permissions**: Pastikan Nginx user (www-data) bisa membaca file di /var/www/partek/dist
4. **PWA**: Service worker hanya bekerja di HTTPS atau localhost

## Kontak & Support

Jika ada masalah saat deployment, check:
- Nginx error logs: `/var/log/nginx/error.log`
- Application logs (jika ada)
- Browser console untuk client-side errors

---

**Selamat! Aplikasi Anda sudah berhasil di-deploy! 🎉**

