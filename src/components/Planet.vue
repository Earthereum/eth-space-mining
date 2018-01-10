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
      createPlanet (traits) {
        return new Planet(traits);
      }
    }
  }
</script>