<template>
  <v-layout row wrap>
    <v-flex xs12>
      <div class="text-xs-center">
        <img src="../assets/logo.png">
        <h1>{{ msg }}</h1>
        <div id="sign-in-button">
          <v-btn color="primary" v-on:click="ethSignIn">Sign In</v-btn>
        </div>
      </div>
    </v-flex>
  </v-layout>
</template>

<script>
var ethUtil = require('ethereumjs-util');
var Eth = require('ethjs');
window.Eth = Eth;

export default {
  name: 'dashboard',
  data () {
    return {
      msg: 'Welcome to Earthereum',
      pseudo: undefined
    };
  },
  computed: {
    userExists: function () {
      return (typeof this.pseudo !== 'undefined')
    }
  },
  methods: {
    ethSignIn: function (event) {
      event.preventDefault();
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
