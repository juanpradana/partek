<template>
  <div class="calculator glass-card">
    <h3>Deviasi Frekuensi FM</h3>
    <div class="calculator-form">
      <div class="input-group">
        <label>Pembacaan Delta Marker (Hz)</label>
        <p class="help-text">Masukkan setiap pembacaan, tekan Enter setelah setiap nilai</p>
        <div class="readings-input">
          <input
            v-model.number="newReading"
            type="number"
            step="0.01"
            placeholder="Masukkan pembacaan"
            @keyup.enter="addReading"
          />
          <button @click="addReading" class="btn btn-secondary">
            Tambah
          </button>
        </div>
      </div>
      <div v-if="readings.length > 0" class="readings-list">
        <div class="readings-header">
          <strong>Daftar Pembacaan:</strong>
          <button @click="clearReadings" class="btn-small">Hapus Semua</button>
        </div>
        <div class="readings-items">
          <span
            v-for="(reading, index) in readings"
            :key="index"
            class="reading-tag"
          >
            {{ reading }} Hz
            <button @click="removeReading(index)" class="remove-btn">×</button>
          </span>
        </div>
      </div>
      <div v-if="result" class="result">
        <div class="result-label">Hasil Perhitungan:</div>
        <div class="result-value">σ = {{ result.standardDeviation.toFixed(2) }} Hz</div>
        <div class="result-details">
          <div>Rata-rata: {{ result.mean.toFixed(2) }} Hz</div>
          <div>Jumlah pembacaan: {{ result.readings.length }}</div>
        </div>
      </div>
      <button
        @click="calculate"
        :disabled="readings.length < 2"
        class="btn btn-primary mt-2"
      >
        Hitung Deviasi
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useCalculatorStore } from '../../stores/calculator'

const calculatorStore = useCalculatorStore()

const newReading = ref(null)
const readings = ref([])
const result = ref(null)

function addReading() {
  if (newReading.value !== null && newReading.value !== '') {
    readings.value.push(parseFloat(newReading.value))
    newReading.value = null
  }
}

function removeReading(index) {
  readings.value.splice(index, 1)
}

function clearReadings() {
  readings.value = []
  result.value = null
}

function calculate() {
  if (readings.value.length >= 2) {
    result.value = calculatorStore.calculateFMDeviation([...readings.value])
    calculatorStore.setLastResult('fmDeviation', result.value)
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

.help-text {
  font-size: 0.85rem;
  color: var(--text-secondary);
  margin-bottom: 0.5rem;
}

.readings-input {
  display: flex;
  gap: 0.5rem;
}

.readings-input input {
  flex: 1;
}

.readings-list {
  margin-top: 1rem;
  padding: 1rem;
  background: var(--glass-bg);
  border-radius: 8px;
}

.readings-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.75rem;
}

.btn-small {
  padding: 0.25rem 0.75rem;
  font-size: 0.85rem;
  background: var(--glass-bg);
  border: 1px solid var(--border);
  border-radius: 4px;
  cursor: pointer;
}

.readings-items {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.reading-tag {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 0.75rem;
  background: var(--bg-secondary);
  border: 1px solid var(--border);
  border-radius: 6px;
  font-size: 0.9rem;
}

.remove-btn {
  background: none;
  border: none;
  color: var(--text-secondary);
  cursor: pointer;
  font-size: 1.2rem;
  line-height: 1;
  padding: 0;
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.remove-btn:hover {
  color: var(--text-primary);
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

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

@media (max-width: 768px) {
  .calculator {
    padding: 1rem;
  }
  
  .calculator h3 {
    font-size: 1.1rem;
  }
  
  .readings-input {
    flex-direction: column;
  }
  
  .readings-input .btn {
    width: 100%;
  }
  
  .readings-header {
    flex-direction: column;
    gap: 0.5rem;
    align-items: flex-start;
  }
  
  .readings-items {
    gap: 0.4rem;
  }
  
  .reading-tag {
    font-size: 0.85rem;
    padding: 0.4rem 0.6rem;
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
