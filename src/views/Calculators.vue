<template>
  <Layout>
    <div class="container">
      <div class="calculators-header">
        <h1>🧮 Toolkit Kalkulator</h1>
        <p class="subtitle">Perhitungan parameter teknis otomatis</p>
      </div>

      <div class="calculators-grid grid grid-2">
        <UnitConversionCalculator @result="handleResult" />
        <ERPCalculator @result="handleResult" />
        <OBWCalculator @result="handleResult" />
        <AMModulationCalculator @result="handleResult" />
        <FMDeviationCalculator @result="handleResult" />
        <FrequencyPowerCalculator @result="handleResult" />
        <HarmonicsCalculator @result="handleResult" />
      </div>

      <div v-if="lastResults" class="last-results glass-card mt-4">
        <h2>Hasil Perhitungan Terakhir</h2>
        <div class="results-list">
          <template
            v-for="(result, key) in lastResults"
            :key="key"
          >
            <div
            v-if="result"
            class="result-item"
          >
            <div class="result-title">{{ getResultTitle(key) }}</div>
            <div class="result-content">
              <pre>{{ JSON.stringify(result, null, 2) }}</pre>
            </div>
          </div>
          </template>
        </div>
      </div>
    </div>
  </Layout>
</template>

<script setup>
import { computed } from 'vue'
import Layout from '../components/Layout.vue'
import { useCalculatorStore } from '../stores/calculator'
import UnitConversionCalculator from '../components/calculators/UnitConversionCalculator.vue'
import ERPCalculator from '../components/calculators/ERPCalculator.vue'
import OBWCalculator from '../components/calculators/OBWCalculator.vue'
import AMModulationCalculator from '../components/calculators/AMModulationCalculator.vue'
import FMDeviationCalculator from '../components/calculators/FMDeviationCalculator.vue'
import FrequencyPowerCalculator from '../components/calculators/FrequencyPowerCalculator.vue'
import HarmonicsCalculator from '../components/calculators/HarmonicsCalculator.vue'

const calculatorStore = useCalculatorStore()

const lastResults = computed(() => calculatorStore.lastResults)

function handleResult(result) {
  console.log('Calculator result:', result)
}

function getResultTitle(key) {
  const titles = {
    unitConversion: 'Konversi Satuan',
    occupiedBandwidth: 'Lebar Pita Terpakai',
    erp: 'Effective Radiated Power',
    amModulation: 'Kedalaman Modulasi AM',
    fmDeviation: 'Deviasi Frekuensi FM',
    frequencyPower: 'Frekuensi dan Level Power',
    harmonics: 'Pengukuran Harmonisa'
  }
  return titles[key] || key
}
</script>

<style scoped>
.calculators-header {
  text-align: center;
  margin-bottom: 3rem;
}

.calculators-header h1 {
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

.calculators-grid {
  margin-bottom: 2rem;
}

.last-results {
  padding: 2rem;
}

.last-results h2 {
  margin-bottom: 1.5rem;
  font-size: 1.5rem;
}

.results-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.result-item {
  padding: 1rem;
  background: var(--glass-bg);
  border-radius: 8px;
  border: 1px solid var(--glass-border);
}

.result-title {
  font-weight: 600;
  margin-bottom: 0.5rem;
  color: var(--accent);
}

.result-content {
  background: var(--bg-secondary);
  padding: 1rem;
  border-radius: 6px;
  overflow-x: auto;
}

.result-content pre {
  margin: 0;
  font-size: 0.9rem;
  color: var(--text-primary);
}

@media (max-width: 768px) {
  .calculators-header h1 {
    font-size: 1.8rem;
  }
  
  .subtitle {
    font-size: 0.95rem;
  }
  
  .calculators-grid {
    grid-template-columns: 1fr;
  }
  
  .last-results {
    padding: 1.5rem;
  }
  
  .result-content {
    overflow-x: auto;
    font-size: 0.85rem;
  }
}
</style>
