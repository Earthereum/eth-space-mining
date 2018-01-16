<template>
        <v-layout fluid>
            <v-flex>
                <v-card color="black">
                  <v-alert v-if="error" color="error" icon="warning" value="true">
                    Couldn't get this planet from the Ethereum network.
                  </v-alert>
                    <v-card-title>
                        <h1 class="white--text" v-if="planet">{{ planet.title }}</h1>
                        <v-spacer></v-spacer>
                    </v-card-title>
                    <v-card-media contain height="400px">
                      <v-slide-y-transition>
                        <planet-display v-if="planet" :planet="createPlanet(planet.traits)"></planet-display>
                      </v-slide-y-transition>
                      <v-layout v-if="!planet && !error" row justify-space-around>
                        <v-progress-circular indeterminate :size="70" color="white"></v-progress-circular>
                      </v-layout>
                    </v-card-media>
                </v-card>
                <v-card>
                    <v-card-text v-if="planet">
                      <v-container>
                        <v-flex xs12 class="mb-3">
                          <v-btn icon color="primary">
                              <v-icon>share</v-icon>
                          </v-btn>
                          <v-btn v-if="forSale">
                              <v-icon left dark>account_balance</v-icon>
                              Buy Ξ{{ planet.price }}
                          </v-btn>
                          <v-dialog v-if="isOwnPlanet" v-model="sellDialog" persistent max-width="500px">
                            <v-btn slot="activator">
                              <v-icon left dark>account_balance</v-icon>
                              Sell
                            </v-btn>
                            <v-card>
                              <v-card-title>
                                <span class="headline">Create Auction</span>
                              </v-card-title>
                              <v-card-text>
                                <v-container grid-list-md>
                                  <v-layout wrap>
                                    <v-flex xs12 sm6>
                                      <v-text-field
                                        label="Price"
                                        prefix="Ξ"
                                        v-model="sellPrice"
                                      ></v-text-field>
                                    </v-flex>
                                    <v-flex xs12 sm6>
                                      <v-text-field
                                        label="Duration"
                                        v-model="sellDuration"
                                      ></v-text-field>
                                    </v-flex>
                                  </v-layout>
                                </v-container>
                              </v-card-text>
                              <v-card-actions>
                                <v-spacer></v-spacer>
                                <v-btn color="red" flat @click.native="sellDialog = false">Cancel</v-btn>
                                <v-btn flat @click.native="createAuction">Start</v-btn>
                              </v-card-actions>
                            </v-card>
                          </v-dialog>
                        </v-flex>
                        <v-flex xs12>
                          <h2>About {{ planet.title }}</h2>
                          <p v-if="owner">
                            Owner: 0x{{ owner.toString(16) }}
                          </p>
                          <p>
                            Description: I'm a planet! Globular, floating in space, spherical on average.
                          </p>
                        </v-flex>
                      </v-container>
                    </v-card-text>
                </v-card>
            </v-flex>
        </v-layout>
</template>

<script>
  import BigNumber from 'bignumber.js';
  import {Planet} from 'earthereum-renderer';
  import {processGenome} from '../util.js';
  export default {
    props: ['id'],
    data: () => {
      return {
        planet: null,
        owner: null,
        isOwnPlanet: false,
        forSale: false,
        sellDialog: false,
        sellPrice: null,
        sellDuration: null,
        error: false
      };
    },
    async created () {
      const currentUser = window.web3.eth.accounts[0];

      try {
        // lookup this planet
        const data = await processGenome(this.id);
        this.planet = data;

        // see who owns it
        const coreInstance = await window.contracts.Core.deployed();
        const ownerData = await coreInstance.ownerOf.call(this.id);
        this.owner = new BigNumber(ownerData);
        this.isOwnPlanet = this.owner.equals(currentUser);
      } catch (e) {
        console.error(e);
        this.error = true;
      }
    },
    methods: {
      createPlanet (traits) {
        return new Planet(traits);
      },

      async createAuction () {
        const currentUser = window.web3.eth.accounts[0];
        const core = await window.contracts.Core.deployed();

        this.sellDialog = false;

        // TODO: update
        await core.createSaleAuction(
          this.id,
          this.sellPrice,
          this.sellPrice,
          this.sellDuration,
          {from: currentUser}
        );
      }
    }
  }
</script>