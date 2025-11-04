<template>
  <div class="calculator glass-card">
    <h3>Effective Radiated Power (ERP)</h3>
    <div class="calculator-form">
      <div class="input-group">
        <label>Tx Power (dBm)</label>
        <input
          v-model.number="txPower"
          type="number"
          step="0.01"
          placeholder="Masukkan daya pancar"
        />
      </div>
      <div class="input-group">
        <label>Antenna Gain (dBi)</label>
        <input
          v-model.number="antennaGain"
          type="number"
          step="0.01"
          placeholder="Masukkan gain antena"
        />
      </div>
      <div class="input-group">
        <label>Cable Loss (dB)</label>
        <input
          v-model.number="cableLoss"
          type="number"
          step="0.01"
          placeholder="Masukkan loss kabel"
        />
      </div>
      <div v-if="result" class="result">
        <div class="result-label">ERP:</div>
        <div class="result-value">{{ result.erp.toFixed(2) }} dBm</div>
        <div class="result-details">
          <div>ERP = Tx Power + Antenna Gain - Cable Loss</div>
          <div>= {{ result.txPower }} + {{ result.antennaGain }} - {{ result.cableLoss }}</div>
        </div>
      </div>
      <button @click="calculate" class="btn btn-primary mt-2">
        Hitung ERP
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useCalculatorStore } from '../../stores/calculator'

const calculatorStore = useCalculatorStore()

const txPower = ref(null)
const antennaGain = ref(null)
const cableLoss = ref(null)
const result = ref(null)

function calculate() {
  if (txPower.value !== null && antennaGain.value !== null && cableLoss.value !== null) {
    result.value = calculatorStore.calculateERP(
      txPower.value,
      antennaGain.value,
      cableLoss.value
    )
    calculatorStore.setLastResult('erp', result.value)
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
  }
}
</style>
