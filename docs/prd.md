### **Project Requirement Document (PRD): Parameter Teknis Radio FM Assistant**

**1. Gambaran Umum (Overview)**

*   **Nama Projek:** **Parameter Teknis Radio FM Assistant**
*   **Deskripsi:** Aplikasi web progresif (PWA) yang dibangun dengan Vue 3 dan Vite untuk memandu teknisi dalam mengukur parameter teknis khusus radio FM sesuai **SOP 92/2021 Dirjen SDPPI Kominfo**. Aplikasi ini menyediakan panduan langkah demi langkah yang terstruktur, kalkulator parameter teknis radio FM otomatis, dan form pelaporan digital yang terintegrasi.
*   **Teknologi:** Vue 3 (Composition API), Vite, CSS3/SCSS (Modern Glass Crypto Style), PWA.

**2. Tujuan dan Manfaat (Goals & Benefits)**

*   **Meningkatkan Akurasi dan Konsistensi:** Meminimalisir kesalahan manusia dalam perhitungan rumit dan pencatatan data, serta memastikan semua pengukuran mengikuti standar SOP yang sama.
*   **Mempercepat Proses Pengukuran:** Mengotomasi perhitungan parameter teknis radio FM dan pengisian laporan, mengurangi waktu yang dihabiskan di lapangan dan untuk administrasi.
*   **Sebagai Alat Bantu dan Panduan Utama:** Menyediakan alur kerja terpandu (wizard) yang intuitif untuk setiap jenis pengukuran, dilengkapi dengan prasyarat dan pengaturan alat yang direkomendasikan.
*   **Aksesibilitas dan Kemandirian di Lapangan:** Dapat diakses dari perangkat mobile dan desktop, serta berfungsi optimal di lokasi lapangan dengan konektivitas terbatas berkat fitur PWA.

**3. Fitur-Fitur Utama (Core Features)**

*   **F1. Dashboard**
    *   Ringkasan statistik dan tugas pengukuran.
    *   Akses cepat ke semua alat kalkulator dan riwayat pengukuran.
*   **F2. Wizard Pengukuran Parameter Teknis Radio FM (Panduan Interaktif)**
    *   Pengguna memilih jenis pengukuran (Frekuensi Kerja, Lebar Pita, Kekuatan Medan, dll).
    *   Aplikasi menampilkan **prasyarat dan peringatan keselamatan** (misal: pastikan `S/N ≥ 60 dB`, `LOS`, kondisi lingkungan).
    *   Menampilkan **pengaturan rekomendasi** untuk Spectrum Analyzer (Frekuensi, Span, RBW, VBW, Sweep Time, dll) yang dapat disalin untuk mempermudah setup.
    *   Langkah-langkah prosedural dari SOP disajikan dalam bentuk checklist yang interaktif.
    *   **Integrasi Langsung dengan Kalkulator:** Pada langkah yang membutuhkan perhitungan, kalkulator yang relevan akan muncul secara kontekstual.
*   **F3. Toolkit Kalkulator Parameter Teknis Radio FM**
    *   **Konversi Satuan:** `dBµV` <=> `dBµV/m` (dengan input Antenna Factor & Cable Loss).
    *   **Lebar Pita Terpakai (`β%` & `x-dB`):** Menghitung Occupied Bandwidth (OBW) berdasarkan input daya atau delta level.
    *   **Effective Radiated Power (ERP):** Menghitung ERP dari daya pancar (Tx Power), gain antena, dan loss kabel.
    *   **Kedalaman Modulasi AM:** Mengkonversi nilai `(Esb/Ec) dB` ke persentase kedalaman modulasi.
    *   **Deviasi Frekuensi FM:** Menghitung standard deviasi dari pembacaan delta marker.
*   **F4. Form Laporan Digital Terpadu**
    *   Form digital yang sesuai dengan format lampiran SOP 92/2021 (Halaman 12).
    *   **Auto-fill Data Hasil Perhitungan:** Field-field seperti ERP, OBW, dan lainnya akan terisi otomatis dari hasil kalkulator, menghilangkan risiko salah ketik.
    *   Validasi data wajib untuk memastikan kelengkapan laporan sebelum disimpan.
    *   Fitur untuk menyimpan draft, mengedit, dan mengirim laporan (simulasi atau integrasi API ke `fmc.ditfrek.postel.go.id` di masa depan).
*   **F5. PWA & Offline Capability**
    *   Dapat diinstall seperti aplikasi native pada perangkat mobile/desktop.
    *   Berfungsi penuh (membuka panduan, menggunakan kalkulator) tanpa koneksi internet setelah diinstall.
*   **F6. Modern "Glass Crypto" UI/UX**
    *   Desain antarmuka modern dengan gaya glassmorphism (frosted glass effect), gradien, dan blur.
    *   Dukungan tema terang dan gelap (dark/light mode) untuk kenyamanan di berbagai kondisi pencahayaan.
    *   **Fully Responsive** dan dioptimalkan untuk penggunaan di tablet dan smartphone.

**4. Rencana Teknis (Technical Plan)**

*   **Framework:** Vue 3 (Composition API) + Vite
*   **State Management:** Pinia (untuk mengelola state aplikasi secara terpusat, seperti data form, hasil kalkulasi, dan konfigurasi pengguna).
*   **Styling:** CSS/SCSS dengan variabel CSS untuk theming yang konsisten dan mudah dikustomisasi.
*   **PWA:** Plugin Vite `vite-plugin-pwa` dengan Workbox untuk menggenerate service worker dan manifest.json.
*   **Testing:** Vitest untuk unit test pada semua fungsi kalkulator dan komponen kritis.
*   **Build & Deploy:** Vite build, dapat dihosting di platform static hosting seperti Vercel, Netlify, atau GitHub Pages.

**5. Analisis Risiko dan Mitigasi (Risk Analysis & Mitigation)**

| Area | Risiko Potensial | Strategi Mitigasi |
| :--- | :--- | :--- |
| **Logika Bisnis & Perhitungan** | Hasil kalkulator salah karena kesalahan logika atau presisi. | **Penerapan Unit Test yang ketat** menggunakan Vitest untuk semua fungsi kalkulator. Tinjauan kode (code review) oleh teknisi yang memahami parameter teknis radio FM. |
| **Pengalaman Pengguna (UX)** | Alur wizard membingungkan atau tidak sesuai dengan urutan kerja di lapangan. | **Prototyping dan User Testing** dengan calon pengguna (teknisi). Iterasi desain berdasarkan feedback untuk memastikan alur yang intuitif. |
| **Form Input & Data** | Data laporan tidak valid atau tidak lengkap, menyebabkan penolakan. | **Validasi Form Real-time** dengan library seperti `VeeValidate`. Tandai field wajib dan berikan pesan error yang jelas. |
| **PWA & Offline Mode** | Aplikasi tidak dapat diinstall atau gagal berjalan offline karena caching yang tidak optimal. | **Konfigurasi Cache Strategy** yang matang pada Workbox. Testing offline yang menyeluruh di berbagai skenario dan perangkat. |
| **Kinerja (Performance)** | Aplikasi terasa lamban, terutama pada perangkat rendah spesifikasi, karena efek glassmorphism. | **Optimasi CSS dan Asset.** Gunakan `backdrop-filter` secara sparingly. Lakukan lazy loading pada komponen dan gambar. |
| **Kompatibilitas Browser** | Efek glassmorphism (`backdrop-filter`) tidak didukung browser lama. | **Graceful Degradation.** Sediakan fallback design dengan background solid atau blur sederhana untuk browser yang tidak mendukung. |

**Kesimpulan:**

**Parameter Teknis Radio FM Assistant** dirancang untuk menjadi mitra digital yang andal bagi teknisi dalam melaksanakan pengukuran parameter teknis khusus radio FM. Dengan memusatkan panduan SOP, alat kalkulasi otomatis, dan pelaporan digital dalam satu platform yang cepat, offline-capable, dan mudah digunakan, aplikasi ini akan menjadi standar baru yang secara signifikan meningkatkan produktivitas, akurasi, dan kesesuaian pekerjaan pengukuran parameter teknis radio FM di lapangan.