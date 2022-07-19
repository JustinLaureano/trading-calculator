<template>
    <v-app>
        <app-bar></app-bar>
        <v-main>
            <sizing-form></sizing-form>
        </v-main>
    </v-app>
</template>

<script>
import AppBar from './components/AppBar'
import SizingForm from './components/SizingForm'

export default {
    name: 'App',

    components: {
        'app-bar': AppBar,
        'sizing-form': SizingForm
    }
}
</script>
