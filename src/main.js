// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import Web3 from 'web3'
import router from './router'
import { store } from './store'

import Vuetify from 'vuetify';
Vue.use(Vuetify);
import('../node_modules/vuetify/dist/vuetify.min.css');

import PlanetDisplay from 'earthereum-renderer';
Vue.component('planet-display', PlanetDisplay);

import contract from 'truffle-contract'

import CreationContract from '../build/contracts/SpaceCreation.json'
import CoreContract from '../build/contracts/SpaceCore.json'
import OwnershipContract from '../build/contracts/SpaceOwnership.json'

Vue.config.productionTip = false;

window.contracts = {};

window.addEventListener('load', function () {
  if (typeof web3 !== 'undefined') {
    console.log('Web3 injected browser: OK.');
    window.web3 = new Web3(window.web3.currentProvider)
  } else {
    console.log('Web3 injected browser: Fail. You should consider trying MetaMask.');
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    window.web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'))
  }

  //  create contracts with new truffle-contract
  window.contracts.Creation = contract(CreationContract);
  window.contracts.Core = contract(CoreContract);
  window.contracts.Ownership = contract(OwnershipContract);

  // Set the provider for our contracts
  Object.keys(window.contracts).forEach(contract => {
    console.log('Loaded ' + contract);
    window.contracts[contract].setProvider(window.web3.currentProvider);
  });

  /* eslint-disable no-new */
  new Vue({
    el: '#app',
    router,
    template: '<App/>',
    components: { App },
    store
  })
});

