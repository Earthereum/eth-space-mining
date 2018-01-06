import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex);

export const store = new Vuex.Store({
  state: {
    loadedPlanets: [
      {
        title: 'Purple Planet',
        traits: {
          'seed': 4269992807,
          'size': 0.648264182895851,
          'water': 0.6049110922946656,
          'atmoDensity': 0.20389500423370024,
          'cloudDensity': 0.5450295176244095,
          'baseColor': 'rgb(167,169,124)',
          'accColor': 'rgb(138,203,177)',
          'numTerrains': 7
        },
        price: 0.034,
        link: '/planet/1',
        id: 1
      },
      {
        title: 'Brown Planet',
        traits: {
          'seed': 20377726,
          'size': 0.686930208341419,
          'water': 0.6374259102455546,
          'atmoDensity': 0.3895655449709434,
          'cloudDensity': 0.5928986110663819,
          'baseColor': 'rgb(235,137,213)',
          'accColor': 'rgb(61,81,113)',
          'numTerrains': 5
        },
        price: 0.568,
        link: '/planet/2',
        id: 2
      },
      {
        title: 'Blue Planet',
        traits: {
          'seed': 0x42069,
          'size': 0.7,
          'water': 0.5,
          'atmoDensity': 0.5,
          'cloudDensity': 0.5,
          'baseColor': 0xa4be92,
          'accColor': 0xf5dac3,
          'numTerrains': 4
        },
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
