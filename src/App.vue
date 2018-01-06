<template>
    <div id="app">
        <v-app>
            <!--<v-navigation-drawer v-model="drawer">-->
                <!--<v-list>-->
                    <!--<v-list-tile v-for="item in menuItems" :key="item.title">-->
                        <!--<v-list-tile-action>-->
                            <!--<v-icon>search</v-icon>-->
                        <!--</v-list-tile-action>-->
                        <!--<v-list-tile-content>{{ item.title }}</v-list-tile-content>-->
                    <!--</v-list-tile>-->
                <!--</v-list>-->
            <!--</v-navigation-drawer>-->
            <v-toolbar dark color="primary" app fixed clipped-left>
                <v-toolbar-side-icon @click.stop="drawer = !drawer" class="hidden-sm-and-up"></v-toolbar-side-icon>
                <v-toolbar-title class="white--text">
                    <router-link to="/" tag="span" style="cursor: pointer">Earthereum</router-link>
                </v-toolbar-title>
                <v-spacer></v-spacer>
                <v-btn flat dark v-for="item in menuItems" :key="item.title"
                 router :to="item.link">
                    <!-- <v-icon>search</v-icon> -->
                    {{ item.title }}
                </v-btn>
                <!--<v-btn icon>-->
                    <!--<v-icon>apps</v-icon>-->
                    <!--{{ item.title }}-->
                <!--</v-btn>-->
                <!--<v-btn icon>-->
                    <!--<v-icon>refresh</v-icon>-->
                <!--</v-btn>-->
                <!--<v-btn icon>-->
                    <!--<v-icon>more_vert</v-icon>-->
                <!--</v-btn>-->
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
    <main>
            <v-content>
            <router-view></router-view>
            </v-content>

    </main>
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
      drawer: false,
      menuItems: [
        {title: 'Home', link: '/'},
        {title: 'Market', link: '/market'},
        {title: 'Planet', link: '/planet/1'},
        {title: 'About', link: '/about'},
        {title: 'GitHub', link: '/github'}

      ]

    }),
    props: {
      source: String
    }
  }
</script>

<style>

</style>
