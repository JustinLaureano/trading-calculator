<template>
    <v-app-bar color="white" dense app>
        <v-toolbar-title class="d-flex justify-center">
            TC
        </v-toolbar-title>

		<template v-slot:extension>
            <v-tabs dense>
                <v-tab to="/options">
                    Options
                </v-tab>

                <v-tab to="/shares">
                    Shares
                </v-tab>
            </v-tabs>
		</template>
    </v-app-bar>
</template>

<script>
export default {
    name: 'AppBar'
}
</script>