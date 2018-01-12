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
    data: {
      loadedPlanets: []
    },
    computed: {
      cards () {
        return this.loadedPlanets;
      }
    },
    async created () {
      const tempPlanets = [
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
        }
      ];
      this.loadedPlanets = tempPlanets;
      // use Core contract to track a user's planets
      const coreInstance = await window.contracts.Core.deployed();
      const tokens = await coreInstance.tokensOfOwner
        .call(window.web3.eth.accounts[0]);

      console.log('Tokens of Address (' +
        window.web3.eth.accounts[0] + '): ' + tokens);

      // const totalSupply = await coreInstance.totalSupply.call();
      // console.log('Total Planets: ' + totalSupply);

      const planetId = 1;
      const planetResult = await coreInstance.getPlanet.call(planetId);
      planetResult.forEach((res) => {
        if (res instanceof Object) {
          console.log(res.toString(16));
        } else {
          console.log(res);
        }
      });
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