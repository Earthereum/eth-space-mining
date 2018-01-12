<template>
  <v-layout row wrap>
    <v-flex xs12>
      <div class="text-xs-center">
        <planet-display :planet="demoPlanet"></planet-display>
        <h1>{{ msg }}</h1>
        <div id="sign-in-button">
          <v-btn color="primary" v-on:click="ethSignIn" v-if="user == null">Sign In</v-btn>
          <v-btn color="primary" v-on:click="ethSignIn" v-else>Sign Out</v-btn>
        </div>
      </div>
    </v-flex>
  </v-layout>
</template>

<script>
import {Planet} from 'earthereum-renderer';
var ethUtil = require('ethereumjs-util');
var Eth = require('ethjs');
window.Eth = Eth;

export default {
  name: 'dashboard',
  data () {
    return {
      msg: 'Welcome to Earthereum',
      pseudo: undefined,
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
  },
  computed: {
    user () {
      return this.$store.getters.user;
    }
  },
  methods: {
    ethSignIn: function (event) {
      event.preventDefault();
      if (this.user !== null) {
        console.log('Logging user out.');
        console.log(this.user);
        this.$store.dispatch('addUser', null);
        console.log(this.user);
        console.log('User has been logged out.');
        return;
      }
      var text = 'Earthereum';
      var msg = ethUtil.bufferToHex(new Buffer(text, 'utf8'));
      var from = window.web3.eth.accounts[0];

      console.log('CLICKED, SENDING PERSONAL SIGN REQ');

      // Use Eth.js
      var eth = new Eth(window.web3.currentProvider);

      eth.personal_sign(msg, from)
      .then((signed) => {
        console.log('Signed!  Result is: ', signed);
        console.log('Recovering...');

        return eth.personal_ecRecover(msg, signed);
      })
      .then((recovered) => {
        if (recovered === from) {
          console.log('Ethjs recovered the message signer!');
          this.$store.dispatch('addUser', {address: from, loggedIn: true});
          console.log('Logged in:')
          console.log(this.user);
          this.$router.push({path: 'market'});
        } else {
          console.log('Ethjs failed to recover the message signer!');
          console.dir({ recovered });
        }
      });
    }
  }
}

</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1, h2 {
  font-weight: normal;
  display: block;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  display: inline-block;
  margin: 0 10px;
}

a {
  color: #42b983;
}
</style>
