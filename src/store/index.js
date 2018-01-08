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
      },
      {
        title: 'Alien Planet',
        traits: {
          'seed': 690625557,
          'size': 0.6387981782007165,
          'water': 0.035676267556373986,
          'atmoDensity': 0.4855952513528312,
          'cloudDensity': 0.30143945808636746,
          'baseColor': 'rgb(75,56,83)',
          'accColor': 'rgb(205,64,87)',
          'numTerrains': 4
        },
        price: 0.820,
        link: '/planet/4',
        id: 4
      },
      {
        title: 'Ocean World',
        traits: {
          'seed': 3342873783,
          'size': 0.8325148179508891,
          'water': 0.7674851820491109,
          'atmoDensity': 0.377307366638442,
          'cloudDensity': 0.47485182049110924,
          'baseColor': 'rgb(155,76,103)',
          'accColor': 'rgb(182,57,46)',
          'numTerrains': 4
        },
        price: 0.421,
        link: '/planet/5',
        id: 5
      },
      {
        title: 'Carbon Planet',
        traits: {
          'seed': 3542924439,
          'size': 0.5275448695576838,
          'water': 0.36646909398814564,
          'atmoDensity': 0.327774417479894,
          'cloudDensity': 0.632098950642872,
          'baseColor': 'rgb(88,90,88)',
          'accColor': 'rgb(25,21,21)',
          'numTerrains': 4
        },
        price: 0.0591,
        link: '/planet/6',
        id: 6
      }
    ],
    user: {
      id: 'admin',
      registeredPlanets: ['p1']
    }
  },
  mutations: {
    changeName (state, data) {
      let planetId = data.planetId;
      let name = data.name;
      let planet = state.loadedPlanets[planetId - 1];
      console.log('Planet: ' + planet);
      console.log('Old name: ' + planet.title);
      console.log('Change name to : ' + name);
      planet.title = name;
      console.log('New name: ' + planet.title);
    }
  },
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
