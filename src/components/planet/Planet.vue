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
                          <auction-button :planet="planet"></auction-button>
                        </v-flex>
                        <v-flex xs12>
                          <h2>About {{ planet.title }}</h2>
                          <p v-if="owner">
                            Owner: 0x{{ owner.toString(16) }}
                          </p>
                          <p>
                            Description: Hiya There! I'm {{ planet.title }}!
                          </p>
                        </v-flex>
                      </v-container>
                    </v-card-text>
                </v-card>
            </v-flex>
        </v-layout>
</template>

<script>
  import AuctionButton from '@/components/planet/AuctionButton';
  import {Planet} from 'earthereum-renderer';
  import {processGenome} from '@/util.js';
  export default {
    props: ['id'],
    data: () => {
      return {
        planet: null,
        owner: null,
        forSale: false,
        error: false
      };
    },
    async created () {
      try {
        // lookup this planet
        const data = await processGenome(this.id);
        this.planet = data;
      } catch (e) {
        console.error(e);
        this.error = true;
      }
    },
    methods: {
      createPlanet (traits) {
        return new Planet(traits);
      }
    },
    components: {'auction-button': AuctionButton}
  }
</script>