import { createRouter, createWebHistory } from 'vue-router'
import Dashboard from '../views/Dashboard.vue'
import Wizard from '../views/Wizard.vue'
import Calculators from '../views/Calculators.vue'
import PDFViewer from '../views/PDFViewer.vue'

const routes = [
  {
    path: '/',
    name: 'Dashboard',
    component: Dashboard
  },
  {
    path: '/wizard',
    name: 'Wizard',
    component: Wizard
  },
  {
    path: '/calculators',
    name: 'Calculators',
    component: Calculators
  },
  {
    path: '/sop',
    name: 'PDFViewer',
    component: PDFViewer
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
