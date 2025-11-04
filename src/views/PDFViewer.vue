<template>
  <Layout>
    <div class="container">
      <div class="pdf-viewer-header">
        <h1>📚 SOP 92/2021</h1>
        <p class="subtitle">Pedoman Pengukuran Parameter Teknis SFR</p>
        <div class="pdf-actions">
          <a 
            :href="pdfUrl" 
            download="SOP-92-2021-Pedoman-Pengukuran-Parameter-Teknis-SFR.pdf"
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
        <iframe
          :src="pdfUrl"
          class="pdf-iframe"
          title="SOP 92/2021 Pedoman Pengukuran Parameter Teknis SFR"
        ></iframe>
      </div>
    </div>
  </Layout>
</template>

<script setup>
import Layout from '../components/Layout.vue'

const pdfUrl = '/SOP-92-2021.pdf'
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
}

.pdf-iframe {
  width: 100%;
  height: 80vh;
  min-height: 600px;
  border: none;
  border-radius: 8px;
  background: white;
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
}

@media (max-width: 480px) {
  .pdf-iframe {
    height: 60vh;
    min-height: 350px;
  }
}

/* Ensure buttons work as links */
.pdf-actions .btn {
  text-decoration: none;
  display: inline-flex;
}
</style>
