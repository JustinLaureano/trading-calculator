<template>
    <v-app>
        <app-bar></app-bar>
        <v-main>
            <v-container>
                <router-view></router-view>
            </v-container>
        </v-main>
    </v-app>
</template>

<script>
import AppBar from './components/AppBar'

export default {
    name: 'App',

    components: {
        'app-bar': AppBar
    }
}
</script>
