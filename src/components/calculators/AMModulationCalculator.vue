<template>
  <div class="calculator glass-card">
    <h3>Kedalaman Modulasi AM</h3>
    <div class="calculator-form">
      <div class="input-group">
        <label>(Esb/Ec) dB</label>
        <input
          v-model.number="esbEcDb"
          type="number"
          step="0.01"
          placeholder="Masukkan nilai Esb/Ec dalam dB"
        />
      </div>
      <div v-if="result" class="result">
        <div class="result-label">Kedalaman Modulasi:</div>
        <div class="result-value">{{ result.modulationDepth.toFixed(2) }}%</div>
        <div class="result-details">
          <div>Rasio = 10^({{ result.esbEcDb }} / 20) = {{ result.ratio.toFixed(4) }}</div>
          <div>Modulasi = (Rasio / (1 + Rasio)) × 100%</div>
        </div>
      </div>
      <button @click="calculate" class="btn btn-primary mt-2">
        Hitung
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useCalculatorStore } from '../../stores/calculator'

const calculatorStore = useCalculatorStore()

const esbEcDb = ref(null)
const result = ref(null)

function calculate() {
  if (esbEcDb.value !== null) {
    result.value = calculatorStore.calculateAMModulation(esbEcDb.value)
    calculatorStore.setLastResult('amModulation', result.value)
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
  border-top: 1px solid var(--border);
  font-size: 0.9rem;
  color: var(--text-secondary);
  text-align: left;
}

.result-details div {
  margin-bottom: 0.25rem;
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
    border-top: 1px solid var(--border, rgba(255, 255, 255, 0.1));
  }
}
</style>
