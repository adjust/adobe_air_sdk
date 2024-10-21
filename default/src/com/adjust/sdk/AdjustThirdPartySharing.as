package com.adjust.sdk {
    public class AdjustThirdPartySharing {
        private var isEnabled:String;
        private var granularOptions:Array;
        private var partnerSharingSettings:Array;

        public function AdjustThirdPartySharing(isEnabled:String) {
            this.isEnabled = isEnabled;
            this.granularOptions = new Array();
            this.partnerSharingSettings = new Array();
        }

        public function addGranularOption(partnerName:String, key:String, value:String):void {
            if (partnerName == null) {
                this.granularOptions.push("ADJ__NULL");
            } else {
                this.granularOptions.push(partnerName);
            }
            if (key == null) {
                this.granularOptions.push("ADJ__NULL");
            } else {
                this.granularOptions.push(key);
            }
            if (value == null) {
                this.granularOptions.push("ADJ__NULL");
            } else {
                this.granularOptions.push(value);
            }
        }

        public function addPartnerSharingSetting(partnerName:String, key:String, value:Boolean):void {
            if (partnerName == null) {
                this.partnerSharingSettings.push("ADJ__NULL");
            } else {
                this.partnerSharingSettings.push(partnerName);
            }
            if (key == null) {
                this.partnerSharingSettings.push("ADJ__NULL");
            } else {
                this.partnerSharingSettings.push(key);
            }
            this.partnerSharingSettings.push(value.toString());
        }

        // getters

        public function getIsEnabled():String {
            return this.isEnabled;
        }

        public function getGranularOptions():Array {
            return this.granularOptions;
        }

        public function getPartnerSharingSettings():Array {
            return this.partnerSharingSettings;
        }
    }
}
