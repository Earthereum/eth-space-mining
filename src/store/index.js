import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex);

export const store = new Vuex.Store({
  state: {
    loadedPlanets: [
      {
        title: 'Purple Planet',
        src: 'https://files.slack.com/files-pri/T8KQ18934-F8N5VE9NJ/atmotest_1.png',
        flex: 6,
        price: 0.034,
        link: '/planet/1',
        id: 1
      },
      {
        title: 'Brown Planet',
        src: 'https://files.slack.com/files-pri/T8KQ18934-F8N5VER9C/atmotest_5.png',
        flex: 6,
        price: 0.568,
        link: '/planet/2',
        id: 2
      },
      {
        title: 'Blue Planet',
        src: 'https://files.slack.com/files-pri/T8KQ18934-F8NBU28AK/atmotest_4.png',
        flex: 6,
        price: 1.244,
        link: '/planet/3',
        id: 3
      }
    ],
    user: {
      id: 'admin',
      registeredPlanets: ['p1']
    }
  },
  mutations: {},
  actions: {},
  getters: {
    loadedPlanets (state) {
      return state.loadedPlanets.sort((planetA, planetB) => {
        return planetA.id > planetB.id;
      })
    },
    loadedPlanet (state) {
      return (planetId) => {
        return state.loadedPlanets.find((planet) => {
          return planet.id === planetId;
        })
      }
    }
  }
})
