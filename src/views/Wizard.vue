<template>
  <Layout>
    <div class="container">
      <div class="wizard-header">
        <h1>🧭 Wizard Pengukuran Partek</h1>
        <p class="subtitle">Panduan interaktif langkah demi langkah sesuai SOP 92/2021</p>
      </div>

      <div v-if="!selectedType" class="selection-step glass-card">
        <h2>Pilih Jenis Pengukuran</h2>
        <div class="measurement-types grid grid-2">
          <button
            v-for="type in measurementTypes"
            :key="type.id"
            @click="selectType(type)"
            class="type-card glass-card"
          >
            <div class="type-icon">{{ type.icon }}</div>
            <h3>{{ type.name }}</h3>
            <p>{{ type.description }}</p>
          </button>
        </div>
      </div>

      <div v-else class="wizard-content">
        <!-- Prerequisites & Safety -->
        <div class="prerequisites glass-card mb-3">
          <h2>⚠️ Prasyarat & Peringatan Keselamatan</h2>
          <div class="prereq-list">
            <div
              v-for="(prereq, index) in currentType.prerequisites"
              :key="index"
              class="prereq-item"
            >
              <span class="prereq-icon">✓</span>
              <span>{{ prereq }}</span>
            </div>
          </div>
        </div>

        <!-- Spectrum Analyzer Settings -->
        <div class="analyzer-settings glass-card mb-3">
          <h2>⚙️ Pengaturan Rekomendasi Spectrum Analyzer</h2>
          <div class="settings-grid grid grid-2">
            <div
              v-for="(setting, key) in currentType.analyzerSettings"
              :key="key"
              class="setting-item"
            >
              <label>{{ setting.label }}</label>
              <div class="setting-value-group">
                <input
                  :value="setting.value"
                  readonly
                  class="setting-input"
                />
                <button
                  @click="copyToClipboard(setting.value, setting.label)"
                  class="copy-btn"
                  title="Salin"
                >
                  📋
                </button>
              </div>
            </div>
          </div>
          <button @click="copyAllSettings" class="btn btn-secondary mt-2">
            📋 Salin Semua Pengaturan
          </button>
        </div>

        <!-- Steps -->
        <div class="steps-container glass-card">
          <h2>📋 Langkah-langkah Pengukuran</h2>
          <div class="steps-list">
            <div
              v-for="(step, index) in currentType.steps"
              :key="index"
              class="step-item"
              :class="{ active: currentStep === index, completed: step.completed }"
            >
              <div class="step-header" @click="toggleStep(index)">
                <div class="step-number">{{ index + 1 }}</div>
                <div class="step-title">{{ step.title }}</div>
                <div class="step-toggle">{{ currentStep === index ? '▼' : '▶' }}</div>
              </div>
              <div v-if="currentStep === index" class="step-content">
                <p class="step-description">{{ step.description }}</p>
                <div v-if="step.checklist" class="step-checklist">
                  <label
                    v-for="(item, itemIndex) in step.checklist"
                    :key="itemIndex"
                    class="checklist-item"
                  >
                    <input
                      type="checkbox"
                      v-model="item.checked"
                      @change="updateStepProgress(index)"
                    />
                    <span>{{ item.text }}</span>
                  </label>
                </div>
                <!-- Embedded Calculator -->
                <div v-if="step.calculator" class="embedded-calculator mt-3">
                  <component
                    :is="step.calculator"
                    @result="handleCalculatorResult($event, index)"
                  />
                </div>
                <div class="step-actions mt-3">
                  <button
                    v-if="index > 0"
                    @click="previousStep"
                    class="btn btn-secondary"
                  >
                    ← Sebelumnya
                  </button>
                  <button
                    v-if="index < currentType.steps.length - 1"
                    @click="nextStep"
                    class="btn btn-primary"
                  >
                    Lanjutkan →
                  </button>
                  <button
                    v-else
                    @click="completeMeasurement"
                    class="btn btn-primary"
                  >
                    ✅ Selesai
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="wizard-actions mt-3">
          <button @click="resetWizard" class="btn btn-secondary">
            🔄 Mulai Ulang
          </button>
        </div>
      </div>
    </div>
  </Layout>
</template>

<script setup>
import { ref, computed } from 'vue'
import Layout from '../components/Layout.vue'
import { useAppStore } from '../stores/app'
import UnitConversionCalculator from '../components/calculators/UnitConversionCalculator.vue'
import ERPCalculator from '../components/calculators/ERPCalculator.vue'
import OBWCalculator from '../components/calculators/OBWCalculator.vue'
import FrequencyPowerCalculator from '../components/calculators/FrequencyPowerCalculator.vue'
import HarmonicsCalculator from '../components/calculators/HarmonicsCalculator.vue'

const appStore = useAppStore()

const selectedType = ref(null)
const currentStep = ref(0)

const measurementTypes = [
  {
    id: 'frequency',
    name: 'Frekuensi Kerja',
    icon: '📡',
    description: 'Pengukuran frekuensi kerja stasiun radio',
    prerequisites: [
      'Pastikan S/N ≥ 60 dB',
      'Kondisi Line of Sight (LOS) terpenuhi',
      'Lingkungan bebas dari interferensi',
      'Spectrum Analyzer sudah dikalibrasi'
    ],
    analyzerSettings: {
      frequency: { label: 'Frekuensi Center', value: 'Sesuai frekuensi kerja' },
      span: { label: 'Span', value: '100 kHz' },
      rbw: { label: 'RBW', value: '1 kHz' },
      vbw: { label: 'VBW', value: '3 kHz' },
      sweepTime: { label: 'Sweep Time', value: 'Auto' }
    },
    steps: [
      {
        title: 'Persiapan Alat',
        description: 'Pastikan semua peralatan siap dan dikalibrasi',
        checklist: [
          { text: 'Spectrum Analyzer dikalibrasi', checked: false },
          { text: 'Antena dipasang dengan benar', checked: false },
          { text: 'Kabel terhubung dengan baik', checked: false }
        ],
        completed: false
      },
      {
        title: 'Pengaturan Spectrum Analyzer',
        description: 'Setel parameter sesuai rekomendasi di atas',
        checklist: [
          { text: 'Frekuensi center disetel', checked: false },
          { text: 'Span dikonfigurasi', checked: false },
          { text: 'RBW dan VBW disetel', checked: false }
        ],
        completed: false
      },
      {
        title: 'Pengukuran Frekuensi dan Power Level',
        description: 'Lakukan pengukuran dan catat hasilnya',
        calculator: FrequencyPowerCalculator,
        checklist: [
          { text: 'Bacaan frekuensi dicatat', checked: false },
          { text: 'Bacaan power level dicatat', checked: false },
          { text: 'Verifikasi hasil pengukuran', checked: false }
        ],
        completed: false
      }
    ]
  },
  {
    id: 'frequency-power',
    name: 'Frekuensi dan Level Power',
    icon: '📊',
    description: 'Pengukuran frekuensi kerja dan level power',
    prerequisites: [
      'Pastikan S/N ≥ 60 dB',
      'Kondisi Line of Sight (LOS) terpenuhi',
      'Spectrum Analyzer sudah dikalibrasi',
      'Power meter atau spectrum analyzer dalam mode power measurement'
    ],
    analyzerSettings: {
      frequency: { label: 'Frekuensi Center', value: 'Sesuai frekuensi kerja' },
      span: { label: 'Span', value: '100 kHz' },
      rbw: { label: 'RBW', value: '1 kHz' },
      vbw: { label: 'VBW', value: '3 kHz' },
      sweepTime: { label: 'Sweep Time', value: 'Auto' },
      referenceLevel: { label: 'Reference Level', value: 'Sesuai dengan power level yang diukur' }
    },
    steps: [
      {
        title: 'Persiapan Alat',
        description: 'Pastikan semua peralatan siap dan dikalibrasi',
        checklist: [
          { text: 'Spectrum Analyzer dikalibrasi', checked: false },
          { text: 'Power meter dikalibrasi (jika digunakan)', checked: false },
          { text: 'Antena atau coupler terhubung dengan benar', checked: false }
        ],
        completed: false
      },
      {
        title: 'Pengaturan Spectrum Analyzer',
        description: 'Setel parameter sesuai rekomendasi',
        checklist: [
          { text: 'Frekuensi center disetel', checked: false },
          { text: 'Span dikonfigurasi', checked: false },
          { text: 'RBW dan VBW disetel', checked: false },
          { text: 'Reference level disetel', checked: false }
        ],
        completed: false
      },
      {
        title: 'Pengukuran Frekuensi dan Power Level',
        description: 'Lakukan pengukuran dan hitung menggunakan kalkulator',
        calculator: FrequencyPowerCalculator,
        checklist: [
          { text: 'Frekuensi kerja dicatat', checked: false },
          { text: 'Power level dicatat', checked: false },
          { text: 'Hasil perhitungan diverifikasi', checked: false }
        ],
        completed: false
      }
    ]
  },
  {
    id: 'bandwidth',
    name: 'Lebar Pita Terpakai',
    icon: '📊',
    description: 'Pengukuran Occupied Bandwidth (OBW)',
    prerequisites: [
      'Pastikan S/N ≥ 60 dB',
      'Sinyal stabil dan tidak terdistorsi',
      'Span mencakup seluruh sinyal'
    ],
    analyzerSettings: {
      frequency: { label: 'Frekuensi Center', value: 'Sesuai frekuensi kerja' },
      span: { label: 'Span', value: '200% dari bandwidth terduga' },
      rbw: { label: 'RBW', value: '≤ 1% dari bandwidth' },
      vbw: { label: 'VBW', value: '3x RBW' },
      sweepTime: { label: 'Sweep Time', value: 'Auto' }
    },
    steps: [
      {
        title: 'Persiapan',
        description: 'Siapkan alat dan setel parameter',
        checklist: [
          { text: 'Spectrum Analyzer siap', checked: false },
          { text: 'Span disetel dengan benar', checked: false }
        ],
        completed: false
      },
      {
        title: 'Pengukuran OBW',
        description: 'Lakukan pengukuran dan hitung OBW',
        calculator: OBWCalculator,
        checklist: [
          { text: 'Bacaan daya dicatat', checked: false },
          { text: 'OBW dihitung', checked: false }
        ],
        completed: false
      }
    ]
  },
  {
    id: 'field-strength',
    name: 'Kekuatan Medan',
    icon: '⚡',
    description: 'Pengukuran kekuatan medan listrik',
    prerequisites: [
      'Pastikan S/N ≥ 60 dB',
      'Antena Factor diketahui',
      'Cable Loss diketahui',
      'Kondisi lingkungan stabil'
    ],
    analyzerSettings: {
      frequency: { label: 'Frekuensi Center', value: 'Sesuai frekuensi kerja' },
      span: { label: 'Span', value: '100 kHz' },
      rbw: { label: 'RBW', value: '1 kHz' },
      vbw: { label: 'VBW', value: '3 kHz' },
      sweepTime: { label: 'Sweep Time', value: 'Auto' }
    },
    steps: [
      {
        title: 'Persiapan',
        description: 'Siapkan alat dan catat parameter antena',
        checklist: [
          { text: 'Antena Factor dicatat', checked: false },
          { text: 'Cable Loss diketahui', checked: false }
        ],
        completed: false
      },
      {
        title: 'Konversi Satuan',
        description: 'Konversi dari dBµV ke dBµV/m',
        calculator: UnitConversionCalculator,
        checklist: [
          { text: 'Bacaan dBµV dicatat', checked: false },
          { text: 'Konversi ke dBµV/m dilakukan', checked: false }
        ],
        completed: false
      }
    ]
  },
  {
    id: 'erp',
    name: 'Effective Radiated Power (ERP)',
    icon: '📻',
    description: 'Pengukuran daya pancar efektif',
    prerequisites: [
      'Tx Power diketahui',
      'Antenna Gain diketahui',
      'Cable Loss diketahui'
    ],
    analyzerSettings: {
      frequency: { label: 'Frekuensi Center', value: 'Sesuai frekuensi kerja' },
      span: { label: 'Span', value: '100 kHz' },
      rbw: { label: 'RBW', value: '1 kHz' },
      vbw: { label: 'VBW', value: '3 kHz' },
      sweepTime: { label: 'Sweep Time', value: 'Auto' }
    },
    steps: [
      {
        title: 'Pengumpulan Data',
        description: 'Kumpulkan parameter yang diperlukan',
        checklist: [
          { text: 'Tx Power dicatat', checked: false },
          { text: 'Antenna Gain dicatat', checked: false },
          { text: 'Cable Loss dicatat', checked: false }
        ],
        completed: false
      },
      {
        title: 'Perhitungan ERP',
        description: 'Hitung ERP menggunakan kalkulator',
        calculator: ERPCalculator,
        checklist: [
          { text: 'ERP dihitung', checked: false },
          { text: 'Hasil dicatat', checked: false }
        ],
        completed: false
      }
    ]
  },
  {
    id: 'harmonics',
    name: 'Pengukuran Harmonisa',
    icon: '🔊',
    description: 'Pengukuran harmonisa (harmonik 2, 3, dan 4) dengan frekuensi dan power level',
    prerequisites: [
      'Pastikan S/N ≥ 60 dB',
      'Frekuensi fundamental sudah diketahui',
      'Span mencakup hingga harmonik ke-4 atau lebih',
      'Spectrum Analyzer dalam mode frequency domain',
      'Reference level disetel sesuai dengan fundamental'
    ],
    analyzerSettings: {
      frequency: { label: 'Frekuensi Center', value: '2× atau 3× frekuensi fundamental' },
      span: { label: 'Span', value: 'Mencakup fundamental hingga harmonik ke-4' },
      rbw: { label: 'RBW', value: '1 kHz' },
      vbw: { label: 'VBW', value: '3 kHz' },
      sweepTime: { label: 'Sweep Time', value: 'Auto' },
      referenceLevel: { label: 'Reference Level', value: 'Sesuai dengan power fundamental' }
    },
    steps: [
      {
        title: 'Persiapan Alat',
        description: 'Pastikan semua peralatan siap dan dikalibrasi',
        checklist: [
          { text: 'Spectrum Analyzer dikalibrasi', checked: false },
          { text: 'Span mencakup seluruh harmonik yang akan diukur', checked: false },
          { text: 'Antena atau coupler terhubung dengan benar', checked: false }
        ],
        completed: false
      },
      {
        title: 'Pengaturan Spectrum Analyzer',
        description: 'Setel parameter untuk pengukuran harmonik',
        checklist: [
          { text: 'Frekuensi center disetel untuk mencakup harmonik', checked: false },
          { text: 'Span dikonfigurasi dengan benar', checked: false },
          { text: 'RBW dan VBW disetel', checked: false },
          { text: 'Reference level disetel sesuai fundamental', checked: false }
        ],
        completed: false
      },
      {
        title: 'Pengukuran Fundamental',
        description: 'Catat frekuensi dan power level fundamental',
        checklist: [
          { text: 'Frekuensi fundamental dicatat', checked: false },
          { text: 'Power level fundamental dicatat', checked: false }
        ],
        completed: false
      },
      {
        title: 'Pengukuran Harmonisa',
        description: 'Ukur harmonisa 1 (2×f), harmonisa 2 (3×f), dan harmonisa 3 (4×f)',
        calculator: HarmonicsCalculator,
        checklist: [
          { text: 'Harmonisa 1 (2×f) - frekuensi dan power dicatat', checked: false },
          { text: 'Harmonisa 2 (3×f) - frekuensi dan power dicatat', checked: false },
          { text: 'Harmonisa 3 (4×f) - frekuensi dan power dicatat', checked: false },
          { text: 'Selisih power terhadap fundamental dihitung', checked: false }
        ],
        completed: false
      }
    ]
  }
]

const currentType = computed(() => selectedType.value)

function selectType(type) {
  selectedType.value = { ...type }
  currentStep.value = 0
}

function toggleStep(index) {
  currentStep.value = currentStep.value === index ? -1 : index
}

function nextStep() {
  if (currentStep.value < currentType.value.steps.length - 1) {
    currentStep.value++
  }
}

function previousStep() {
  if (currentStep.value > 0) {
    currentStep.value--
  }
}

function updateStepProgress(stepIndex) {
  const step = currentType.value.steps[stepIndex]
  step.completed = step.checklist.every(item => item.checked)
}

function handleCalculatorResult(result, stepIndex) {
  // Store calculator result for use in report
  // Result is handled by the calculator component
}

async function copyToClipboard(text, label) {
  try {
    await navigator.clipboard.writeText(text)
    alert(`${label} berhasil disalin: ${text}`)
  } catch (err) {
    // Silently fail - clipboard access may not be available
    alert('Gagal menyalin ke clipboard. Silakan salin secara manual.')
  }
}

function copyAllSettings() {
  const settings = currentType.value.analyzerSettings
  const text = Object.entries(settings)
    .map(([key, setting]) => `${setting.label}: ${setting.value}`)
    .join('\n')
  copyToClipboard(text, 'Semua Pengaturan')
}

function completeMeasurement() {
  appStore.addMeasurement({
    type: currentType.value.name,
    completedAt: new Date().toISOString()
  })
  alert('Pengukuran selesai! Data telah disimpan.')
  resetWizard()
}

function resetWizard() {
  selectedType.value = null
  currentStep.value = 0
}
</script>

<style scoped>
.wizard-header {
  text-align: center;
  margin-bottom: 2rem;
}

.wizard-header h1 {
  font-size: 2.5rem;
  margin-bottom: 0.5rem;
  background: linear-gradient(135deg, var(--accent) 0%, #667eea 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.selection-step {
  padding: 2rem;
}

.selection-step h2 {
  margin-bottom: 2rem;
  text-align: center;
}

.type-card {
  padding: 2rem;
  text-align: center;
  cursor: pointer;
  border: 2px solid transparent;
  transition: all 0.3s ease;
}

.type-card:hover {
  border-color: var(--accent);
  transform: translateY(-4px);
}

.type-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.type-card h3 {
  margin-bottom: 0.5rem;
  font-size: 1.5rem;
}

.prerequisites,
.analyzer-settings {
  padding: 2rem;
}

.prerequisites h2,
.analyzer-settings h2 {
  margin-bottom: 1.5rem;
  font-size: 1.5rem;
}

.prereq-list {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.prereq-item {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 0.75rem;
  background: var(--glass-bg);
  border-radius: 8px;
}

.prereq-icon {
  color: #48bb78;
  font-weight: bold;
  font-size: 1.2rem;
}

.setting-item {
  margin-bottom: 1rem;
}

.setting-item label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
  color: var(--text-secondary);
}

.setting-value-group {
  display: flex;
  gap: 0.5rem;
}

.setting-input {
  flex: 1;
  padding: 0.5rem;
  background: var(--glass-bg);
  border: 1px solid var(--border);
  border-radius: 6px;
  color: var(--text-primary);
}

.copy-btn {
  padding: 0.5rem 1rem;
  background: var(--glass-bg);
  border: 1px solid var(--border);
  border-radius: 6px;
  cursor: pointer;
  font-size: 1.2rem;
  transition: all 0.3s ease;
}

.copy-btn:hover {
  background: var(--glass-border);
  transform: scale(1.1);
}

.steps-container {
  padding: 2rem;
}

.steps-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.step-item {
  border: 2px solid var(--border);
  border-radius: 12px;
  overflow: hidden;
  transition: all 0.3s ease;
}

.step-item.active {
  border-color: var(--accent);
  box-shadow: 0 4px 20px rgba(66, 153, 225, 0.3);
}

.step-item.completed {
  border-color: #48bb78;
  background: rgba(72, 187, 120, 0.1);
}

.step-header {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1.5rem;
  cursor: pointer;
  background: var(--glass-bg);
}

.step-number {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: linear-gradient(135deg, var(--accent) 0%, #667eea 100%);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  flex-shrink: 0;
}

.step-item.completed .step-number {
  background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
}

.step-title {
  flex: 1;
  font-weight: 600;
  font-size: 1.1rem;
}

.step-toggle {
  font-size: 1.2rem;
}

.step-content {
  padding: 1.5rem;
  background: var(--bg-secondary);
}

.step-description {
  margin-bottom: 1rem;
  color: var(--text-secondary);
  line-height: 1.6;
}

.step-checklist {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.checklist-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem;
  background: var(--glass-bg);
  border-radius: 8px;
  cursor: pointer;
}

.checklist-item input[type="checkbox"] {
  width: 20px;
  height: 20px;
  cursor: pointer;
}

.embedded-calculator {
  border-top: 2px solid var(--border);
  padding-top: 1.5rem;
  margin-top: 1.5rem;
}

.step-actions {
  display: flex;
  gap: 1rem;
  justify-content: flex-end;
}

.wizard-actions {
  text-align: center;
}

@media (max-width: 768px) {
  .wizard-header h1 {
    font-size: 1.8rem;
  }
  
  .subtitle {
    font-size: 0.95rem;
  }
  
  .selection-step {
    padding: 1.5rem;
  }
  
  .selection-step h2 {
    font-size: 1.3rem;
  }
  
  .type-card {
    padding: 1.5rem;
  }
  
  .type-icon {
    font-size: 2.5rem;
  }
  
  .type-card h3 {
    font-size: 1.3rem;
  }
  
  .prerequisites,
  .analyzer-settings {
    padding: 1.5rem;
  }
  
  .prerequisites h2,
  .analyzer-settings h2 {
    font-size: 1.3rem;
  }
  
  .settings-grid {
    grid-template-columns: 1fr;
  }
  
  .steps-container {
    padding: 1.5rem;
  }
  
  .step-header {
    padding: 1rem;
    flex-wrap: wrap;
    gap: 0.75rem;
  }
  
  .step-number {
    width: 35px;
    height: 35px;
    font-size: 0.9rem;
  }
  
  .step-title {
    font-size: 1rem;
    min-width: 0;
    flex: 1 1 auto;
  }
  
  .step-content {
    padding: 1rem;
  }
  
  .step-actions {
    flex-direction: column;
  }
  
  .step-actions .btn {
    width: 100%;
  }
  
  .wizard-actions .btn {
    width: 100%;
  }
}
</style>
