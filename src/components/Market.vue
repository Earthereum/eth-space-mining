<template>
    <v-layout column>
        <v-flex>
            <v-container fluid grid-list-md class="grey lighten-4">
                <v-layout row wrap>
                    <v-flex
                            xs3
                            v-for="card in cards"
                            :key="card.title"
                            style="cursor: pointer"
                    >
                        <v-card tile ripple raised>
                            <v-card-media
                                    height="300px"
                            >
                                <v-container fill-height fluid v-on:click="onLoadPlanet(card.id)">
                                    <v-layout fill-height>
                                        <v-flex xs12 align-end flexbox>
                                            <planet-display paused :planet="createPlanet(card.traits)"></planet-display>
                                        </v-flex>
                                    </v-layout>
                                </v-container>
                            </v-card-media>
                            <v-card-title>
                                <strong>{{ card.title }}</strong>
                            </v-card-title>
                            <v-card-actions class="white">
                                <v-spacer></v-spacer>
                                <v-btn icon>
                                    <v-icon>favorite</v-icon>
                                </v-btn>
                                <v-btn icon>
                                    <v-icon>bookmark</v-icon>
                                </v-btn>
                                <v-btn icon>
                                    <v-icon>share</v-icon>
                                </v-btn>
                            </v-card-actions>
                        </v-card>
                    </v-flex>
                </v-layout>
            </v-container>
        </v-flex>
    </v-layout>

</template>

<script>
  import {Planet} from 'earthereum-renderer';
  export default {
    computed: {
      cards () {
        return this.$store.getters.loadedPlanets
      }
    },
    created () {
      this.$store.dispatch('fetchMarketPlanets', {self: this});
    },
    methods: {
      onLoadPlanet (id) {
        this.$router.push('/planet/' + id)
      },
      createPlanet (traits) {
        return new Planet(traits);
      }
    }
  }
</script>