package com.adjust.sdk {
    public class AdjustAdRevenue {
        private var source:String;
        private var revenue:Number;
        private var currency:String;
        private var adImpressionsCount:int;
        private var adRevenueNetwork:String;
        private var adRevenueUnit:String;
        private var adRevenuePlacement:String;
        private var partnerParameters:Array;
        private var callbackParameters:Array;

        public function AdjustAdRevenue(source:String) {
            this.source = source;
            this.partnerParameters = new Array();
            this.callbackParameters = new Array();
        }

        public function setRevenue(revenue:Number, currency:String):void {
            this.revenue = revenue;
            this.currency = currency;
        }

        public function setAdImpressionsCount(adImpressionsCount:int):void {
            this.adImpressionsCount = adImpressionsCount;
        }

        public function setAdRevenueNetwork(adRevenueNetwork:String):void {
            this.adRevenueNetwork = adRevenueNetwork;
        }

        public function setAdRevenueUnit(adRevenueUnit:String):void {
            this.adRevenueUnit = adRevenueUnit;
        }

        public function setAdRevenuePlacement(adRevenuePlacement:String):void {
            this.adRevenuePlacement = adRevenuePlacement;
        }

        public function addCallbackParameter(key:String, value:String):void {
            this.callbackParameters.push(key);
            this.callbackParameters.push(value);
        }

        public function addPartnerParameter(key:String, value:String):void {
            this.partnerParameters.push(key);
            this.partnerParameters.push(value);
        }

        // getters

        public function getSource():String {
            return this.source;
        }

        public function getRevenue():Number {
            return this.revenue;
        }

        public function getCurrency():String {
            return this.currency;
        }

        public function getAdImpressionsCount():int {
            return this.adImpressionsCount;
        }

        public function getAdRevenueNetwork():String {
            return this.adRevenueNetwork;
        }
        public function getAdRevenueUnit():String {
            return this.adRevenueUnit;
        }
        public function getAdRevenuePlacement():String {
            return this.adRevenuePlacement;
        }

        public function getCallbackParameters():Array {
            return this.callbackParameters;
        }

        public function getPartnerParameters():Array {
            return this.partnerParameters;
        }
    }
}
