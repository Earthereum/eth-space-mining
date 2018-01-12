<template>
    <div id="app">
        <v-app>
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
            </v-toolbar>
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
      drawer: false
    }),
    computed: {
      menuItems () {
        let menuItems = [
          {title: 'Home', link: '/home'},
          {title: 'Market', link: '/market'},
          {title: 'About', link: '/about'},
          {title: 'GitHub', link: '/github'}
        ];
        if (this.$store.getters.user !== null && this.$store.getters.user !== undefined) {
          menuItems = [
            {title: 'Home', link: '/home'},
            {title: 'Market', link: '/market'},
            {title: 'My Planets', link: '/myplanets'},
            {title: 'Admin', link: '/_admin'},
            {title: 'About', link: '/about'},
            {title: 'GitHub', link: '/github'}
          ];
        }
        return menuItems;
      }
    },

    props: {
      source: String
    }
  }
</script>

<style>

</style>
