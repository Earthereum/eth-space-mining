<template>
  <v-dialog v-if="isOwnPlanet" v-model="sellDialog" persistent max-width="500px">
    <v-btn slot="activator">
      <v-icon left dark>account_balance</v-icon>
      Sell
    </v-btn>
    <v-card>
      <v-card-title>
        <span class="headline">Create Auction for {{ planet.title }}</span>
      </v-card-title>
      <v-card-text>
        <v-container grid-list-md>
          <v-layout wrap>
            <v-flex xs12 sm6>
              <v-text-field
                label="Price"
                prefix="Ξ"
                v-model="sellPrice"
              ></v-text-field>
            </v-flex>
            <v-flex xs12 sm6>
              <v-text-field
                label="Duration"
                v-model="sellDuration"
              ></v-text-field>
            </v-flex>
          </v-layout>
        </v-container>
      </v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn color="red" flat @click.native="sellDialog = false">Cancel</v-btn>
        <v-btn flat @click.native="createAuction">Start</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
  import BigNumber from 'bignumber.js';

  export default {
    props: ['planet'],
    data: () => {
      return {
        isOwnPlanet: false,
        sellDialog: false,
        sellPrice: null,
        sellDuration: null
      }
    },
    async created () {
      const currentUser = window.web3.eth.accounts[0];

      try {
        // see who owns it
        const coreInstance = await window.contracts.Core.deployed();
        const ownerData = await coreInstance.ownerOf.call(this.planet.id);
        this.owner = new BigNumber(ownerData);
        this.isOwnPlanet = this.owner.equals(currentUser);
      } catch (e) {
        console.error(e);
      }
    },
    methods: {
      async createAuction () {
        const currentUser = window.web3.eth.accounts[0];
        const core = await window.contracts.Core.deployed();

        this.sellDialog = false;

        // TODO: update
        await core.createSaleAuction(
          this.planet.id,
          this.sellPrice,
          this.sellDuration,
          {from: currentUser}
        );
      }
    }
  }
</script>