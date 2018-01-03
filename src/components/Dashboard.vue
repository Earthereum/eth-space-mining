<template>
  <v-layout row wrap>
    <v-flex xs12>
      <h1>{{ msg }}</h1>
      <div v-if="userExists">
        Welcome {{ pseudo }}. Destroy your account by clicking <a href="#" @click="destroyAccount">here</a>.
      </div>
      <div id="sign-in-button">
        <v-btn color="primary" v-on:click="ethSignIn">Sign In with Ethereum</v-btn>
      </div>
    </v-flex>
  </v-layout>
</template>

<script>
import Users from '@/js/users';
var ethUtil = require('ethereumjs-util');
var Eth = require('ethjs');
window.Eth = Eth;

export default {
  name: 'dashboard',
  data () {
    return {
      msg: 'Welcome to your truffle-vue dApp',
      pseudo: undefined
    };
  },
  computed: {
    userExists: function () {
      return (typeof this.pseudo !== 'undefined')
    }
  },
  beforeCreate: function () {
    Users.init().then(() => {
      Users.exists(window.web3.eth.accounts[0]).then((exists) => {
        if (exists) {
          Users.authenticate().then(pseudo => {
            this.pseudo = pseudo;
          });
        }
      })
    }).catch(err => {
      console.log(err);
    })
  },
  methods: {
    destroyAccount: function (e) {
      e.preventDefault();
      Users.destroy().then(() => {
        this.pseudo = undefined;
      }).catch(err => {
        console.log(err);
      });
    },
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
          this.$router.push({path: 'signup'});
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
