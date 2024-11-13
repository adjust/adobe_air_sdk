package com.adjust.sdk {
    public class AdjustAttribution {
        private var trackerToken:String;
        private var trackerName:String;
        private var campaign:String;
        private var network:String;
        private var creative:String;
        private var adgroup:String;
        private var clickLabel:String;
        private var costType:String;
        private var costAmount:Number;
        private var costCurrency:String;
        private var fbInstallReferrer:String;

        public function AdjustAttribution(
            trackerToken:String,
            trackerName:String,
            campaign:String,
            network:String,
            creative:String,
            adgroup:String,
            clickLabel:String,
            costType:String,
            costAmount:Number,
            costCurrency:String,
            fbInstallReferrer:String) {
            this.trackerToken = trackerToken;
            this.trackerName = trackerName;
            this.campaign = campaign;
            this.network = network;
            this.creative = creative;
            this.adgroup = adgroup;
            this.clickLabel = clickLabel;
            this.costType = costType;
            this.costAmount = costAmount;
            this.costCurrency = costCurrency;
            this.fbInstallReferrer = fbInstallReferrer;
        }

        // getters

        public function getTrackerToken():String {
            return this.trackerToken;
        }

        public function getTrackerName():String {
            return this.trackerName;
        }

        public function getCampaign():String {
            return this.campaign;
        }

        public function getNetwork():String {
            return this.network;
        }

        public function getCreative():String {
            return this.creative;
        }

        public function getAdgroup():String {
            return this.adgroup;
        }

        public function getClickLabel():String {
            return this.clickLabel;
        }

        public function getCostType():String {
            return this.costType;
        }

        public function getCostAmount():Number {
            return this.costAmount;
        }

        public function getCostCurrency():String {
            return this.costCurrency;
        }

        public function getFbInstallReferrer():String {
            return this.fbInstallReferrer;
        }
    }
}
