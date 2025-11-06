<template>
  <Layout>
    <div class="container">
      <div class="pdf-viewer-header">
        <h1>📚 SOP 92/2021</h1>
        <p class="subtitle">Pedoman Pengukuran Parameter Teknis Radio FM SFR</p>
        <div class="pdf-actions">
          <a 
            :href="pdfUrl" 
            download="SOP-92-2021-Pedoman-Pengukuran-Parameter-Teknis-Radio-FM-SFR.pdf"
            class="btn btn-primary"
          >
            📥 Unduh PDF
          </a>
          <a 
            :href="pdfUrl" 
            target="_blank" 
            rel="noopener noreferrer"
            class="btn btn-secondary"
          >
            🔗 Buka di Tab Baru
          </a>
        </div>
      </div>

      <div class="pdf-container glass-card">
        <!-- Loading indicator -->
        <div v-if="isLoading" class="pdf-loading">
          <div class="spinner"></div>
          <p>Memuat dokumen SOP 92/2021...</p>
        </div>

        <!-- Error message -->
        <div v-if="hasError" class="pdf-error">
          <div class="error-icon">⚠️</div>
          <h3>Dokumen tidak dapat ditampilkan</h3>
          <p>Browser Anda mungkin tidak mendukung preview PDF.</p>
          <p class="error-hint">Silakan gunakan tombol di atas untuk mengunduh atau membuka di tab baru.</p>
          <button @click="retryLoad" class="btn btn-primary mt-2">
            🔄 Coba Lagi
          </button>
        </div>

        <!-- PDF iframe with fallback -->
        <iframe
          v-show="!isLoading && !hasError"
          ref="pdfIframe"
          :src="pdfUrl"
          class="pdf-iframe"
          title="SOP 92/2021 Pedoman Pengukuran Parameter Teknis Radio FM SFR"
          @load="onIframeLoad"
          @error="onIframeError"
        ></iframe>

        <!-- Alternative: Embed tag as fallback -->
        <embed
          v-if="useFallback && !hasError"
          :src="pdfUrl"
          type="application/pdf"
          class="pdf-iframe"
          title="SOP 92/2021 Pedoman Pengukuran Parameter Teknis Radio FM SFR"
        />
      </div>

      <!-- Browser compatibility notice -->
      <div class="compatibility-notice glass-card mt-3">
        <p><strong>💡 Tips:</strong> Jika dokumen tidak muncul:</p>
        <ul>
          <li>Coba gunakan browser Chrome, Firefox, atau Edge</li>
          <li>Pastikan JavaScript dan cookies diaktifkan</li>
          <li>Klik "Buka di Tab Baru" untuk melihat dokumen</li>
          <li>Download PDF untuk membuka dengan aplikasi pembaca PDF</li>
        </ul>
      </div>
    </div>
  </Layout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import Layout from '../components/Layout.vue'

const pdfUrl = '/SOP-92-2021.pdf'
const pdfIframe = ref(null)
const isLoading = ref(true)
const hasError = ref(false)
const useFallback = ref(false)

// Check if PDF loaded successfully
const onIframeLoad = () => {
  // Set timeout to hide loading after iframe loads
  setTimeout(() => {
    isLoading.value = false
    // Additional check: try to access iframe content
    try {
      if (pdfIframe.value && pdfIframe.value.contentWindow) {
        // If we can access it, it loaded successfully
        hasError.value = false
      }
    } catch (e) {
      // Cross-origin error is expected and means PDF is loading
      // This is actually a good sign for PDF display
      hasError.value = false
    }
  }, 1000)
}

// Handle iframe error
const onIframeError = () => {
  isLoading.value = false
  hasError.value = true
  useFallback.value = true
}

// Retry loading
const retryLoad = () => {
  isLoading.value = true
  hasError.value = false
  useFallback.value = false
  
  // Force reload by updating src
  if (pdfIframe.value) {
    pdfIframe.value.src = pdfUrl + '?t=' + Date.now()
  }
}

// Check PDF availability on mount
onMounted(async () => {
  // Test if PDF file exists
  try {
    const response = await fetch(pdfUrl, { method: 'HEAD' })
    if (!response.ok) {
      hasError.value = true
      isLoading.value = false
    }
  } catch (error) {
    // Don't set error yet, let iframe try to load
    // PDF may still be available even if HEAD request fails
  }
  
  // Set a maximum loading time (10 seconds)
  setTimeout(() => {
    if (isLoading.value) {
      isLoading.value = false
      // Don't set error automatically, user might have slow connection
    }
  }, 10000)
})
</script>

<style scoped>
.pdf-viewer-header {
  text-align: center;
  margin-bottom: 2rem;
}

.pdf-viewer-header h1 {
  font-size: 2.5rem;
  margin-bottom: 0.5rem;
  background: linear-gradient(135deg, var(--accent) 0%, #667eea 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.subtitle {
  color: var(--text-secondary);
  font-size: 1.1rem;
  margin-bottom: 1.5rem;
}

.pdf-actions {
  display: flex;
  gap: 1rem;
  justify-content: center;
  flex-wrap: wrap;
}

.pdf-container {
  padding: 1rem;
  border-radius: 12px;
  overflow: hidden;
  position: relative;
  min-height: 600px;
}

.pdf-iframe {
  width: 100%;
  height: 80vh;
  min-height: 600px;
  border: none;
  border-radius: 8px;
  background: white;
}

/* Loading state */
.pdf-loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 600px;
  gap: 1.5rem;
}

.spinner {
  width: 50px;
  height: 50px;
  border: 4px solid rgba(124, 58, 237, 0.2);
  border-top-color: var(--accent);
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.pdf-loading p {
  color: var(--text-secondary);
  font-size: 1.1rem;
}

/* Error state */
.pdf-error {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 600px;
  gap: 1rem;
  text-align: center;
  padding: 2rem;
}

.error-icon {
  font-size: 4rem;
  opacity: 0.6;
}

.pdf-error h3 {
  color: var(--text-primary);
  font-size: 1.5rem;
  margin: 0;
}

.pdf-error p {
  color: var(--text-secondary);
  margin: 0.5rem 0;
}

.error-hint {
  font-weight: 600;
  color: var(--accent);
}

/* Compatibility notice */
.compatibility-notice {
  padding: 1.5rem;
  background: var(--glass-bg);
  border: 1px solid var(--glass-border);
}

.compatibility-notice p {
  margin-bottom: 1rem;
  color: var(--text-primary);
}

.compatibility-notice ul {
  margin: 0;
  padding-left: 1.5rem;
  color: var(--text-secondary);
}

.compatibility-notice li {
  margin-bottom: 0.5rem;
}

@media (max-width: 768px) {
  .pdf-viewer-header h1 {
    font-size: 1.8rem;
  }
  
  .subtitle {
    font-size: 0.95rem;
  }
  
  .pdf-iframe {
    height: 70vh;
    min-height: 400px;
  }
  
  .pdf-container {
    min-height: 400px;
  }
  
  .pdf-loading,
  .pdf-error {
    min-height: 400px;
  }
  
  .pdf-actions {
    flex-direction: column;
    gap: 0.75rem;
  }
  
  .pdf-actions .btn {
    width: 100%;
  }
  
  .pdf-container {
    padding: 0.5rem;
  }

  .compatibility-notice {
    padding: 1rem;
  }

  .compatibility-notice ul {
    padding-left: 1.2rem;
  }
}

@media (max-width: 480px) {
  .pdf-iframe {
    height: 60vh;
    min-height: 350px;
  }

  .pdf-container,
  .pdf-loading,
  .pdf-error {
    min-height: 350px;
  }

  .error-icon {
    font-size: 3rem;
  }

  .pdf-error h3 {
    font-size: 1.2rem;
  }
}

/* Ensure buttons work as links */
.pdf-actions .btn {
  text-decoration: none;
  display: inline-flex;
}

.mt-2 {
  margin-top: 1rem;
}

.mt-3 {
  margin-top: 1.5rem;
}
</style>
