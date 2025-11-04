import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useAppStore = defineStore('app', () => {
  const theme = ref('dark')
  const measurements = ref([])
  const reports = ref([])

  function toggleTheme() {
    theme.value = theme.value === 'dark' ? 'light' : 'dark'
  }

  function addMeasurement(data) {
    measurements.value.push({
      id: Date.now(),
      ...data,
      createdAt: new Date().toISOString()
    })
  }

  function addReport(data) {
    reports.value.push({
      id: Date.now(),
      ...data,
      createdAt: new Date().toISOString()
    })
  }

  return {
    theme,
    measurements,
    reports,
    toggleTheme,
    addMeasurement,
    addReport
  }
})
