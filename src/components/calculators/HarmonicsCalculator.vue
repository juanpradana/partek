<template>
  <div class="calculator glass-card">
    <h3>Pengukuran Harmonisa</h3>
    <div class="calculator-form">
      <div class="input-group">
        <label>Frekuensi Fundamental (MHz)</label>
        <input
          v-model.number="fundamentalFrequency"
          type="number"
          step="0.001"
          placeholder="Masukkan frekuensi fundamental"
        />
      </div>
      <div class="input-group">
        <label>Power Level Fundamental (dBm)</label>
        <input
          v-model.number="fundamentalPower"
          type="number"
          step="0.01"
          placeholder="Masukkan power level fundamental"
        />
      </div>

      <div class="harmonics-section">
        <h4>Harmonisa</h4>
        
        <!-- Harmonisa 1 (2nd Harmonic) -->
        <div class="harmonic-group">
          <div class="harmonic-header">
            <strong>Harmonisa 1 (2<sup>nd</sup> Harmonic - 2×f)</strong>
          </div>
          <div class="harmonic-inputs">
            <div class="input-group">
              <label>Frekuensi (MHz)</label>
              <input
                v-model.number="harmonic1.frequency"
                type="number"
                step="0.001"
                placeholder="2 × frekuensi fundamental"

              />
            </div>
            <div class="input-group">
              <label>Power Level (dBm)</label>
              <input
                v-model.number="harmonic1.power"
                type="number"
                step="0.01"
                placeholder="Masukkan power level"
              />
            </div>
            <div v-if="harmonic1.frequency && harmonic1.power && fundamentalPower" class="harmonic-result">
              <div>Selisih: {{ (fundamentalPower - harmonic1.power).toFixed(2) }} dB</div>
            </div>
          </div>
        </div>

        <!-- Harmonisa 2 (3rd Harmonic) -->
        <div class="harmonic-group">
          <div class="harmonic-header">
            <strong>Harmonisa 2 (3<sup>rd</sup> Harmonic - 3×f)</strong>
          </div>
          <div class="harmonic-inputs">
            <div class="input-group">
              <label>Frekuensi (MHz)</label>
              <input
                v-model.number="harmonic2.frequency"
                type="number"
                step="0.001"
                placeholder="3 × frekuensi fundamental"
              />
            </div>
            <div class="input-group">
              <label>Power Level (dBm)</label>
              <input
                v-model.number="harmonic2.power"
                type="number"
                step="0.01"
                placeholder="Masukkan power level"
              />
            </div>
            <div v-if="harmonic2.frequency && harmonic2.power && fundamentalPower" class="harmonic-result">
              <div>Selisih: {{ (fundamentalPower - harmonic2.power).toFixed(2) }} dB</div>
            </div>
          </div>
        </div>

        <!-- Harmonisa 3 (4th Harmonic) -->
        <div class="harmonic-group">
          <div class="harmonic-header">
            <strong>Harmonisa 3 (4<sup>th</sup> Harmonic - 4×f)</strong>
          </div>
          <div class="harmonic-inputs">
            <div class="input-group">
              <label>Frekuensi (MHz)</label>
              <input
                v-model.number="harmonic3.frequency"
                type="number"
                step="0.001"
                placeholder="4 × frekuensi fundamental"
              />
            </div>
            <div class="input-group">
              <label>Power Level (dBm)</label>
              <input
                v-model.number="harmonic3.power"
                type="number"
                step="0.01"
                placeholder="Masukkan power level"
              />
            </div>
            <div v-if="harmonic3.frequency && harmonic3.power && fundamentalPower" class="harmonic-result">
              <div>Selisih: {{ (fundamentalPower - harmonic3.power).toFixed(2) }} dB</div>
            </div>
          </div>
        </div>
      </div>

      <div v-if="result" class="result">
        <div class="result-label">Ringkasan Pengukuran Harmonisa:</div>
        <div class="result-summary">
          <div><strong>Fundamental:</strong> {{ result.fundamentalFrequency?.toFixed(3) || '-' }} MHz, {{ result.fundamentalPower?.toFixed(2) || '-' }} dBm</div>
          <div v-if="result.harmonic1 && result.harmonic1.frequency"><strong>Harmonisa 1 (2×f):</strong> {{ result.harmonic1.frequency.toFixed(3) }} MHz, {{ result.harmonic1.power.toFixed(2) }} dBm (Selisih: {{ result.harmonic1.difference.toFixed(2) }} dB)</div>
          <div v-if="result.harmonic2 && result.harmonic2.frequency"><strong>Harmonisa 2 (3×f):</strong> {{ result.harmonic2.frequency.toFixed(3) }} MHz, {{ result.harmonic2.power.toFixed(2) }} dBm (Selisih: {{ result.harmonic2.difference.toFixed(2) }} dB)</div>
          <div v-if="result.harmonic3 && result.harmonic3.frequency"><strong>Harmonisa 3 (4×f):</strong> {{ result.harmonic3.frequency.toFixed(3) }} MHz, {{ result.harmonic3.power.toFixed(2) }} dBm (Selisih: {{ result.harmonic3.difference.toFixed(2) }} dB)</div>
        </div>
      </div>
      <button @click="calculate" class="btn btn-primary mt-2">
        Hitung Harmonisa
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import { useCalculatorStore } from '../../stores/calculator'

const calculatorStore = useCalculatorStore()

const fundamentalFrequency = ref(null)
const fundamentalPower = ref(null)
const harmonic1 = ref({ frequency: null, power: null })
const harmonic2 = ref({ frequency: null, power: null })
const harmonic3 = ref({ frequency: null, power: null })
const result = ref(null)

// Auto-calculate harmonic frequencies when fundamental changes
function calculateHarmonicFrequencies() {
  if (fundamentalFrequency.value !== null && fundamentalFrequency.value !== '') {
    const freq = parseFloat(fundamentalFrequency.value)
    if (!isNaN(freq)) {
      harmonic1.value.frequency = freq * 2
      harmonic2.value.frequency = freq * 3
      harmonic3.value.frequency = freq * 4
    }
  }
}

// Watch for changes in fundamental frequency
watch(fundamentalFrequency, (newVal) => {
  if (newVal !== null && newVal !== '') {
    calculateHarmonicFrequencies()
  }
}, { immediate: false })

function calculate() {
  const freq = parseFloat(fundamentalFrequency.value)
  const power = parseFloat(fundamentalPower.value)
  
  if (!isNaN(freq) && !isNaN(power)) {
    // Auto-calculate frequencies if not set
    calculateHarmonicFrequencies()
    
    result.value = calculatorStore.calculateHarmonics(
      freq,
      power,
      harmonic1.value,
      harmonic2.value,
      harmonic3.value
    )
    calculatorStore.setLastResult('harmonics', result.value)
    emit('result', result.value)
  } else {
    alert('Mohon lengkapi frekuensi fundamental dan power level fundamental dengan nilai yang valid!')
  }
}

const emit = defineEmits(['result'])
</script>

<style scoped>
.calculator {
  padding: 1.5rem;
}

.calculator h3 {
  margin-bottom: 1.5rem;
  font-size: 1.3rem;
}

.harmonics-section {
  margin-top: 1.5rem;
}

.harmonics-section h4 {
  margin-bottom: 1rem;
  color: var(--text-primary);
}

.harmonic-group {
  margin-bottom: 1.5rem;
  padding: 1rem;
  background: var(--glass-bg);
  border-radius: 8px;
  border: 1px solid var(--border, rgba(255, 255, 255, 0.1));
}

.harmonic-header {
  margin-bottom: 1rem;
  color: var(--accent);
  font-size: 1rem;
}

.harmonic-inputs {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}

.harmonic-result {
  grid-column: 1 / -1;
  padding: 0.5rem;
  background: rgba(66, 153, 225, 0.1);
  border-radius: 4px;
  font-size: 0.9rem;
}

.result {
  padding: 1rem;
  background: var(--glass-bg);
  border-radius: 8px;
  margin-top: 1rem;
}

.result-label {
  color: var(--text-secondary);
  font-size: 0.9rem;
  margin-bottom: 0.5rem;
  font-weight: 600;
}

.result-summary {
  margin-top: 0.5rem;
  font-size: 0.95rem;
  line-height: 1.8;
}

.result-summary > div {
  margin: 0.3rem 0;
  padding: 0.3rem;
  background: rgba(66, 153, 225, 0.05);
  border-radius: 4px;
}

@media (max-width: 768px) {
  .calculator {
    padding: 1rem;
  }
  
  .calculator h3 {
    font-size: 1.1rem;
  }
  
  .harmonics-section h4 {
    font-size: 1rem;
  }
  
  .harmonic-inputs {
    grid-template-columns: 1fr;
  }
  
  .harmonic-group {
    padding: 0.75rem;
  }
  
  .harmonic-header {
    font-size: 0.95rem;
  }
  
  .result {
    padding: 0.75rem;
  }
  
  .result-summary {
    font-size: 0.9rem;
  }
}
</style>
