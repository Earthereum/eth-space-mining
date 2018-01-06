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
      path: '/github',
      name: 'GitHub',
      component: DirectLink,
      props: {url: 'https://github.com/earthereum'}
    },
    {
      path: '/planet/:id',
      name: 'Planet',
      props: true,
      component: Planet
    }
  ],
  mode: 'history'
})
