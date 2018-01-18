import Vue from 'vue'
import Router from 'vue-router'
import Dashboard from '@/components/Dashboard'
import Market from '@/components/Market'
import MyPlanets from '@/components/MyPlanets'
import Admin from '@/components/admin/Admin'
import DirectLink from '@/components/DirectLink'
import Planet from '@/components/planet/Planet'
import About from '@/components/About'

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: '/',
      name: 'dashboard',
      component: Dashboard
    },
    {
      path: '/home',
      name: 'home',
      component: Dashboard
    },
    {
      path: '/market',
      name: 'Market',
      component: Market
    },
    {
      path: '/myplanets',
      name: 'My Planets',
      component: MyPlanets
    },
    {
      path: '/_admin',
      name: 'Admin',
      component: Admin
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
    },
    {
      path: '/about',
      name: 'About',
      component: About
    }
  ],
  mode: 'history'
})
