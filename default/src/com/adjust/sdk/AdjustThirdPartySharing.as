package com.adjust.sdk {
    public class AdjustThirdPartySharing {
        private var isEnabled:Object;
        private var granularOptions:Array;
        private var partnerSharingSettings:Array;

        public function AdjustThirdPartySharing(isEnabled:Object) {
            this.isEnabled = isEnabled;
            this.granularOptions = new Array();
            this.partnerSharingSettings = new Array();
        }

        public function addGranularOption(partnerName:String, key:String, value:String):void {
            this.granularOptions.push(partnerName);
            this.granularOptions.push(key);
            this.granularOptions.push(value);
        }

        public function addPartnerSharingSetting(partnerName:String, key:String, value:Boolean):void {
            this.partnerSharingSettings.push(partnerName);
            this.partnerSharingSettings.push(key);
            this.partnerSharingSettings.push(value);
        }

        // getters

        public function getIsEnabled():Object {
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
