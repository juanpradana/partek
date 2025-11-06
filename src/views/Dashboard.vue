<template>
  <Layout>
    <div class="container">
      <div class="dashboard-header">
        <h1>Dashboard</h1>
        <p class="subtitle">Ringkasan statistik dan akses cepat ke semua alat</p>
      </div>

      <div class="stats-grid grid grid-3">
        <div class="stat-card glass-card">
          <div class="stat-icon">📊</div>
          <div class="stat-value">{{ totalMeasurements }}</div>
          <div class="stat-label">Total Pengukuran</div>
        </div>
        <div class="stat-card glass-card">
          <div class="stat-icon">🧮</div>
          <div class="stat-value">7</div>
          <div class="stat-label">Kalkulator Tersedia</div>
        </div>
        <div class="stat-card glass-card">
          <div class="stat-icon">📚</div>
          <div class="stat-value">1</div>
          <div class="stat-label">Dokumen SOP</div>
        </div>
      </div>

      <div class="quick-access grid grid-2 mt-4">
        <router-link to="/wizard" class="quick-card glass-card">
          <div class="quick-icon">🧭</div>
          <h3>Wizard Pengukuran</h3>
          <p>Panduan interaktif langkah demi langkah untuk pengukuran parameter teknis radio FM</p>
        </router-link>

        <router-link to="/calculators" class="quick-card glass-card">
          <div class="quick-icon">🧮</div>
          <h3>Kalkulator</h3>
          <p>Alat perhitungan parameter teknis radio FM: ERP, OBW, Modulasi, dll</p>
        </router-link>

        <router-link to="/sop" class="quick-card glass-card">
          <div class="quick-icon">📚</div>
          <h3>SOP 92/2021</h3>
          <p>Pedoman pengukuran parameter teknis radio FM Dirjen SDPPI Kominfo</p>
        </router-link>
      </div>

      <div class="recent-activity glass-card mt-4">
        <h2>Aktivitas Terbaru</h2>
        <div v-if="recentMeasurements.length === 0" class="empty-state">
          <p>Belum ada pengukuran yang dilakukan</p>
        </div>
        <div v-else class="activity-list">
          <div
            v-for="measurement in recentMeasurements"
            :key="measurement.id"
            class="activity-item"
          >
            <div class="activity-icon">📡</div>
            <div class="activity-content">
              <div class="activity-title">{{ measurement.type || 'Pengukuran' }}</div>
              <div class="activity-date">{{ formatDate(measurement.createdAt) }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </Layout>
</template>

<script setup>
import { computed } from 'vue'
import Layout from '../components/Layout.vue'
import { useAppStore } from '../stores/app'

const appStore = useAppStore()

const totalMeasurements = computed(() => appStore.measurements.length)

const recentMeasurements = computed(() => 
  [...appStore.measurements]
    .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt))
    .slice(0, 5)
)

function formatDate(dateString) {
  const date = new Date(dateString)
  return date.toLocaleDateString('id-ID', {
    day: 'numeric',
    month: 'long',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}
</script>

<style scoped>
.dashboard-header {
  text-align: center;
  margin-bottom: 3rem;
}

.dashboard-header h1 {
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
}

.stat-card {
  text-align: center;
  padding: 2rem;
}

.stat-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.stat-value {
  font-size: 2.5rem;
  font-weight: 700;
  color: var(--accent);
  margin-bottom: 0.5rem;
}

.stat-label {
  color: var(--text-secondary);
  font-size: 0.9rem;
}

.quick-card {
  text-decoration: none;
  color: inherit;
  display: block;
  padding: 2rem;
  transition: transform 0.3s ease;
}

.quick-card:hover {
  transform: translateY(-8px);
}

.quick-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.quick-card h3 {
  font-size: 1.5rem;
  margin-bottom: 0.5rem;
  color: var(--text-primary);
}

.quick-card p {
  color: var(--text-secondary);
  line-height: 1.6;
}

.recent-activity {
  padding: 2rem;
}

.recent-activity h2 {
  margin-bottom: 1.5rem;
  font-size: 1.5rem;
}

.empty-state {
  text-align: center;
  padding: 3rem;
  color: var(--text-secondary);
}

.activity-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.activity-item {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem;
  background: var(--glass-bg);
  border-radius: 8px;
  border: 1px solid var(--glass-border);
}

.activity-icon {
  font-size: 2rem;
}

.activity-content {
  flex: 1;
}

.activity-title {
  font-weight: 600;
  margin-bottom: 0.25rem;
}

.activity-date {
  color: var(--text-secondary);
  font-size: 0.9rem;
}

@media (max-width: 768px) {
  .dashboard-header h1 {
    font-size: 1.8rem;
  }
  
  .subtitle {
    font-size: 0.95rem;
  }
  
  .stat-card {
    padding: 1.5rem 1rem;
  }
  
  .stat-icon {
    font-size: 2.5rem;
  }
  
  .stat-value {
    font-size: 2rem;
  }
  
  .quick-card {
    padding: 1.5rem;
  }
  
  .quick-icon {
    font-size: 2.5rem;
  }
  
  .quick-card h3 {
    font-size: 1.3rem;
  }
  
  .recent-activity {
    padding: 1.5rem;
  }
}
</style>
