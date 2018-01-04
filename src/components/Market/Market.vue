<template>
    <v-layout column>
        <v-flex xs12 sm6 offset-sm3>
            <v-container fluid grid-list-md class="grey lighten-4">
                <v-layout row wrap>
                    <v-flex
                            v-bind="{ [`xs6`]: true }"
                            v-for="card in cards"
                            :key="card.title"
                    >
                        <v-card>
                            <v-card-media
                                    :src="card.src"
                                    height="300px"
                            >
                                <v-container fill-height fluid>
                                    <v-layout fill-height>
                                        <v-flex xs12 align-end flexbox>
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
  export default {
    data: () => ({
      cards: [
        { title: 'Purple Planet', src: 'https://files.slack.com/files-pri/T8KQ18934-F8N5VE9NJ/atmotest_1.png', flex: 6 },
        { title: 'Brown Planet', src: 'https://files.slack.com/files-pri/T8KQ18934-F8N5VER9C/atmotest_5.png', flex: 6 },
        { title: 'Blue Planet', src: 'https://files.slack.com/files-pri/T8KQ18934-F8NBU28AK/atmotest_4.png', flex: 6 }
      ]
    })
  }
</script>