<template>
        <v-layout fluid>
            <v-flex>
                <v-card color="black">
                    <v-card-title>
                        <v-btn
                                round
                                color="primary"
                                dark
                                class="white--text"
                        >
                            <v-icon left dark>account_balance</v-icon>
                            For Sale Ξ {{ planet.price }}
                        </v-btn>
                        <v-spacer></v-spacer>
                        <v-btn icon color="primary">
                            <v-icon>share</v-icon>
                        </v-btn>
                    </v-card-title>
                    <v-card-media contain height="400px">
                      <planet-display :planet="createPlanet(planet.traits)"></planet-display>
                    </v-card-media>
                </v-card>
                <v-card>
                    <v-card-text>
                        <div>
                            <h1>{{ planet.title }}</h1>
                        </div>
                        <div>
                            hi there
                        </div>
                        <v-btn round
                                color="primary"
                                dark
                                class="white--text"
                                v-on:click="createPromo"
                        >
                            Create Promo Planet
                        </v-btn>
                        <v-btn round
                                color="primary"
                                dark
                                class="white--text"
                                v-on:click="changeName(name-text)"
                        >
                            Change Name
                        </v-btn>
                        <v-text-field
                                      name="name-text"
                                      label="New Name"
                                      value=""
                                      class="input-group--focused"
                                    ></v-text-field>
                        <!--ol>
                            <li v-for="planet in planets">
                                {{ planet.text }}
                            </li>
                        </ol>-->
                    </v-card-text>
                </v-card>
            </v-flex>
        </v-layout>
</template>

<script>
  import {Planet} from 'earthereum-renderer';
  import { mapMutations } from 'vuex';
  export default {
    props: ['id'],
    computed: {
      planet () {
        return this.$store.getters.loadedPlanet(parseInt(this.id))
      }
    },
    methods: {
      createPromo: function (event) {
        event.preventDefault();

        var creationInstance, coreInstance;
        var planetId;

        window.contracts.Creation.deployed().then(function (instance) {
          creationInstance = instance;

          return creationInstance.createPromoPlanet(1, {from: window.web3.eth.accounts[0]});
        }).then(function (result) {
          console.log(result.logs);

          for (var i = 0; i < result.logs.length; i++) {
            var log = result.logs[i];

            if (log.event === 'Birth') {
              console.log('Planet ID: ' + log.args.planetId);
              console.log('Genes: ' + log.args.genes);
              console.log('Owner: ' + log.args.owner);
              planetId = log.args.planetId;

              break;
            }
          }
        }
        ).catch(function (err) {
          console.error(err);
        });

        window.contracts.Core.deployed().then(function (instance) {
          coreInstance = instance;

          return coreInstance.getPlanet.call(planetId, 0);
        }).then(function (result) {
          result.forEach((res) => {
            if (res instanceof Object) {
              console.log(res.toNumber());
            } else {
              console.log(res);
            }
          });
        }).catch(function (err) {
          console.error(err);
        });
      },
      changeName (name) {
        // change name
        this.changeName(this.id, name);
      },
      createPlanet (traits) {
        return new Planet(traits);
      }
    },
    beforeMount () {
      mapMutations({
        changeName: 'changeName'
      });
    }
  }
</script>