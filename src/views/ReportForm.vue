<template>
  <Layout>
    <div class="container">
      <div class="form-header">
        <h1>📋 Form Laporan Digital</h1>
        <p class="subtitle">Form sesuai format SOP 92/2021 - Halaman 12</p>
      </div>

      <form @submit.prevent="submitForm" class="report-form glass-card">
        <!-- Informasi Umum -->
        <section class="form-section">
          <h2>Informasi Umum</h2>
          <div class="form-grid grid grid-2">
            <div class="input-group">
              <label>Nama Teknisi <span class="required">*</span></label>
              <input
                v-model="formData.technicianName"
                type="text"
                required
                placeholder="Nama lengkap teknisi"
              />
            </div>
            <div class="input-group">
              <label>Tanggal Pengukuran <span class="required">*</span></label>
              <input
                v-model="formData.measurementDate"
                type="date"
                required
              />
            </div>
            <div class="input-group">
              <label>Lokasi Pengukuran <span class="required">*</span></label>
              <input
                v-model="formData.location"
                type="text"
                required
                placeholder="Alamat lokasi pengukuran"
              />
            </div>
            <div class="input-group">
              <label>Jenis Stasiun Radio <span class="required">*</span></label>
              <select v-model="formData.stationType" required>
                <option value="">Pilih jenis stasiun</option>
                <option value="broadcast">Broadcast</option>
                <option value="land-mobile">Land Mobile</option>
                <option value="fixed">Fixed</option>
                <option value="maritime">Maritime</option>
                <option value="aeronautical">Aeronautical</option>
              </select>
            </div>
          </div>
        </section>

        <!-- Parameter Teknis -->
        <section class="form-section">
          <h2>Parameter Teknis Radio FM</h2>
          <div class="form-grid grid grid-2">
            <div class="input-group">
              <label>Frekuensi Kerja (MHz) <span class="required">*</span></label>
              <input
                v-model.number="formData.frequency"
                type="number"
                step="0.001"
                required
                placeholder="Frekuensi dalam MHz"
              />
            </div>
            <div class="input-group">
              <label>Effective Radiated Power (ERP) - dBm</label>
              <input
                v-model.number="formData.erp"
                type="number"
                step="0.01"
                placeholder="Auto-fill dari kalkulator"
              />
              <button
                type="button"
                @click="fillFromCalculator('erp')"
                class="btn-small mt-1"
              >
                Isi dari Kalkulator
              </button>
            </div>
            <div class="input-group">
              <label>Occupied Bandwidth (Hz)</label>
              <input
                v-model.number="formData.occupiedBandwidth"
                type="number"
                step="0.01"
                placeholder="Auto-fill dari kalkulator"
              />
              <button
                type="button"
                @click="fillFromCalculator('occupiedBandwidth')"
                class="btn-small mt-1"
              >
                Isi dari Kalkulator
              </button>
            </div>
            <div class="input-group">
              <label>Kekuatan Medan (dBµV/m)</label>
              <input
                v-model.number="formData.fieldStrength"
                type="number"
                step="0.01"
                placeholder="Auto-fill dari kalkulator"
              />
              <button
                type="button"
                @click="fillFromCalculator('unitConversion')"
                class="btn-small mt-1"
              >
                Isi dari Kalkulator
              </button>
            </div>
            <div class="input-group">
              <label>Kedalaman Modulasi AM (%)</label>
              <input
                v-model.number="formData.amModulation"
                type="number"
                step="0.01"
                placeholder="Auto-fill dari kalkulator"
              />
              <button
                type="button"
                @click="fillFromCalculator('amModulation')"
                class="btn-small mt-1"
              >
                Isi dari Kalkulator
              </button>
            </div>
            <div class="input-group">
              <label>Deviasi Frekuensi FM (Hz)</label>
              <input
                v-model.number="formData.fmDeviation"
                type="number"
                step="0.01"
                placeholder="Auto-fill dari kalkulator"
              />
              <button
                type="button"
                @click="fillFromCalculator('fmDeviation')"
                class="btn-small mt-1"
              >
                Isi dari Kalkulator
              </button>
            </div>
            <div class="input-group">
              <label>Power Level Fundamental (dBm)</label>
              <input
                v-model.number="formData.powerLevel"
                type="number"
                step="0.01"
                placeholder="Auto-fill dari kalkulator"
              />
              <button
                type="button"
                @click="fillFromCalculator('frequencyPower')"
                class="btn-small mt-1"
              >
                Isi dari Kalkulator
              </button>
            </div>
          </div>
        </section>

        <!-- Harmonisa -->
        <section class="form-section">
          <h2>Pengukuran Harmonisa</h2>
          <div class="form-grid grid grid-2">
            <div class="input-group">
              <label>Harmonisa 1 - Frekuensi (MHz) (2×f)</label>
              <input
                v-model.number="formData.harmonics.harmonic1.frequency"
                type="number"
                step="0.001"
                placeholder="Frekuensi harmonisa 1"
              />
            </div>
            <div class="input-group">
              <label>Harmonisa 1 - Power Level (dBm)</label>
              <input
                v-model.number="formData.harmonics.harmonic1.power"
                type="number"
                step="0.01"
                placeholder="Power level harmonisa 1"
              />
            </div>
            <div class="input-group">
              <label>Harmonisa 2 - Frekuensi (MHz) (3×f)</label>
              <input
                v-model.number="formData.harmonics.harmonic2.frequency"
                type="number"
                step="0.001"
                placeholder="Frekuensi harmonisa 2"
              />
            </div>
            <div class="input-group">
              <label>Harmonisa 2 - Power Level (dBm)</label>
              <input
                v-model.number="formData.harmonics.harmonic2.power"
                type="number"
                step="0.01"
                placeholder="Power level harmonisa 2"
              />
            </div>
            <div class="input-group">
              <label>Harmonisa 3 - Frekuensi (MHz) (4×f)</label>
              <input
                v-model.number="formData.harmonics.harmonic3.frequency"
                type="number"
                step="0.001"
                placeholder="Frekuensi harmonisa 3"
              />
            </div>
            <div class="input-group">
              <label>Harmonisa 3 - Power Level (dBm)</label>
              <input
                v-model.number="formData.harmonics.harmonic3.power"
                type="number"
                step="0.01"
                placeholder="Power level harmonisa 3"
              />
            </div>
          </div>
          <div class="mt-2">
            <button
              type="button"
              @click="fillFromCalculator('harmonics')"
              class="btn btn-secondary"
            >
              Isi dari Kalkulator Harmonisa
            </button>
          </div>
        </section>

        <!-- Kondisi Pengukuran -->
        <section class="form-section">
          <h2>Kondisi Pengukuran</h2>
          <div class="form-grid grid grid-2">
            <div class="input-group">
              <label>Suhu Lingkungan (°C)</label>
              <input
                v-model.number="formData.temperature"
                type="number"
                step="0.1"
                placeholder="Suhu saat pengukuran"
              />
            </div>
            <div class="input-group">
              <label>Kelembaban (%)</label>
              <input
                v-model.number="formData.humidity"
                type="number"
                step="0.1"
                placeholder="Kelembaban udara"
              />
            </div>
            <div class="input-group">
              <label>Signal to Noise Ratio (S/N) - dB</label>
              <input
                v-model.number="formData.snr"
                type="number"
                step="0.01"
                placeholder="Rasio S/N"
              />
            </div>
            <div class="input-group">
              <label>Line of Sight (LOS)</label>
              <select v-model="formData.los">
                <option value="">Pilih kondisi</option>
                <option value="yes">Ya</option>
                <option value="no">Tidak</option>
              </select>
            </div>
          </div>
        </section>

        <!-- Peralatan -->
        <section class="form-section">
          <h2>Peralatan yang Digunakan</h2>
          <div class="form-grid grid grid-2">
            <div class="input-group">
              <label>Spectrum Analyzer</label>
              <input
                v-model="formData.equipment.spectrumAnalyzer"
                type="text"
                placeholder="Merek dan model"
              />
            </div>
            <div class="input-group">
              <label>Antena</label>
              <input
                v-model="formData.equipment.antenna"
                type="text"
                placeholder="Merek dan model"
              />
            </div>
            <div class="input-group">
              <label>Kabel</label>
              <input
                v-model="formData.equipment.cable"
                type="text"
                placeholder="Jenis dan panjang kabel"
              />
            </div>
            <div class="input-group">
              <label>No. Sertifikat Kalibrasi</label>
              <input
                v-model="formData.equipment.calibrationCert"
                type="text"
                placeholder="Nomor sertifikat"
              />
            </div>
          </div>
        </section>

        <!-- Catatan -->
        <section class="form-section">
          <h2>Catatan Tambahan</h2>
          <div class="input-group">
            <label>Catatan</label>
            <textarea
              v-model="formData.notes"
              rows="4"
              placeholder="Catatan tambahan atau observasi selama pengukuran"
            ></textarea>
          </div>
        </section>

        <!-- Actions -->
        <div class="form-actions">
          <button type="button" @click="saveDraft" class="btn btn-secondary">
            💾 Simpan Draft
          </button>
          <button type="submit" class="btn btn-primary">
            📤 Kirim Laporan
          </button>
        </div>
      </form>

      <!-- Drafts -->
      <div v-if="drafts.length > 0" class="drafts-section glass-card mt-4">
        <h2>Draft Tersimpan</h2>
        <div class="drafts-list">
          <div
            v-for="draft in drafts"
            :key="draft.id"
            class="draft-item"
          >
            <div class="draft-info">
              <div class="draft-title">{{ draft.technicianName }} - {{ draft.location }}</div>
              <div class="draft-date">{{ formatDate(draft.createdAt) }}</div>
            </div>
            <div class="draft-actions">
              <button @click="loadDraft(draft)" class="btn-small">Edit</button>
              <button @click="deleteDraft(draft.id)" class="btn-small">Hapus</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </Layout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import Layout from '../components/Layout.vue'
import { useAppStore } from '../stores/app'
import { useCalculatorStore } from '../stores/calculator'

const appStore = useAppStore()
const calculatorStore = useCalculatorStore()

const formData = ref({
  technicianName: '',
  measurementDate: '',
  location: '',
  stationType: '',
  frequency: null,
  erp: null,
  occupiedBandwidth: null,
  fieldStrength: null,
  amModulation: null,
  fmDeviation: null,
  powerLevel: null,
  temperature: null,
  humidity: null,
  snr: null,
  los: '',
  harmonics: {
    harmonic1: { frequency: null, power: null },
    harmonic2: { frequency: null, power: null },
    harmonic3: { frequency: null, power: null }
  },
  equipment: {
    spectrumAnalyzer: '',
    antenna: '',
    cable: '',
    calibrationCert: ''
  },
  notes: ''
})

const drafts = ref([])

const calculatorResults = computed(() => calculatorStore.lastResults)

function fillFromCalculator(type) {
  const result = calculatorResults.value[type]
  if (!result) {
    alert('Tidak ada hasil kalkulator untuk jenis ini. Silakan gunakan kalkulator terlebih dahulu.')
    return
  }

  switch (type) {
    case 'erp':
      formData.value.erp = result.erp
      break
    case 'occupiedBandwidth':
      formData.value.occupiedBandwidth = result.bandwidth
      break
    case 'unitConversion':
      formData.value.fieldStrength = result.dbuVPerM
      break
    case 'amModulation':
      formData.value.amModulation = result.modulationDepth
      break
    case 'fmDeviation':
      formData.value.fmDeviation = result.standardDeviation
      break
    case 'frequencyPower':
      formData.value.frequency = result.frequency
      formData.value.powerLevel = result.powerLevel
      break
    case 'harmonics':
      if (result.harmonic1) {
        formData.value.harmonics.harmonic1.frequency = result.harmonic1.frequency
        formData.value.harmonics.harmonic1.power = result.harmonic1.power
      }
      if (result.harmonic2) {
        formData.value.harmonics.harmonic2.frequency = result.harmonic2.frequency
        formData.value.harmonics.harmonic2.power = result.harmonic2.power
      }
      if (result.harmonic3) {
        formData.value.harmonics.harmonic3.frequency = result.harmonic3.frequency
        formData.value.harmonics.harmonic3.power = result.harmonic3.power
      }
      if (result.fundamentalFrequency) {
        formData.value.frequency = result.fundamentalFrequency
      }
      if (result.fundamentalPower) {
        formData.value.powerLevel = result.fundamentalPower
      }
      break
  }
}

function saveDraft() {
  const draft = {
    id: Date.now(),
    ...formData.value,
    createdAt: new Date().toISOString(),
    status: 'draft'
  }
  drafts.value.push(draft)
  localStorage.setItem('param-fm-drafts', JSON.stringify(drafts.value))
  alert('Draft berhasil disimpan!')
}

function loadDraft(draft) {
  formData.value = { ...draft }
  delete formData.value.id
  delete formData.value.createdAt
  delete formData.value.status
}

function deleteDraft(id) {
  if (confirm('Yakin ingin menghapus draft ini?')) {
    drafts.value = drafts.value.filter(d => d.id !== id)
    localStorage.setItem('param-fm-drafts', JSON.stringify(drafts.value))
  }
}

function submitForm() {
  // Validate required fields
  if (!formData.value.technicianName || !formData.value.measurementDate || 
      !formData.value.location || !formData.value.stationType || 
      !formData.value.frequency) {
    alert('Mohon lengkapi semua field yang wajib diisi!')
    return
  }

  const report = {
    ...formData.value,
    submittedAt: new Date().toISOString(),
    status: 'submitted'
  }

  appStore.addReport(report)
  alert('Laporan berhasil dikirim! (Simulasi - untuk integrasi API ke fmc.ditfrek.postel.go.id di masa depan)')
  
  // Reset form
  formData.value = {
    technicianName: '',
    measurementDate: '',
    location: '',
    stationType: '',
    frequency: null,
    erp: null,
    occupiedBandwidth: null,
    fieldStrength: null,
    amModulation: null,
    fmDeviation: null,
    powerLevel: null,
    temperature: null,
    humidity: null,
    snr: null,
    los: '',
    harmonics: {
      harmonic1: { frequency: null, power: null },
      harmonic2: { frequency: null, power: null },
      harmonic3: { frequency: null, power: null }
    },
    equipment: {
      spectrumAnalyzer: '',
      antenna: '',
      cable: '',
      calibrationCert: ''
    },
    notes: ''
  }
}

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

onMounted(() => {
  // Load drafts from localStorage
  const savedDrafts = localStorage.getItem('param-fm-drafts')
  if (savedDrafts) {
    drafts.value = JSON.parse(savedDrafts)
  }
})
</script>

<style scoped>
.form-header {
  text-align: center;
  margin-bottom: 2rem;
}

.form-header h1 {
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

.report-form {
  padding: 2rem;
}

.form-section {
  margin-bottom: 2.5rem;
  padding-bottom: 2rem;
  border-bottom: 2px solid var(--border);
}

.form-section:last-of-type {
  border-bottom: none;
}

.form-section h2 {
  font-size: 1.5rem;
  margin-bottom: 1.5rem;
  color: var(--accent);
}

.form-grid {
  margin-top: 1rem;
}

.required {
  color: #f56565;
}

.btn-small {
  padding: 0.5rem 1rem;
  font-size: 0.85rem;
  background: var(--glass-bg);
  border: 1px solid var(--border);
  border-radius: 6px;
  cursor: pointer;
  color: var(--text-primary);
  transition: all 0.3s ease;
}

.btn-small:hover {
  background: var(--glass-border);
}

.form-actions {
  display: flex;
  gap: 1rem;
  justify-content: flex-end;
  margin-top: 2rem;
  padding-top: 2rem;
  border-top: 2px solid var(--border);
}

.drafts-section {
  padding: 2rem;
}

.drafts-section h2 {
  margin-bottom: 1.5rem;
  font-size: 1.5rem;
}

.drafts-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.draft-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem;
  background: var(--glass-bg);
  border-radius: 8px;
  border: 1px solid var(--glass-border);
}

.draft-info {
  flex: 1;
}

.draft-title {
  font-weight: 600;
  margin-bottom: 0.25rem;
}

.draft-date {
  color: var(--text-secondary);
  font-size: 0.9rem;
}

.draft-actions {
  display: flex;
  gap: 0.5rem;
}

@media (max-width: 768px) {
  .form-grid {
    grid-template-columns: 1fr;
  }

  .form-actions {
    flex-direction: column;
  }

  .draft-item {
    flex-direction: column;
    align-items: flex-start;
    gap: 1rem;
  }
}
</style>
