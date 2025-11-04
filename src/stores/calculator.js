import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useCalculatorStore = defineStore('calculator', () => {
  const lastResults = ref({
    unitConversion: null,
    occupiedBandwidth: null,
    erp: null,
    amModulation: null,
    fmDeviation: null,
    frequencyPower: null,
    harmonics: null
  })

  // Konversi dBµV <=> dBµV/m
  function convertUnits(dbuV, antennaFactor, cableLoss) {
    const dbuVPerM = dbuV + antennaFactor - cableLoss
    return {
      dbuV,
      dbuVPerM,
      antennaFactor,
      cableLoss
    }
  }

  // Lebar Pita Terpakai (Occupied Bandwidth)
  function calculateOBW(power, deltaLevel, betaPercent = null) {
    if (betaPercent !== null) {
      // Hitung dari β%
      const bandwidth = (power * betaPercent) / 100
      return {
        bandwidth,
        betaPercent,
        method: 'beta'
      }
    } else {
      // Hitung dari x-dB (delta level)
      const bandwidth = power * Math.pow(10, deltaLevel / 10)
      return {
        bandwidth,
        deltaLevel,
        method: 'delta'
      }
    }
  }

  // Effective Radiated Power (ERP)
  function calculateERP(txPower, antennaGain, cableLoss) {
    const erp = txPower + antennaGain - cableLoss
    return {
      erp,
      txPower,
      antennaGain,
      cableLoss
    }
  }

  // Kedalaman Modulasi AM
  function calculateAMModulation(esbEcDb) {
    // Konversi dari dB ke linier
    const ratio = Math.pow(10, esbEcDb / 20)
    const modulationDepth = (ratio / (1 + ratio)) * 100
    return {
      modulationDepth,
      esbEcDb,
      ratio
    }
  }

  // Deviasi Frekuensi FM
  function calculateFMDeviation(deltaMarkerReadings) {
    if (!deltaMarkerReadings || deltaMarkerReadings.length < 2) {
      return null
    }

    // Hitung rata-rata
    const mean = deltaMarkerReadings.reduce((a, b) => a + b, 0) / deltaMarkerReadings.length

    // Hitung standard deviasi
    const variance = deltaMarkerReadings.reduce((sum, reading) => {
      return sum + Math.pow(reading - mean, 2)
    }, 0) / deltaMarkerReadings.length

    const standardDeviation = Math.sqrt(variance)

    return {
      mean,
      standardDeviation,
      readings: deltaMarkerReadings
    }
  }

  // Frekuensi dan Level Power
  function calculateFrequencyPower(frequency, powerLevel) {
    return {
      frequency,
      powerLevel,
      powerInDbW: powerLevel - 30,
      powerInMW: Math.pow(10, powerLevel / 10),
      powerInW: Math.pow(10, powerLevel / 10) / 1000
    }
  }

  // Pengukuran Harmonisa
  function calculateHarmonics(fundamentalFrequency, fundamentalPower, harmonic1, harmonic2, harmonic3) {
    const result = {
      fundamentalFrequency,
      fundamentalPower,
      harmonic1: null,
      harmonic2: null,
      harmonic3: null
    }

    // Harmonisa 1 (2nd harmonic)
    if (harmonic1 && harmonic1.frequency !== null && harmonic1.power !== null) {
      result.harmonic1 = {
        frequency: harmonic1.frequency,
        power: harmonic1.power,
        difference: fundamentalPower - harmonic1.power,
        order: 2
      }
    }

    // Harmonisa 2 (3rd harmonic)
    if (harmonic2 && harmonic2.frequency !== null && harmonic2.power !== null) {
      result.harmonic2 = {
        frequency: harmonic2.frequency,
        power: harmonic2.power,
        difference: fundamentalPower - harmonic2.power,
        order: 3
      }
    }

    // Harmonisa 3 (4th harmonic)
    if (harmonic3 && harmonic3.frequency !== null && harmonic3.power !== null) {
      result.harmonic3 = {
        frequency: harmonic3.frequency,
        power: harmonic3.power,
        difference: fundamentalPower - harmonic3.power,
        order: 4
      }
    }

    return result
  }

  function setLastResult(type, result) {
    lastResults.value[type] = result
  }

  return {
    lastResults,
    convertUnits,
    calculateOBW,
    calculateERP,
    calculateAMModulation,
    calculateFMDeviation,
    calculateFrequencyPower,
    calculateHarmonics,
    setLastResult
  }
})
