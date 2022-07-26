<template>
    <v-container>
        <v-card>
            <v-card-text>
                <v-form>
                    <v-row>
                        <v-col>
                            <h3>Account Info</h3>
                        </v-col>
                    </v-row>

                    <v-row>
                        <v-col>
                            <v-text-field
                                v-model="accountSize"
                                type="number"
                                label="Account Size"
                                prefix="$"
                            ></v-text-field>
                        </v-col>

                        <v-col>
                            <v-text-field
                                v-model="maxRiskPercent"
                                type="number"
                                label="Max Risk Percentage"
                                suffix="%"
                            ></v-text-field>
                        </v-col>

                        <v-col>
                            <v-text-field
                                v-model="maxRiskAmountDisplay"
                                label="Max Risk Amount"
                                prefix="$"
                                outlined
                                readonly
                            ></v-text-field>
                        </v-col>
                    </v-row>

                    <v-row>
                        <v-col>
                            <h3>Underlying Info</h3>
                        </v-col>
                    </v-row>

                    <v-row>
                        <v-col>
                            <v-text-field
                                v-model="assetPrice"
                                type="number"
                                label="Asset Price"
                                prefix="$"
                            ></v-text-field>
                        </v-col>

                        <v-col>
                            <v-text-field
                                v-model="stopLossPrice"
                                type="number"
                                label="Stop Loss Price"
                                prefix="$"
                            ></v-text-field>
                        </v-col>

                        <v-col>
                            <v-text-field
                                v-model="stopLossAmountDisplay"
                                label="Stop Loss Amount"
                                prefix="$"
                                outlined
                                readonly
                            ></v-text-field>
                        </v-col>
                    </v-row>

                    <v-row>
                        <v-col>
                            <h3>Option Info</h3>
                        </v-col>
                    </v-row>

                    <v-row>
                        <v-col>
                            <v-text-field
                                v-model="premiumPrice"
                                type="number"
                                label="Contract Premium"
                                prefix="$"
                            ></v-text-field>
                        </v-col>

                        <v-col>
                            <v-text-field
                                v-model="delta"
                                type="number"
                                label="Contract Delta"
                            ></v-text-field>
                        </v-col>

                        <v-col>
                            <v-text-field
                                v-model="sharesPerContract"
                                type="number"
                                label="Shared Per Contract"
                            ></v-text-field>
                        </v-col>
                    </v-row>
                </v-form>
            </v-card-text>
        </v-card>

        <v-card class="mt-4">
            <v-card-title>Position Sizing</v-card-title>

            <v-card-text>
                <v-row>
                    <v-col>
                        <v-text-field
                            v-model="stopLossPremiumPriceDisplay"
                            label="Premium Stop Loss Price"
                            prefix="$"
                            outlined
                            readonly
                        ></v-text-field>
                    </v-col>

                    <v-col>
                        <v-text-field
                            v-model="contractStopLossAmountDisplay"
                            label="Actual Risk per Contract"
                            prefix="$"
                            outlined
                            readonly
                        ></v-text-field>
                    </v-col>
                </v-row>

                <v-simple-table>
                    <template v-slot:default>
                        <thead>
                            <tr>
                                <th>Position Size</th>
                                <th>Contracts to Purchase</th>
                                <th>Contracts Purchase Amount</th>
                                <th>Total Risk Amount</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr
                                v-for="size in positionSizes"
                                :key="size"
                            >
                                <td>{{ size }}x</td>
                                <td>{{ contractsToPurchaseDisplay(size) }}</td>
                                <td>${{ contractsToPurchasePriceDisplay(size) }}</td>
                                <td>${{ totalRiskAmountDisplay(size) }}</td>
                            </tr>
                        </tbody>
                    </template>
                </v-simple-table>
            </v-card-text>
        </v-card>

    </v-container>
</template>

<script>
export default {
    name: "OptionsCalculator",

    data() {
        return {
            accountSize: 25000.00,
            maxRiskPercent: 1,

            assetPrice: 100.00,
            stopLossPrice: 99.00,

            premiumPrice: 1.50,
            delta: 0.5,
            sharesPerContract: 100,

            positionSizes: [ .25, .33, .5, .66, .75, 1, 1.25, 1.33, 1.5, 1.66, 1.75, 2 ]
        };
    },

    computed: {
        contractPrice() {
            if (!this.premiumPrice) return 0;

            return this.premiumPrice * this.sharesPerContract;
        },

        contractStopLossAmount() {
            return (this.stopLossAmount * this.delta) * this.sharesPerContract;
        },

        contractStopLossAmountDisplay() {
            return this.contractStopLossAmount.toFixed(2);
        },

        contractsToPurchase() {
            if (!this.contractStopLossAmount) return 0;

            return parseFloat(this.maxRiskAmount / this.contractStopLossAmount);
        },

        contractsToPurchasePrice() {
            if (!this.contractsToPurchase) return 0;

            return this.contractsToPurchase * this.contractPrice;
        },

        maxRiskAmount() {
            if (!this.accountSize && !this.maxRiskPercent) return 0;

            return (parseFloat(this.accountSize) * parseFloat(this.maxRiskPercent)) / 100;
        },

        maxRiskAmountDisplay() {
            return this.maxRiskAmount.toFixed(2);
        },

        stopLossAmount() {
            if (!this.assetPrice && !this.stopLossPrice) return 0;

            return Math.abs(this.assetPrice - this.stopLossPrice);
        },

        stopLossAmountDisplay() {
            return this.stopLossAmount.toFixed(2);
        },

        stopLossPremiumPrice() {
            return this.premiumPrice - (this.stopLossAmount * this.delta);
        },

        stopLossPremiumPriceDisplay() {
            return this.stopLossPremiumPrice.toFixed(2);
        },

        totalRiskAmount() {
            return this.contractsToPurchase * this.contractStopLossAmount;
        }
    },

    methods: {
        contractsToPurchaseDisplay(multiplier = 1) {
            return (this.contractsToPurchase * multiplier).toFixed(1);
        },

        contractsToPurchasePriceDisplay(multiplier = 1) {
            return (this.contractsToPurchasePrice * multiplier).toFixed(2);
        },

        totalRiskAmountDisplay(multiplier = 1) {
            return ((this.contractsToPurchase * multiplier) * this.contractStopLossAmount).toFixed(2);
        }
    }
}
</script>
