<template>
  <div class="calculator glass-card">
    <h3>Frekuensi dan Level Power</h3>
    <div class="calculator-form">
      <div class="input-group">
        <label>Frekuensi Kerja (MHz)</label>
        <input
          v-model.number="frequency"
          type="number"
          step="0.001"
          placeholder="Masukkan frekuensi kerja"
        />
      </div>
      <div class="input-group">
        <label>Power Level (dBm)</label>
        <input
          v-model.number="powerLevel"
          type="number"
          step="0.01"
          placeholder="Masukkan level power"
        />
      </div>
      <div class="input-group">
        <label>Satuan Output</label>
        <select v-model="outputUnit">
          <option value="dBm">dBm</option>
          <option value="dBW">dBW</option>
          <option value="mW">mW</option>
          <option value="W">W</option>
        </select>
      </div>
      <div v-if="result" class="result">
        <div class="result-label">Hasil Pengukuran:</div>
        <div class="result-value">Frekuensi: {{ result.frequency?.toFixed(3) || '-' }} MHz</div>
        <div class="result-value">Power Level: {{ formatPower(result.powerLevel) }}</div>
        <div class="result-details">
          <div>Power Level dalam berbagai satuan:</div>
          <div>dBm: {{ result.powerLevel?.toFixed(2) || '-' }} dBm</div>
          <div>dBW: {{ result.powerInDbW?.toFixed(2) || '-' }} dBW</div>
          <div>mW: {{ result.powerInMW?.toFixed(4) || '-' }} mW</div>
          <div>W: {{ result.powerInW?.toFixed(6) || '-' }} W</div>
        </div>
      </div>
      <button @click="calculate" class="btn btn-primary mt-2">
        Hitung
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useCalculatorStore } from '../../stores/calculator'

const calculatorStore = useCalculatorStore()

const frequency = ref(null)
const powerLevel = ref(null)
const outputUnit = ref('dBm')
const result = ref(null)

function formatPower(power) {
  if (!power && power !== 0) return '-'
  const conversions = {
    dBm: power.toFixed(2) + ' dBm',
    dBW: (power - 30).toFixed(2) + ' dBW',
    mW: Math.pow(10, power / 10).toFixed(4) + ' mW',
    W: (Math.pow(10, power / 10) / 1000).toFixed(6) + ' W'
  }
  return conversions[outputUnit.value] || '-'
}

function calculate() {
  const freq = parseFloat(frequency.value)
  const power = parseFloat(powerLevel.value)
  
  if (!isNaN(freq) && !isNaN(power)) {
    result.value = calculatorStore.calculateFrequencyPower(freq, power)
    calculatorStore.setLastResult('frequencyPower', result.value)
    emit('result', result.value)
  } else {
    alert('Mohon lengkapi semua field yang diperlukan dengan nilai yang valid!')
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

.result {
  padding: 1rem;
  background: var(--glass-bg);
  border-radius: 8px;
  margin-top: 1rem;
  text-align: center;
}

.result-label {
  color: var(--text-secondary);
  font-size: 0.9rem;
  margin-bottom: 0.5rem;
}

.result-value {
  font-size: 1.2rem;
  font-weight: 700;
  color: var(--accent);
  margin: 0.5rem 0;
}

.result-details {
  margin-top: 1rem;
  padding-top: 1rem;
  border-top: 1px solid var(--border, rgba(255, 255, 255, 0.1));
  font-size: 0.9rem;
  text-align: left;
}

.result-details > div {
  margin: 0.3rem 0;
}

@media (max-width: 768px) {
  .calculator {
    padding: 1rem;
  }
  
  .calculator h3 {
    font-size: 1.1rem;
  }
  
  .result {
    padding: 0.75rem;
  }
  
  .result-value {
    font-size: 1.1rem;
  }
  
  .result-details {
    font-size: 0.85rem;
  }
}
</style>
