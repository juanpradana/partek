# Troubleshooting: Tab SOP 92/2021 Tidak Menampilkan Dokumen

## Masalah
Tab regulasi SOP 92/2021 sering tidak menampilkan dokumen PDF di browser.

## Penyebab Umum

### 1. **Browser Compatibility**
- Tidak semua browser mendukung menampilkan PDF di iframe
- Browser mobile (terutama Safari iOS, Chrome Android) memiliki batasan dalam menampilkan PDF
- Browser versi lama tidak memiliki PDF viewer bawaan

### 2. **Security Policy & CORS**
- Browser mungkin memblokir loading resource dari path tertentu
- Content Security Policy (CSP) yang terlalu ketat
- Mixed content warning (HTTP vs HTTPS)

### 3. **File Size & Loading**
- PDF yang besar membutuhkan waktu loading lebih lama
- Koneksi internet lambat menyebabkan timeout
- Server tidak mengkompres file dengan baik

### 4. **Cache & Service Worker**
- PWA service worker mungkin cache versi lama
- Browser cache corrupt
- Manifest file tidak terupdate

## Solusi yang Telah Diterapkan

### ✅ Improvement pada PDFViewer.vue

1. **Loading Indicator**
   - Menampilkan spinner saat dokumen sedang dimuat
   - User tahu aplikasi sedang bekerja

2. **Error Handling**
   - Mendeteksi jika iframe gagal memuat
   - Menampilkan pesan error yang jelas
   - Menyediakan tombol "Coba Lagi"

3. **Fallback Mechanism**
   - Menggunakan `<embed>` tag sebagai alternatif
   - Automatic retry dengan cache busting

4. **File Availability Check**
   - Mengecek apakah file PDF ada sebelum mencoba memuat
   - Memberikan feedback early jika file tidak tersedia

5. **Compatibility Notice**
   - Memberikan tips kepada user jika dokumen tidak muncul
   - Menyediakan alternatif (download, buka di tab baru)

## Panduan User

### Jika Dokumen Tidak Muncul:

1. **Gunakan Browser yang Disarankan**
   - ✅ Google Chrome (Desktop)
   - ✅ Mozilla Firefox (Desktop)
   - ✅ Microsoft Edge (Desktop)
   - ⚠️ Safari (kadang bermasalah)
   - ⚠️ Browser Mobile (terbatas)

2. **Pastikan Pengaturan Browser Benar**
   - JavaScript harus aktif
   - Cookies diizinkan
   - Pop-up blocker tidak menghalangi
   - Disable ekstensi yang mungkin interferensi

3. **Gunakan Alternatif**
   - Klik "📥 Unduh PDF" untuk download
   - Klik "🔗 Buka di Tab Baru" untuk view di tab terpisah
   - Buka dengan aplikasi PDF reader di device

4. **Clear Cache**
   ```
   Chrome: Ctrl+Shift+Delete
   Firefox: Ctrl+Shift+Delete
   Edge: Ctrl+Shift+Delete
   ```

5. **Coba Lagi**
   - Refresh halaman (F5)
   - Klik tombol "🔄 Coba Lagi"
   - Restart browser

## Testing Checklist

Untuk memastikan PDF viewer bekerja dengan baik:

- [ ] Test di Chrome Desktop (latest)
- [ ] Test di Firefox Desktop (latest)
- [ ] Test di Edge Desktop (latest)
- [ ] Test di Safari Desktop (jika available)
- [ ] Test di Chrome Mobile Android
- [ ] Test di Safari Mobile iOS
- [ ] Test dengan koneksi cepat
- [ ] Test dengan koneksi lambat (throttling)
- [ ] Test dengan file PDF besar (>5MB)
- [ ] Test setelah clear cache
- [ ] Test mode offline (PWA)
- [ ] Test dengan berbagai ukuran layar

## Monitoring

### Metrics to Track:
- PDF load success rate
- Average load time
- Browser distribution
- Error rate by browser type
- User engagement with download button

### Log Points:
```javascript
// Di browser console, check:
1. Network tab - apakah PDF file ter-load
2. Console tab - error messages
3. Application tab - Service Worker status
4. Application tab - Cache Storage
```

## Future Improvements

### Opsi 1: Menggunakan PDF.js
- Library JavaScript untuk rendering PDF
- Better cross-browser compatibility
- Kontrol penuh atas rendering

```bash
npm install pdfjs-dist
```

### Opsi 2: Menggunakan Vue PDF Viewer Library
- `vue-pdf-embed` atau `vue3-pdf-app`
- Built-in controls (zoom, navigation, search)
- Better UX

### Opsi 3: Server-side Preview
- Generate thumbnail preview di server
- Convert ke gambar untuk preview cepat
- Streaming untuk file besar

### Opsi 4: External Viewer Service
- Google Docs Viewer: `https://docs.google.com/viewer?url=...`
- Microsoft Office Online
- PDF.js Express (hosted)

## Maintenance

### Regular Tasks:
1. Monitor error logs untuk PDF loading issues
2. Update browser compatibility list
3. Test setelah update Vue atau dependencies
4. Review user feedback tentang PDF viewer
5. Check PDF file integrity dan size

### File Management:
- Pastikan `SOP-92-2021.pdf` ada di folder `public/`
- Ukuran file optimal: < 10MB
- Kompresi PDF jika terlalu besar
- Backup file PDF secara teratur

## Support

Jika masalah berlanjut:
1. Check browser console untuk error detail
2. Verify file PDF tidak corrupt
3. Test dengan PDF lain untuk isolasi masalah
4. Consider implementasi PDF.js sebagai alternatif
5. Provide download link sebagai fallback permanen
