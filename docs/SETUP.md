# Setup Guide - Parameter Teknis Radio FM Assistant

## Prasyarat

- Node.js (versi 16 atau lebih baru)
- npm atau yarn

## Langkah-langkah Setup

### 1. Install Dependencies

```bash
npm install
```

### 2. Jalankan Development Server

```bash
npm run dev
```

Buka browser di `http://localhost:5173`

### 3. Build untuk Production

```bash
npm run build
```

### 4. Preview Build

```bash
npm run preview
```

## Testing PWA

Untuk testing fitur PWA:

1. Build aplikasi: `npm run build`
2. Preview: `npm run preview`
3. Buka di browser (Chrome/Edge recommended)
4. Buka DevTools > Application > Service Workers
5. Test install prompt dan offline mode

## Menambahkan PWA Icons

1. Buat icon dengan ukuran:
   - 192x192 pixels → `public/pwa-192x192.png`
   - 512x512 pixels → `public/pwa-512x512.png`
   - Favicon → `public/favicon.ico`

2. Atau gunakan tool online seperti:
   - [PWA Asset Generator](https://github.com/onderceylan/pwa-asset-generator)
   - [Real Favicon Generator](https://realfavicongenerator.net/)

## Troubleshooting

### Error: Cannot find module
Jalankan `npm install` lagi untuk memastikan semua dependencies terinstall.

### PWA tidak berfungsi
Pastikan:
- Aplikasi sudah di-build (`npm run build`)
- Menggunakan HTTPS atau localhost
- Browser mendukung PWA (Chrome, Edge, Firefox, Safari)

### Kalkulator tidak berfungsi
Pastikan semua input sudah diisi dengan benar sesuai format yang diminta.

## Development Tips

- Gunakan Vue DevTools untuk debugging
- State management ada di Pinia stores
- Router configuration ada di `src/router/index.js`
- Global styles ada di `src/styles/main.css`
