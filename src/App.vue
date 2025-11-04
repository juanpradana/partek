<template>
  <div id="app" :class="theme">
    <router-view />
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useAppStore } from './stores/app'

const appStore = useAppStore()
const theme = computed(() => appStore.theme)
</script>

<style>
#app {
  min-height: 100vh;
  transition: background-color 0.3s ease;
}
</style>
