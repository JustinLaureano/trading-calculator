import OptionsCalculator from '../pages/OptionsCalculator.vue'
import SharesCalculator from '../pages/SharesCalculator.vue'
import NotFound from '../pages/NotFound.vue'

export default {
    mode: 'history',
    base: '/',
    routes: [
        {
            path: '/',
            name: 'home',
            component: OptionsCalculator,
        },
        {
            path: '/options',
            name: 'options',
            component: OptionsCalculator,
        },
        {
            path: '/shares',
            name: 'shares',
            component: SharesCalculator,
        },
        {
            path: '/*',
            component: NotFound,
        },
    ]
}