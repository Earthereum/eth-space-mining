<template>
    <div id="app">
        <v-app>
            <v-navigation-drawer
                    clipped
                    fixed
                    v-model="drawer"
                    app>
            </v-navigation-drawer>

            <v-toolbar dark color="primary" app fixed clipped-left>
                <v-toolbar-side-icon @click.stop="drawer = !drawer"></v-toolbar-side-icon>
                <v-toolbar-title class="white--text">Title</v-toolbar-title>
                <v-spacer></v-spacer>
                <v-btn icon>
                    <v-icon>search</v-icon>
                </v-btn>
                <v-btn icon>
                    <v-icon>apps</v-icon>
                </v-btn>
                <v-btn icon>
                    <v-icon>refresh</v-icon>
                </v-btn>
                <v-btn icon>
                    <v-icon>more_vert</v-icon>
                </v-btn>
            </v-toolbar>

            <!--<v-navigation-drawer-->
            <!--clipped-->
            <!--fixed-->
            <!--v-model="drawer"-->
            <!--app>-->
            <!--</v-navigation-drawer>-->

            <!--<v-toolbar app fixed clipped-left>-->
            <!--<v-toolbar-side-icon @click.stop="drawer = !drawer"></v-toolbar-side-icon>-->
            <!--<v-toolbar-title>{{name}}</v-toolbar-title>-->
            <!--</v-toolbar>-->

            <v-content>
            <v-container fluid fill-height>
            <router-view></router-view>
            </v-container>
            </v-content>

            <v-footer app fixed>
                <span>&copy; {{new Date().getFullYear()}} Earthereum</span>
            </v-footer>
        </v-app>
    </div>
</template>

<script>
  export default {
    name: 'Earthereum',
    data: () => ({
      drawer: false
    }),
    props: {
      source: String
    }
  }
</script>

<style>

</style>
