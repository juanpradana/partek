<template>
  <div class="layout">
    <nav class="navbar glass-card">
      <div class="nav-content">
        <div class="nav-brand">
          <h1>📡 Partek Assistant</h1>
        </div>
        <button @click="toggleMobileMenu" class="mobile-menu-toggle" aria-label="Toggle menu">
          <span class="hamburger-line" :class="{ active: isMobileMenuOpen }"></span>
          <span class="hamburger-line" :class="{ active: isMobileMenuOpen }"></span>
          <span class="hamburger-line" :class="{ active: isMobileMenuOpen }"></span>
        </button>
        <div class="nav-right">
          <div class="nav-links" :class="{ 'mobile-open': isMobileMenuOpen }">
            <router-link to="/" class="nav-link" @click="closeMobileMenu">Dashboard</router-link>
            <router-link to="/wizard" class="nav-link" @click="closeMobileMenu">Wizard</router-link>
            <router-link to="/calculators" class="nav-link" @click="closeMobileMenu">Kalkulator</router-link>
            <router-link to="/sop" class="nav-link" @click="closeMobileMenu">SOP 92/2021</router-link>
          </div>
          <button @click="toggleTheme" class="theme-toggle">
            {{ theme === 'dark' ? '☀️' : '🌙' }}
          </button>
        </div>
      </div>
    </nav>
    <main class="main-content">
      <slot />
    </main>
    <footer class="footer glass-card">
      <div class="footer-content">
        <p>&copy; 2025 Farzani RBA. All rights reserved.</p>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useAppStore } from '../stores/app'

const appStore = useAppStore()
const theme = computed(() => appStore.theme)
const isMobileMenuOpen = ref(false)

function toggleTheme() {
  appStore.toggleTheme()
}

function toggleMobileMenu() {
  isMobileMenuOpen.value = !isMobileMenuOpen.value
}

function closeMobileMenu() {
  isMobileMenuOpen.value = false
}
</script>

<style scoped>
.layout {
  min-height: 100vh;
}

.navbar {
  position: sticky;
  top: 0;
  z-index: 100;
  margin-bottom: 2rem;
  border-radius: 0 0 16px 16px;
}

.nav-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 2rem;
  position: relative;
}

.nav-brand {
  flex: 1;
}

.nav-brand h1 {
  font-size: 1.5rem;
  font-weight: 700;
  background: linear-gradient(135deg, var(--accent) 0%, #667eea 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  white-space: nowrap;
}

.nav-right {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.nav-links {
  display: flex;
  gap: 1.5rem;
  align-items: center;
}

.nav-link {
  color: var(--text-primary);
  text-decoration: none;
  font-weight: 500;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  transition: all 0.3s ease;
  white-space: nowrap;
}

.nav-link:hover {
  background: var(--glass-bg);
}

.nav-link.router-link-active {
  background: linear-gradient(135deg, var(--accent) 0%, #667eea 100%);
  color: white;
}

.theme-toggle {
  background: var(--glass-bg);
  border: 1px solid var(--glass-border);
  border-radius: 50%;
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 1.2rem;
  transition: all 0.3s ease;
  flex-shrink: 0;
}

.theme-toggle:hover {
  transform: scale(1.1);
  background: var(--glass-border);
}

.mobile-menu-toggle {
  display: none;
  flex-direction: column;
  justify-content: space-around;
  width: 30px;
  height: 30px;
  background: transparent;
  border: none;
  cursor: pointer;
  padding: 0;
  z-index: 10;
}

.hamburger-line {
  width: 100%;
  height: 3px;
  background: var(--text-primary);
  border-radius: 2px;
  transition: all 0.3s ease;
  transform-origin: center;
}

.hamburger-line.active:nth-child(1) {
  transform: rotate(45deg) translate(8px, 8px);
}

.hamburger-line.active:nth-child(2) {
  opacity: 0;
}

.hamburger-line.active:nth-child(3) {
  transform: rotate(-45deg) translate(7px, -7px);
}

.main-content {
  padding-bottom: 2rem;
  min-height: calc(100vh - 200px);
}

.footer {
  margin-top: 3rem;
  border-radius: 16px 16px 0 0;
  text-align: center;
  padding: 1.5rem;
}

.footer-content {
  color: var(--text-secondary);
  font-size: 0.9rem;
}

.footer-content p {
  margin: 0;
}

@media (max-width: 768px) {
  .nav-content {
    gap: 0.75rem;
  }

  .nav-brand {
    flex: 1;
    min-width: 0;
  }

  .nav-brand h1 {
    font-size: 1.1rem;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .mobile-menu-toggle {
    display: flex;
    margin-left: auto;
    margin-right: 0.5rem;
  }

  .nav-right {
    gap: 0.5rem;
  }

  .nav-links {
    position: absolute;
    top: calc(100% + 1rem);
    left: 0;
    right: 0;
    flex-direction: column;
    background: var(--bg-secondary);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border: 1px solid var(--border);
    border-radius: 12px;
    padding: 0.75rem;
    gap: 0.5rem;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
    opacity: 0;
    visibility: hidden;
    transform: translateY(-10px);
    transition: all 0.3s ease;
    z-index: 1000;
  }

  /* Dark theme override for better contrast */
  .dark .nav-links {
    background: rgba(26, 26, 46, 0.95);
    border-color: rgba(255, 255, 255, 0.2);
  }

  /* Light theme override for better contrast */
  .light .nav-links {
    background: rgba(255, 255, 255, 0.95);
    border-color: rgba(0, 0, 0, 0.15);
  }

  .nav-links.mobile-open {
    opacity: 1;
    visibility: visible;
    transform: translateY(0);
  }

  .nav-link {
    width: 100%;
    padding: 0.85rem 1rem;
    text-align: center;
    font-size: 0.95rem;
    font-weight: 500;
    border-radius: 8px;
    color: var(--text-primary);
    background: transparent;
    transition: all 0.3s ease;
    display: block;
    text-decoration: none;
  }

  .dark .nav-link {
    color: #e2e8f0;
  }

  .light .nav-link {
    color: #1a1a2e;
  }

  .nav-link:hover {
    background: var(--glass-bg);
    color: var(--text-primary);
  }

  .dark .nav-link:hover {
    background: rgba(255, 255, 255, 0.1);
    color: #ffffff;
  }

  .light .nav-link:hover {
    background: rgba(0, 0, 0, 0.05);
    color: #1a1a2e;
  }

  .nav-link.router-link-active {
    background: linear-gradient(135deg, var(--accent) 0%, #667eea 100%);
    color: white !important;
    font-weight: 600;
  }

  .theme-toggle {
    width: 36px;
    height: 36px;
    font-size: 1rem;
    flex-shrink: 0;
  }

  .footer {
    margin-top: 2rem;
    padding: 1rem;
  }

  .footer-content {
    font-size: 0.85rem;
  }

  .main-content {
    min-height: calc(100vh - 150px);
  }
}

@media (max-width: 480px) {
  .nav-brand h1 {
    font-size: 0.95rem;
  }

  .mobile-menu-toggle {
    width: 28px;
    height: 28px;
  }

  .hamburger-line {
    height: 2.5px;
  }

  .nav-link {
    font-size: 0.9rem;
    padding: 0.65rem 0.85rem;
  }

  .theme-toggle {
    width: 32px;
    height: 32px;
    font-size: 0.9rem;
  }
}
</style>



