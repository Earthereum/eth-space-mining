import Vue from 'vue'
import Router from 'vue-router'
import Dashboard from '@/components/Dashboard'
import Signup from '@/components/Signup'
import Market from '@/components/Market/Market'
import DirectLink from '@/components/DirectLink'
import Planet from '@/components/Market/Planet'

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: '/',
      name: 'dashboard',
      component: Dashboard
    },
    {
      path: '/signup',
      name: 'signup',
      component: Signup
    },
    {
      path: '/market',
      name: 'Market',
      component: Market
    },
    {
      path: '/market/:id',
      name: 'Planet',
      component: Planet
    },
    {
      path: '/logan',
      name: 'Logan',
      component: DirectLink
    }
  ],
  mode: 'history'
})
