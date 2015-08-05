package com.adjust.sdk {
    public class AdjustEvent {
        private var eventToken: String;
        private var currency: String;
        private var revenue: Number;

        private var partnerParameters: Array;
        private var callbackParameters: Array;

        public function AdjustEvent(eventToken:String) {
            this.eventToken = eventToken;

            this.partnerParameters = new Array();
            this.callbackParameters = new Array();

            // Invalid revenue settings.
            this.revenue = -1;
            this.currency = "";
        }

        public function setRevenue(revenue:Number, currency:String):void {
            this.revenue = revenue;
            this.currency = currency;
        }

        public function addCallbackParameter(key:String, value:String):void {
            this.callbackParameters.push(key);
            this.callbackParameters.push(value);
        }

        public function addPartnerParameter(key:String, value:String):void {
            this.partnerParameters.push(key);
            this.partnerParameters.push(value);
        }

        // Getters.
        public function getEventToken():String {
            return this.eventToken;
        }

        public function getCurrency():String {
            return this.currency;
        }

        public function getRevenue():Number {
            return this.revenue;
        }

        public function getCallbackParameters():Array {
            return this.callbackParameters;
        }

        public function getPartnerParameters():Array {
            return this.partnerParameters;
        }
    }
}
