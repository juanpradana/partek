# Parameter Teknis Radio FM Assistant

Aplikasi web progresif (PWA) yang dibangun dengan Vue 3 dan Vite untuk memandu teknisi dalam mengukur parameter teknis khusus radio FM sesuai **SOP 92/2021 Dirjen SDPPI Kominfo**.

## Fitur Utama

- 📊 **Dashboard** - Ringkasan statistik dan akses cepat ke semua alat
- 🧭 **Wizard Pengukuran Parameter Teknis Radio FM** - Panduan interaktif langkah demi langkah dengan:
  - Prasyarat dan peringatan keselamatan
  - Pengaturan rekomendasi Spectrum Analyzer (dapat disalin)
  - Checklist langkah-langkah prosedural
  - Integrasi langsung dengan kalkulator
- 🧮 **Toolkit Kalkulator** - Perhitungan parameter teknis radio FM otomatis:
  - Konversi Satuan (dBµV ↔ dBµV/m)
  - Lebar Pita Terpakai (OBW)
  - Effective Radiated Power (ERP)
  - Kedalaman Modulasi AM
  - Deviasi Frekuensi FM
- 📝 **Form Laporan Digital** - Form terpadu sesuai format SOP 92/2021 dengan:
  - Auto-fill dari hasil kalkulator
  - Validasi data wajib
  - Fitur simpan draft
  - Siap untuk integrasi API
- 📱 **PWA Support** - Dapat diinstall dan berfungsi offline
- 🎨 **Modern UI/UX** - Desain glassmorphism dengan tema gelap/terang

## Teknologi

- **Vue 3** (Composition API)
- **Vite** - Build tool dan dev server
- **Pinia** - State Management
- **Vue Router** - Routing
- **VeeValidate** - Form Validation
- **Vitest** - Testing framework
- **vite-plugin-pwa** - PWA support dengan Workbox

## Instalasi

1. Clone repository atau extract project
2. Install dependencies:

```bash
npm install
```

## Development

Jalankan development server:

```bash
npm run dev
```

Aplikasi akan berjalan di `http://localhost:5173`

## Build untuk Production

Build aplikasi untuk production:

```bash
npm run build
```

File hasil build akan berada di folder `dist/` dan siap untuk di-deploy ke static hosting seperti Vercel, Netlify, atau GitHub Pages.

## Testing

Jalankan unit tests:

```bash
npm test
```

Atau dengan UI:

```bash
npm run test:ui
```

## PWA Icons

Untuk optimasi PWA, tambahkan icon berikut ke folder `public/`:
- `pwa-192x192.png` (192x192 pixels)
- `pwa-512x512.png` (512x512 pixels)
- `favicon.ico`

Lihat `PUBLIC_ASSETS.md` untuk detail lebih lanjut.

## Struktur Project

```
parameter-teknis-radio-fm/
├── src/
│   ├── components/          # Komponen Vue
│   │   ├── calculators/     # Komponen kalkulator
│   │   └── Layout.vue       # Layout utama dengan navigasi
│   ├── views/               # Halaman utama
│   │   ├── Dashboard.vue
│   │   ├── Wizard.vue
│   │   ├── Calculators.vue
│   │   └── ReportForm.vue
│   ├── stores/              # Pinia stores
│   │   ├── app.js          # State aplikasi global
│   │   └── calculator.js    # State dan fungsi kalkulator
│   ├── router/              # Vue Router configuration
│   ├── styles/              # Global styles
│   └── utils/               # Utility functions & tests
├── public/                  # Static assets
├── docs/                    # Dokumentasi
├── scripts/                 # Script deployment dan setup
├── index.html
├── vite.config.js
├── package.json
└── README.md
```

## Penggunaan

1. **Dashboard**: Lihat ringkasan dan akses cepat ke semua fitur
2. **Wizard**: Pilih jenis pengukuran dan ikuti panduan langkah demi langkah
3. **Kalkulator**: Gunakan kalkulator untuk perhitungan parameter teknis radio FM
4. **Form Laporan**: Isi form laporan dengan data hasil pengukuran (dapat auto-fill dari kalkulator)

## Fitur PWA

Setelah di-build, aplikasi dapat diinstall sebagai PWA:
- **Offline Support**: Berfungsi tanpa koneksi internet setelah diinstall
- **Install Prompt**: Browser akan menampilkan prompt untuk install
- **Standalone Mode**: Berjalan seperti aplikasi native

## Lisensi

Proyek ini dibuat untuk keperluan pengukuran parameter teknis khusus radio FM sesuai SOP 92/2021 Dirjen SDPPI Kominfo.
