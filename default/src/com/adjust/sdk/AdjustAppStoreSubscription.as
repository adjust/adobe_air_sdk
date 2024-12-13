package com.adjust.sdk {
    public class AdjustAppStoreSubscription {
        private var price:String;
        private var currency:String;
        private var transactionId:String;
        private var transactionDate:String;
        private var salesRegion:String;
        private var partnerParameters:Array;
        private var callbackParameters:Array;

        public function AdjustAppStoreSubscription(price:String, currency:String, transactionId:String) {
            this.price = price;
            this.currency = currency;
            this.transactionId = transactionId;
            this.partnerParameters = new Array();
            this.callbackParameters = new Array();
        }

        public function setTransactionDate(transactionDate:String):void {
            this.transactionDate = transactionDate;
        }

        public function setSalesRegion(salesRegion:String):void {
            this.salesRegion = salesRegion;
        }

        public function addCallbackParameter(key:String, value:String):void {
            if (key == null) {
                this.callbackParameters.push("ADJ__NULL");
            } else {
                this.callbackParameters.push(key);
            }
            if (value == null) {
                this.callbackParameters.push("ADJ__NULL");
            } else {
                this.callbackParameters.push(value);
            }
        }

        public function addPartnerParameter(key:String, value:String):void {
            if (key == null) {
                this.partnerParameters.push("ADJ__NULL");
            } else {
                this.partnerParameters.push(key);
            }
            if (value == null) {
                this.partnerParameters.push("ADJ__NULL");
            } else {
                this.partnerParameters.push(value);
            }
        }

        // getters

        public function getPrice():String {
            return this.price;
        }

        public function getCurrency():String {
            return this.currency;
        }

        public function getTransactionId():String {
            return this.transactionId;
        }

        public function getTransactionDate():String {
            return this.transactionDate;
        }

        public function getSalesRegion():String {
            return this.salesRegion;
        }

        public function getCallbackParameters():Array {
            return this.callbackParameters;
        }

        public function getPartnerParameters():Array {
            return this.partnerParameters;
        }
    }
}
