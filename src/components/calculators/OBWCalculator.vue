<template>
  <div class="calculator glass-card">
    <h3>Lebar Pita Terpakai (Occupied Bandwidth)</h3>
    <div class="calculator-form">
      <div class="input-group">
        <label>Metode Perhitungan</label>
        <select v-model="method">
          <option value="beta">β% (Persentase)</option>
          <option value="delta">x-dB (Delta Level)</option>
        </select>
      </div>
      
      <div v-if="method === 'beta'" class="input-group">
        <label>Daya Total (W)</label>
        <input
          v-model.number="power"
          type="number"
          step="0.01"
          placeholder="Masukkan daya total"
        />
      </div>
      <div v-if="method === 'beta'" class="input-group">
        <label>β%</label>
        <input
          v-model.number="betaPercent"
          type="number"
          step="0.01"
          placeholder="Masukkan persentase bandwidth"
        />
      </div>

      <div v-if="method === 'delta'" class="input-group">
        <label>Daya (W)</label>
        <input
          v-model.number="power"
          type="number"
          step="0.01"
          placeholder="Masukkan daya"
        />
      </div>
      <div v-if="method === 'delta'" class="input-group">
        <label>Delta Level (dB)</label>
        <input
          v-model.number="deltaLevel"
          type="number"
          step="0.01"
          placeholder="Masukkan delta level"
        />
      </div>

      <div v-if="result" class="result">
        <div class="result-label">Bandwidth:</div>
        <div class="result-value">{{ result.bandwidth.toFixed(2) }} Hz</div>
        <div class="result-details">
          <div v-if="result.method === 'beta'">
            Bandwidth = (Daya × β%) / 100
          </div>
          <div v-else>
            Bandwidth = Daya × 10^(Delta Level / 10)
          </div>
        </div>
      </div>
      <button @click="calculate" class="btn btn-primary mt-2">
        Hitung OBW
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useCalculatorStore } from '../../stores/calculator'

const calculatorStore = useCalculatorStore()

const method = ref('beta')
const power = ref(null)
const betaPercent = ref(null)
const deltaLevel = ref(null)
const result = ref(null)

function calculate() {
  if (method.value === 'beta' && power.value !== null && betaPercent.value !== null) {
    result.value = calculatorStore.calculateOBW(power.value, null, betaPercent.value)
    calculatorStore.setLastResult('occupiedBandwidth', result.value)
    emit('result', result.value)
  } else if (method.value === 'delta' && power.value !== null && deltaLevel.value !== null) {
    result.value = calculatorStore.calculateOBW(power.value, deltaLevel.value)
    calculatorStore.setLastResult('occupiedBandwidth', result.value)
    emit('result', result.value)
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
  font-size: 1.5rem;
  font-weight: 700;
  color: var(--accent);
  margin-bottom: 1rem;
}

.result-details {
  margin-top: 1rem;
  padding-top: 1rem;
  border-top: 1px solid var(--border, rgba(255, 255, 255, 0.1));
  font-size: 0.9rem;
  color: var(--text-secondary);
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
    font-size: 1.2rem;
  }
  
  .result-details {
    font-size: 0.85rem;
  }
}
</style>
