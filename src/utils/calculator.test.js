import { describe, it, expect, beforeEach } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useCalculatorStore } from '../stores/calculator'

describe('Calculator Store', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('should convert units correctly', () => {
    const store = useCalculatorStore()
    const result = store.convertUnits(100, 20, 2)
    
    expect(result.dbuV).toBe(100)
    expect(result.antennaFactor).toBe(20)
    expect(result.cableLoss).toBe(2)
    expect(result.dbuVPerM).toBe(118) // 100 + 20 - 2
  })

  it('should calculate OBW using beta percent', () => {
    const store = useCalculatorStore()
    const result = store.calculateOBW(1000, null, 5)
    
    expect(result.method).toBe('beta')
    expect(result.bandwidth).toBe(50) // (1000 * 5) / 100
    expect(result.betaPercent).toBe(5)
  })

  it('should calculate OBW using delta level', () => {
    const store = useCalculatorStore()
    const result = store.calculateOBW(1000, 10)
    
    expect(result.method).toBe('delta')
    expect(result.deltaLevel).toBe(10)
    expect(result.bandwidth).toBeCloseTo(10000, 0) // 1000 * 10^(10/10) = 1000 * 10
  })

  it('should calculate ERP correctly', () => {
    const store = useCalculatorStore()
    const result = store.calculateERP(30, 15, 2)
    
    expect(result.txPower).toBe(30)
    expect(result.antennaGain).toBe(15)
    expect(result.cableLoss).toBe(2)
    expect(result.erp).toBe(43) // 30 + 15 - 2
  })

  it('should calculate AM modulation depth', () => {
    const store = useCalculatorStore()
    const result = store.calculateAMModulation(-6.02) // Approximately -6dB
    
    expect(result.esbEcDb).toBe(-6.02)
    expect(result.modulationDepth).toBeGreaterThan(0)
    expect(result.modulationDepth).toBeLessThan(100)
  })

  it('should calculate FM deviation standard deviation', () => {
    const store = useCalculatorStore()
    const readings = [100, 105, 95, 102, 98]
    const result = store.calculateFMDeviation(readings)
    
    expect(result).not.toBeNull()
    expect(result.mean).toBeCloseTo(100, 0)
    expect(result.standardDeviation).toBeGreaterThan(0)
    expect(result.readings.length).toBe(5)
  })

  it('should return null for FM deviation with empty readings', () => {
    const store = useCalculatorStore()
    const result = store.calculateFMDeviation([])
    
    expect(result).toBeNull()
  })
})
