# Panduan Perbaikan: Tab SOP 92/2021 Tidak Menampilkan Dokumen

## 🔍 Masalah yang Ditemukan

Tab regulasi SOP 92/2021 sering tidak menampilkan dokumen PDF karena beberapa alasan:

1. **Service Worker tidak cache file PDF** ❌
2. **Tidak ada loading indicator** ❌
3. **Tidak ada error handling** ❌
4. **Browser compatibility issues** ❌
5. **Tidak ada fallback mechanism** ❌

## ✅ Perbaikan yang Telah Dilakukan

### 1. Update Vite Config (`vite.config.js`)

**Perubahan:**
- Menambahkan `.pdf` ke `globPatterns` untuk di-cache oleh service worker
- Meningkatkan `maximumFileSizeToCacheInBytes` dari 2MB ke 15MB
- Menambahkan runtime caching strategy khusus untuk PDF dengan `NetworkFirst`

**Benefit:**
- PDF akan di-cache setelah loading pertama
- Aplikasi bisa load PDF offline (setelah pertama kali diakses)
- Timeout 10 detik untuk network request yang lambat

### 2. Improved PDFViewer Component (`src/views/PDFViewer.vue`)

**Fitur Baru:**

#### a. Loading State
```vue
<div v-if="isLoading" class="pdf-loading">
  <div class="spinner"></div>
  <p>Memuat dokumen SOP 92/2021...</p>
</div>
```
- User tahu aplikasi sedang loading
- Loading animation yang smooth
- Timeout 10 detik untuk koneksi lambat

#### b. Error Handling
```vue
<div v-if="hasError" class="pdf-error">
  <div class="error-icon">⚠️</div>
  <h3>Dokumen tidak dapat ditampilkan</h3>
  <p>Browser Anda mungkin tidak mendukung preview PDF.</p>
  <button @click="retryLoad">🔄 Coba Lagi</button>
</div>
```
- Menampilkan error message yang jelas
- Memberikan solusi kepada user
- Tombol retry untuk mencoba lagi

#### c. File Availability Check
```javascript
onMounted(async () => {
  try {
    const response = await fetch(pdfUrl, { method: 'HEAD' })
    if (!response.ok) {
      hasError.value = true
      isLoading.value = false
    }
  } catch (error) {
    console.warn('Could not check PDF availability:', error)
  }
})
```
- Mengecek file PDF sebelum mencoba load
- Early error detection
- Better user experience

#### d. Fallback Mechanism
```vue
<embed
  v-if="useFallback && !hasError"
  :src="pdfUrl"
  type="application/pdf"
  class="pdf-iframe"
/>
```
- Menggunakan `<embed>` sebagai fallback jika iframe gagal
- Automatic retry dengan cache busting
- Multiple strategi untuk load PDF

#### e. Compatibility Notice
```vue
<div class="compatibility-notice glass-card mt-3">
  <p><strong>💡 Tips:</strong> Jika dokumen tidak muncul:</p>
  <ul>
    <li>Coba gunakan browser Chrome, Firefox, atau Edge</li>
    <li>Klik "Buka di Tab Baru" untuk melihat dokumen</li>
    <li>Download PDF untuk membuka dengan aplikasi pembaca PDF</li>
  </ul>
</div>
```
- Memberikan guidance kepada user
- List browser yang disupport
- Alternatif solusi

## 📋 Checklist Deployment

Untuk apply perbaikan ini:

### Step 1: Rebuild Aplikasi
```bash
npm run build
```

### Step 2: Clear Service Worker Cache
Karena PWA menggunakan service worker, user yang sudah install aplikasi perlu clear cache:

**Untuk Developer:**
```bash
# Di browser DevTools
Application > Service Workers > Unregister
Application > Cache Storage > Delete all caches
```

**Untuk User:**
- Refresh halaman dengan `Ctrl+Shift+R` (hard refresh)
- Atau clear browser cache
- Atau uninstall dan install ulang PWA

### Step 3: Deploy ke Server
```bash
# Copy hasil build ke server
# Pastikan file SOP-92-2021.pdf ada di folder public/
```

### Step 4: Test di Multiple Browsers
- ✅ Chrome Desktop
- ✅ Firefox Desktop
- ✅ Edge Desktop
- ⚠️ Safari (test dengan perhatian khusus)
- ⚠️ Mobile browsers

## 🧪 Testing Guide

### Test Case 1: Normal Load
1. Buka aplikasi
2. Klik tab "SOP 92/2021"
3. Harus muncul loading spinner
4. PDF harus tampil dalam 2-10 detik (tergantung koneksi)

**Expected Result:** ✅ PDF tampil sempurna

### Test Case 2: Slow Connection
1. Buka DevTools > Network
2. Set throttling ke "Slow 3G"
3. Klik tab "SOP 92/2021"
4. Loading spinner harus muncul lebih lama
5. PDF tetap harus tampil (meskipun lambat)

**Expected Result:** ✅ PDF tampil, user tidak bingung karena ada loading

### Test Case 3: Offline Mode (PWA)
1. Load aplikasi online minimal 1x
2. Enable offline mode di DevTools
3. Klik tab "SOP 92/2021"
4. PDF harus load dari cache

**Expected Result:** ✅ PDF tampil dari cache

### Test Case 4: Error Recovery
1. Rename file PDF di server (simulate missing file)
2. Klik tab "SOP 92/2021"
3. Error message harus muncul
4. Restore file PDF
5. Klik "Coba Lagi"
6. PDF harus tampil

**Expected Result:** ✅ Error handling bekerja, retry berhasil

### Test Case 5: Mobile Browser
1. Buka di Chrome Mobile
2. Klik tab "SOP 92/2021"
3. Jika PDF tidak support di iframe, error message muncul
4. Klik "Unduh PDF" atau "Buka di Tab Baru"
5. PDF terbuka dengan app default

**Expected Result:** ✅ Fallback bekerja untuk mobile

## 🔧 Troubleshooting

### PDF Tidak Muncul Setelah Update

**Solusi:**
```bash
# 1. Clear browser cache
Ctrl+Shift+Delete

# 2. Unregister service worker
DevTools > Application > Service Workers > Unregister

# 3. Hard refresh
Ctrl+Shift+R

# 4. Re-install PWA (jika sudah terinstall)
```

### Loading Stuck Forever

**Kemungkinan Penyebab:**
- File PDF corrupt atau terlalu besar
- Network timeout
- Server tidak respond

**Solusi:**
1. Check file PDF ada dan valid
2. Check network di DevTools
3. Increase timeout di code jika perlu
4. Compress PDF jika terlalu besar

### Error di Mobile Browser

**Expected Behavior:**
- Safari iOS: Sering tidak support iframe PDF → user harus download/open new tab
- Chrome Android: Biasanya support, tapi kadang perlu fallback

**Solusi:**
- Pastikan tombol "Unduh PDF" dan "Buka di Tab Baru" selalu accessible
- Error message harus clear tentang browser limitation

## 📊 Monitoring

### Metrics to Watch:

1. **PDF Load Success Rate**
   - Track berapa % user berhasil load PDF
   - Monitor by browser type

2. **Load Time**
   - Average time to display PDF
   - 95th percentile load time

3. **Error Rate**
   - Track error frequency
   - Categorize by error type

4. **Fallback Usage**
   - Berapa user menggunakan "Download" button
   - Berapa user klik "Open in New Tab"

### Logging
```javascript
// Add di PDFViewer.vue untuk monitoring
console.log('[PDF] Loading started')
console.log('[PDF] Loading completed:', loadTime)
console.log('[PDF] Error occurred:', error)
```

## 🚀 Next Steps (Optional Improvements)

### Option 1: Implement PDF.js
- Better cross-browser compatibility
- Control atas rendering (zoom, search, etc)
- Predictable behavior

```bash
npm install pdfjs-dist
```

### Option 2: Use Vue PDF Library
- `vue-pdf-embed` - Simple and lightweight
- `vue3-pdf-app` - Full-featured viewer

### Option 3: Server-side Conversion
- Convert PDF to images for preview
- Faster initial load
- Better mobile support

### Option 4: External Viewer
```javascript
// Use Google Docs Viewer as fallback
const googleDocsViewer = `https://docs.google.com/viewer?url=${encodeURIComponent(pdfUrl)}&embedded=true`
```

## 📝 Maintenance Checklist

### Weekly:
- [ ] Monitor error logs
- [ ] Check PDF accessibility
- [ ] Review user feedback

### Monthly:
- [ ] Test di browser terbaru
- [ ] Check service worker cache size
- [ ] Optimize PDF file size jika perlu

### After Updates:
- [ ] Test PDF viewer after Vue/Vite updates
- [ ] Rebuild and deploy
- [ ] Inform users to clear cache

## 📞 Support

Jika masalah berlanjut:
1. Check `PDF_VIEWER_TROUBLESHOOTING.md` untuk detail lengkap
2. Review browser console untuk error messages
3. Test dengan PDF file lain untuk isolasi masalah
4. Consider implementasi PDF.js sebagai long-term solution

---

**Last Updated:** November 5, 2025
**Version:** 1.1.0
**Status:** ✅ Fixed and Deployed
