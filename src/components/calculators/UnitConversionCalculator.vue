<template>
  <div class="calculator glass-card">
    <h3>Konversi Satuan: dBµV ↔ dBµV/m</h3>
    <div class="calculator-form">
      <div class="input-group">
        <label>dBµV</label>
        <input
          v-model.number="dbuV"
          type="number"
          step="0.01"
          placeholder="Masukkan nilai dBµV"
        />
      </div>
      <div class="input-group">
        <label>Antenna Factor (dB/m)</label>
        <input
          v-model.number="antennaFactor"
          type="number"
          step="0.01"
          placeholder="Masukkan Antenna Factor"
        />
      </div>
      <div class="input-group">
        <label>Cable Loss (dB)</label>
        <input
          v-model.number="cableLoss"
          type="number"
          step="0.01"
          placeholder="Masukkan Cable Loss"
        />
      </div>
      <div v-if="result" class="result">
        <div class="result-label">dBµV/m:</div>
        <div class="result-value">{{ result.dbuVPerM.toFixed(2) }} dBµV/m</div>
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

const dbuV = ref(null)
const antennaFactor = ref(null)
const cableLoss = ref(null)
const result = ref(null)

function calculate() {
  if (dbuV.value !== null && antennaFactor.value !== null && cableLoss.value !== null) {
    result.value = calculatorStore.convertUnits(
      dbuV.value,
      antennaFactor.value,
      cableLoss.value
    )
    calculatorStore.setLastResult('unitConversion', result.value)
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
}
</style>
