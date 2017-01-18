package com.adjust.sdk {
    public class AdjustAttribution {
        private var trackerToken:String;
        private var trackerName:String;
        private var campaign:String;
        private var network:String;
        private var creative:String;
        private var adgroup:String;
        private var clickLabel:String;
        private var adid:String;

        public function AdjustAttribution(
            trackerToken:String,
            trackerName:String,
            campaign:String,
            network:String,
            creative:String,
            adgroup:String,
            clickLabel:String,
            adid:String) {
            this.trackerToken = trackerToken;
            this.trackerName = trackerName;
            this.campaign = campaign;
            this.network = network;
            this.creative = creative;
            this.adgroup = adgroup;
            this.clickLabel = clickLabel;
            this.adid = adid;
        }

        // Getters
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

        public function getAdGroup():String {
            return this.adgroup;
        }

        public function getClickLabel():String {
            return this.clickLabel;
        }

        public function getAdid():String {
            return this.adid;
        }
    }
}
