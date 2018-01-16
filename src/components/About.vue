<template>
  <v-layout row wrap>
    <v-flex xs12>
      <div class="text-xs-center">
        <h1>{{ title }}</h1>
        <planet-display :planet="demoPlanet"></planet-display>
      </div>
    </v-flex>
  </v-layout>
</template>


<script>
import {Planet} from 'earthereum-renderer';

export default {
  name: 'about',
  data () {
    return {
      title: 'About Earthereum',
      demoPlanet: new Planet({
        'seed': 0x42069,
        'size': 0.7,
        'water': 0.5,
        'atmoDensity': 0.5,
        'cloudDensity': 0.5,
        'baseColor': 0xa4be92,
        'accColor': 0xf5dac3,
        'numTerrains': 4
      })
    };
  }
}
</script>
