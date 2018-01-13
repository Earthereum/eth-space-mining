<template>
  <v-layout row wrap>
    <v-flex xs12>
      <div class="text-xs-center">
        <planet-display :planet="demoPlanet"></planet-display>
        <h1>{{ msg }}</h1>
        <div id="sign-in-button">
          <v-btn color="primary" v-on:click="ethSignIn" v-if="user == null">Sign In</v-btn>
          <v-btn color="primary" @click.native="snackbar1=true" v-on:click="ethSignIn" v-else>Sign Out</v-btn>
          <v-snackbar
            :timeout="4000"
            v-model="snackbar1"
            >
            User has been logged out.
            <v-btn dark flat @click.native="snackbar1 = false">Close</v-btn>
          </v-snackbar>
          <v-snackbar
            :timeout="4000"
            v-model="snackbar_undefined"
            color="error"
            >
            User not found. Are you signed into Metamask?
            <v-btn dark flat @click.native="snackbar_undefined = false">Close</v-btn>
          </v-snackbar>
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
      snackbar1: false,
      snackbar_undefined: false,
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
    async ethSignIn (event) {
      event.preventDefault();
      if (this.user !== null) {
        console.log('Logging user out.');
        console.log(this.user);
        this.$store.dispatch('addUser', null);
        console.log(this.user);
        console.log('User has been logged out.');
        return;
      }

      const text = 'Earthereum';
      const msg = ethUtil.bufferToHex(new Buffer(text, 'utf8'));
      const from = window.web3.eth.accounts[0];

      if (from === undefined) {
        this.snackbar_undefined = true;
        return;
      }

      console.log('CLICKED, SENDING PERSONAL SIGN REQ');

      // Use Eth.js
      const eth = new Eth(window.web3.currentProvider);

      const signed = await eth.personal_sign(msg, from);
      console.log('Signed!  Result is: ', signed);
      console.log('Recovering...');

      const recovered = await eth.personal_ecRecover(msg, signed);
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
