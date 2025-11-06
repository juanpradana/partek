# Quick Fix Error 500

## 🚨 Error 500 Internal Server Error

Jika Anda melihat error 500 setelah deployment, ikuti langkah-langkah berikut:

## ⚡ Quick Fix (5 Menit)

### Option 1: Jalankan Script Troubleshooting (Recommended)

```bash
# Upload troubleshoot-500.sh ke server, lalu jalankan:
bash troubleshoot-500.sh
```

Script ini akan otomatis:
- ✅ Check semua file dan directory
- ✅ Fix permissions
- ✅ Copy missing files
- ✅ Verify Nginx access

### Option 2: Manual Quick Fix

Copy-paste command berikut di server:

```bash
cd /var/www/partek && \
npm run build && \
sudo chown -R www-data:www-data dist/ && \
sudo chmod -R 755 dist/ && \
sudo chmod o+x /var/www /var/www/partek && \
sudo systemctl reload nginx
```

## 🔍 Diagnosa Manual

### Step 1: Check Error Logs

```bash
sudo tail -f /var/log/nginx/error.log
```

### Step 2: Check Permissions

```bash
# Check ownership
ls -la /var/www/partek/dist/

# Test if Nginx can read
sudo -u www-data cat /var/www/partek/dist/index.html | head -5
```

### Step 3: Fix Permissions

```bash
sudo bash fix-permissions.sh
```

## ✅ Verifikasi

Setelah fix, test dengan:

```bash
# Test dengan curl
curl -I https://partek.farzani.space
curl -I https://partek.farzani.space/favicon.ico

# Keduanya harus return 200 OK
```

## 📝 Penyebab Umum

1. **Permission Issues** (90% kasus)
   - File tidak bisa dibaca oleh www-data
   - Fix: `sudo chown -R www-data:www-data /var/www/partek/dist`

2. **File Tidak Ada**
   - favicon.ico atau file lain tidak ter-copy saat build
   - Fix: Rebuild dengan `npm run build`

3. **Parent Directory Tidak Accessible**
   - Nginx tidak bisa akses parent directory
   - Fix: `sudo chmod o+x /var/www /var/www/partek`

## 🆘 Masih Error?

Jika masih error setelah semua langkah:

1. **Check detail error:**
   ```bash
   sudo tail -100 /var/log/nginx/error.log
   ```

2. **Rebuild dari awal:**
   ```bash
   cd /var/www/partek
   rm -rf dist/ node_modules/.vite
   npm install
   npm run build
   sudo bash fix-permissions.sh
   ```

3. **Check Nginx config:**
   ```bash
   sudo nginx -t
   sudo grep -r "root" /etc/nginx/sites-available/partek.farzani.space
   ```

## 📚 Dokumentasi Lengkap

Lihat `TROUBLESHOOTING.md` untuk panduan lengkap troubleshooting.

---

**Tip:** Setelah fix, jalankan `deploy.sh` untuk deployment berikutnya - script sudah include auto-fix permissions!

