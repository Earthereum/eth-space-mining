<template>
  <v-dialog v-model="promoDialog" persistent max-width="500px">
    <v-btn round color="primary" dark class="white--text" slot="activator">
        Create Promo Planet
    </v-btn>
    <v-card>
      <v-card-title>
        <span class="headline">Create Promo Planet</span>
      </v-card-title>
      <v-card-text>
        <v-container grid-list-md>
          <v-layout wrap>
            <v-flex xs12 md6>
              <v-radio-group v-model="randomize" :mandatory="true">
                <v-radio label="Specify genome" :value="false"></v-radio>
                <v-radio label="Randomize genome" :value="true"></v-radio>
              </v-radio-group>
            </v-flex>
            <v-flex xs12>
              <v-text-field :disabled="randomize"
                label="Genome"
                v-model="promoGenome"
              ></v-text-field>
            </v-flex>
          </v-layout>
        </v-container>
      </v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn color="red" flat @click.native="promoDialog = false">Cancel</v-btn>
        <v-btn flat @click.native="createPromo">Create</v-btn>
      </v-card-actions>
    </v-card>
    <v-snackbar
            :timeout="4000"
            color="success"
            v-model="snackbar"
    >
        New planet created!
      <v-btn dark flat @click.native="snackbar = false">Close</v-btn>
    </v-snackbar>
  </v-dialog>
</template>

<script>
  export default {
    data: () => {
      return {
        promoDialog: false,
        promoGenome: null,
        randomize: true,
        snackbar: false
      }
    },
    methods: {
      createPromo: async function (event) {
        this.promoDialog = false;
        event.preventDefault();

        // get deployed SpaceCore instance
        const coreInstance = await window.contracts.Core.deployed();

        // create a new promo planet
        let promoResult;
        if (this.randomize) {
          promoResult = await coreInstance.createRandomPromoPlanet(1, {from: window.web3.eth.accounts[0]});
        } else {
          promoResult = await coreInstance.createPromoPlanet(this.promoGenome, {from: window.web3.eth.accounts[0]});
        }
        console.log(promoResult.logs);

        let planetId = 0;
        for (let i = 0; i < promoResult.logs.length; i++) {
          const log = promoResult.logs[i];

          if (log.event === 'Birth') {
            planetId = log.args.planetId;
            console.log('Planet ID: ' + log.args.planetId);
            console.log('Genes: ' + log.args.genes);
            console.log('Owner: ' + log.args.owner);
            planetId = log.args.planetId;
            break;
          }
        }

        // retrieve newly-created planet
        const getResult = await coreInstance.getPlanet.call(planetId);
        getResult.forEach((res) => {
          if (res instanceof Object) {
            console.log(res.toNumber());
          } else {
            console.log(res);
          }
          this.snackbar = true;
        });
      }
    }
  }
</script>