<template>
        <v-layout fluid>
            <v-flex>
                <v-card color="black">
                  <v-alert v-if="error" color="error" icon="warning" value="true">
                    Couldn't get this planet from the Ethereum network.
                  </v-alert>
                    <v-card-title>
                        <v-btn v-if="planet"
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
                        <div>
                            <h1>{{ planet.title }}</h1>
                        </div>
                        <div>
                            hi there
                        </div>
                    </v-card-text>
                </v-card>
            </v-flex>
        </v-layout>
</template>

<script>
  import {Planet} from 'earthereum-renderer';
  import {processGenome} from '../util.js';
  export default {
    props: ['id'],
    data: () => {
      return {
        planet: null,
        error: false
      };
    },
    async created () {
      try {
        const data = await processGenome(this.id);
        this.planet = data;
      } catch (e) {
        this.error = true;
      }
    },
    methods: {
      createPlanet (traits) {
        return new Planet(traits);
      }
    }
  }
</script>