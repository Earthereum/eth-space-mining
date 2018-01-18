<template>
    <v-layout row wrap>
        <v-flex xs12>
            <div class="text-xs-center">
                <h1>Admin utilities</h1>
                <v-container>
                  <v-flex xs12>
                    <create-promo-button></create-promo-button>
                  </v-flex>
                  <v-flex xs12>
                    <v-btn round color="primary" dark class="white--text" @click="createAuction">
                      Create Auction
                    </v-btn>
                  </v-flex>
                </v-container>
            </div>
        </v-flex>
    </v-layout>
</template>

<script>
  import CreatePromoButton from '@/components/admin/CreatePromoButton';

  var Eth = require('ethjs');
  window.Eth = Eth;

  export default {
    name: 'admin',
    data () {
      return {
        snackbar: false
      };
    },
    methods: {
      createAuction: async function (event) {
        event.preventDefault();

        const coreInstance = await window.contracts.Core.deployed();

        const auctionResult = await coreInstance.createSaleAuction(1, 1, 1000, {from: window.web3.eth.accounts[0]});
        console.log(auctionResult);
      }
    },
    components: {'create-promo-button': CreatePromoButton}
  }
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
