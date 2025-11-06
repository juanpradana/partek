# Troubleshooting Guide - Error 500

Panduan untuk mengatasi error 500 Internal Server Error setelah deployment.

## Gejala Error 500

Error yang muncul di browser:
- `GET https://partek.farzani.space/favicon.ico 500 (Internal Server Error)`
- `Failed to load resource: the server responded with a status of 500`

## Penyebab Umum

### 1. Permission Issues (Paling Sering)

Nginx berjalan sebagai user `www-data` dan tidak memiliki akses untuk membaca file di direktori `dist/`.

**Solusi:**

```bash
# Jalankan script fix permissions
sudo bash fix-permissions.sh

# Atau manual:
sudo chown -R www-data:www-data /var/www/partek/dist
sudo chmod -R 755 /var/www/partek/dist
sudo chmod o+x /var/www/partek
sudo chmod o+x /var/www
sudo systemctl reload nginx
```

### 2. File Tidak Ada

File `favicon.ico` atau file lainnya tidak ada di direktori `dist/` setelah build.

**Solusi:**

```bash
cd /var/www/partek

# Rebuild aplikasi
npm run build

# Pastikan file ter-copy
ls -la dist/

# Copy manual jika perlu
cp public/favicon.ico dist/favicon.ico
cp public/*.png dist/

# Fix permissions setelah copy
sudo chown -R www-data:www-data dist/
```

### 3. Direktori dist/ Tidak Ada

Aplikasi belum di-build atau build gagal.

**Solusi:**

```bash
cd /var/www/partek

# Install dependencies
npm install

# Build aplikasi
npm run build

# Verify build
ls -la dist/

# Fix permissions
sudo chown -R www-data:www-data dist/
sudo chmod -R 755 dist/
```

### 4. Nginx Configuration Error

Konfigurasi Nginx salah atau path tidak sesuai.

**Solusi:**

```bash
# Test konfigurasi
sudo nginx -t

# Check error
sudo tail -f /var/log/nginx/error.log

# Verify root path di config
sudo grep -r "root" /etc/nginx/sites-available/partek.farzani.space
```

### 5. SELinux Issues (Jika SELinux Enabled)

SELinux memblokir akses Nginx ke file.

**Solusi:**

```bash
# Check SELinux status
getenforce

# Jika enabled, set context
sudo chcon -R -t httpd_sys_content_t /var/www/partek/dist

# Atau disable SELinux (tidak recommended untuk production)
# sudo setenforce 0
```

## Langkah Troubleshooting Lengkap

### Step 1: Jalankan Script Troubleshooting

```bash
# Download/copy script ke server
bash troubleshoot-500.sh
```

Script ini akan:
- ✅ Check semua directory dan file
- ✅ Fix permissions
- ✅ Copy missing files
- ✅ Verify Nginx access
- ✅ Check error logs

### Step 2: Check Nginx Error Logs

```bash
# View real-time error logs
sudo tail -f /var/log/nginx/error.log

# View last 50 lines
sudo tail -n 50 /var/log/nginx/error.log

# Search for specific errors
sudo grep -i "permission denied" /var/log/nginx/error.log
sudo grep -i "no such file" /var/log/nginx/error.log
```

### Step 3: Verify File Structure

```bash
# Check dist directory
ls -la /var/www/partek/dist/

# Check file permissions
sudo -u www-data ls -la /var/www/partek/dist/

# Test if Nginx can read
sudo -u www-data cat /var/www/partek/dist/index.html | head -5
```

### Step 4: Test Nginx Configuration

```bash
# Test config
sudo nginx -t

# Reload if config is valid
sudo systemctl reload nginx

# Check status
sudo systemctl status nginx
```

### Step 5: Rebuild Aplikasi

Jika semua permission sudah benar tapi masih error:

```bash
cd /var/www/partek

# Clean build
rm -rf dist/ node_modules/.vite

# Rebuild
npm run build

# Verify build output
ls -la dist/

# Fix permissions
sudo chown -R www-data:www-data dist/
sudo chmod -R 755 dist/

# Reload Nginx
sudo systemctl reload nginx
```

## Quick Fix Commands

Copy-paste command berikut untuk fix cepat:

```bash
# Fix permissions dan rebuild
cd /var/www/partek && \
npm run build && \
sudo chown -R www-data:www-data dist/ && \
sudo chmod -R 755 dist/ && \
sudo chmod o+x /var/www /var/www/partek && \
sudo systemctl reload nginx && \
echo "✅ Fixed!"
```

## Verifikasi Setelah Fix

1. **Test dengan curl:**
   ```bash
   curl -I https://partek.farzani.space
   # Should return 200 OK
   ```

2. **Test favicon:**
   ```bash
   curl -I https://partek.farzani.space/favicon.ico
   # Should return 200 OK
   ```

3. **Check browser:**
   - Buka https://partek.farzani.space
   - Buka DevTools (F12)
   - Check Console tab - tidak ada error 500
   - Check Network tab - semua request return 200

## Prevention (Mencegah Error Terjadi Lagi)

### Update deploy.sh Script

Pastikan `deploy.sh` sudah include fix permissions:

```bash
# Di akhir deploy.sh, pastikan ada:
sudo chown -R www-data:www-data "$BUILD_DIR"
sudo chmod -R 755 "$BUILD_DIR"
sudo chmod o+x /var/www /var/www/partek
```

### Setup Cron untuk Auto-fix (Optional)

```bash
# Edit crontab
sudo crontab -e

# Add line untuk check dan fix permissions setiap hari jam 3 pagi
0 3 * * * chown -R www-data:www-data /var/www/partek/dist && chmod -R 755 /var/www/partek/dist
```

## Common Error Messages

### "Permission denied"
```bash
sudo chown -R www-data:www-data /var/www/partek/dist
sudo chmod -R 755 /var/www/partek/dist
```

### "No such file or directory"
```bash
cd /var/www/partek
npm run build
```

### "Directory index forbidden"
```bash
# Check Nginx config has index.html
sudo grep -A 5 "location /" /etc/nginx/sites-available/partek.farzani.space
```

### "Connection refused"
```bash
# Check Nginx is running
sudo systemctl status nginx
sudo systemctl start nginx
```

## Still Having Issues?

Jika setelah semua langkah di atas masih error:

1. **Check detailed Nginx error:**
   ```bash
   sudo tail -100 /var/log/nginx/error.log
   ```

2. **Check system logs:**
   ```bash
   sudo journalctl -u nginx -n 50
   ```

3. **Verify Nginx user:**
   ```bash
   grep user /etc/nginx/nginx.conf
   ```

4. **Test file access manually:**
   ```bash
   sudo -u www-data cat /var/www/partek/dist/index.html
   ```

5. **Check disk space:**
   ```bash
   df -h
   ```

## Contact & Support

Jika masalah masih terjadi setelah semua troubleshooting:
- Check error logs detail
- Verify semua file ada di dist/
- Pastikan build process tidak ada error
- Test dengan user www-data langsung

---

**Note:** Pastikan selalu menjalankan `npm run build` setelah update code dan fix permissions setelah build!

