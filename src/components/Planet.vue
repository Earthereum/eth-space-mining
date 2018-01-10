<template>
        <v-layout fluid>
            <v-flex>
                <v-card color="black">
                    <v-card-title>
                        <v-btn
                                round
                                color="primary"
                                dark
                                class="white--text"
                        >
                            <v-icon left dark>account_balance</v-icon>
                            For Sale Ξ {{ planet.price }}
                        </v-btn>
                        <v-spacer></v-spacer>
                        <v-btn icon color="primary">
                            <v-icon>share</v-icon>
                        </v-btn>
                    </v-card-title>
                    <v-card-media contain height="400px">
                      <planet-display :planet="createPlanet(planet.traits)"></planet-display>
                    </v-card-media>
                </v-card>
                <v-card>
                    <v-card-text>
                        <div>
                            <h1>{{ planet.title }}</h1>
                        </div>
                        <div>
                            hi there
                        </div>
                        <v-btn round
                                color="primary"
                                dark
                                class="white--text"
                                v-on:click="createPromo"
                        >
                            Create Promo Planet
                        </v-btn>
                    </v-card-text>
                </v-card>
            </v-flex>
        </v-layout>
</template>

<script>
  import {Planet} from 'earthereum-renderer';
  export default {
    props: ['id'],
    computed: {
      planet () {
        return this.$store.getters.loadedPlanet(parseInt(this.id))
      }
    },
    methods: {
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
        });
      },
      createPlanet (traits) {
        return new Planet(traits);
      }
    }
  }
</script>