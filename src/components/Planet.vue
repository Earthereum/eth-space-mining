<template>
        <v-layout fluid>
            <v-flex>
                <v-card color="black">
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
                    <v-card-media contain height="400px" >
                      <planet-display v-if="planet" :planet="createPlanet(planet.traits)"></planet-display>
                      <v-layout v-else row justify-space-around>
                        <v-progress-circular indeterminate :size="70" color="white"></v-progress-circular>
                      </v-layout>
                    </v-card-media>
                </v-card>
                <v-card>
                    <v-card-text>
                        <div>
                            <h1 v-if="planet">{{ planet.title }}</h1>
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
  export default {
    props: ['id'],
    data: () => {
      return {
        planet: null
      };
    },
    async created () {
      const coreInstance = await window.contracts.Core.deployed();
      const planetResult = await coreInstance.getPlanet.call(this.id);
      const genome = planetResult[5];
      console.log(genome.toString(16))
    },
    methods: {
      createPlanet (traits) {
        return new Planet(traits);
      }
    }
  }
</script>