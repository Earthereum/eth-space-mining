<template>
    <v-layout row wrap>
        <v-flex xs12>
            <div class="text-xs-center">
                <h1>Admin utilities</h1>
                <div id="sign-in-button">
                    <v-btn round color="primary" dark class="white--text" @click="createPromo">
                        Create Promo Planet
                    </v-btn>
                    <v-snackbar
                            :timeout="4000"
                            color="success"
                            v-model="snackbar"
                    >
                        New planet created!
                        <v-btn dark flat @click.native="snackbar = false">Close</v-btn>
                    </v-snackbar>
                </div>
                <v-btn round color="primary" dark class="white--text" @click="createAuction">
                        Create Auction
                </v-btn>
            </div>
        </v-flex>
    </v-layout>
</template>

<script>
  // var ethUtil = require('ethereumjs-util');
  var Eth = require('ethjs');
  window.Eth = Eth;

  export default {
    name: 'admin',
    data () {
      return {
        snackbar: false
      };
    },
    methods: {
      createAuction: async function (event) {
        event.preventDefault();

        const coreInstance = await window.contracts.Core.deployed();

        const auctionResult = await coreInstance.createSaleAuction(1, 1, 1000, {from: window.web3.eth.accounts[0]});
        console.log(auctionResult);
      },
      createPromo: async function (event) {
        event.preventDefault();

        // get deployed SpaceCore instance
        const coreInstance = await window.contracts.Core.deployed();

        // create a new promo planet
        const promoResult = await coreInstance.createPromoPlanet(1, {from: window.web3.eth.accounts[0]});
        console.log(promoResult.logs);

        let planetId = 0;
        for (let i = 0; i < promoResult.logs.length; i++) {
          const log = promoResult.logs[i];

          if (log.event === 'Birth') {
            planetId = log.args.planetId;
            console.log('Planet ID: ' + log.args.planetId);
            console.log('Genes: ' + log.args.genes);
            console.log('Owner: ' + log.args.owner);
            planetId = log.args.planetId;
            break;
          }
        }

        // retrieve newly-created planet
        const getResult = await coreInstance.getPlanet.call(planetId);
        getResult.forEach((res) => {
          if (res instanceof Object) {
            console.log(res.toNumber());
          } else {
            console.log(res);
          }
          this.snackbar = true;
        });
      }
    }
  }
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
