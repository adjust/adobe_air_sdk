package com.adjust.sdk {
    public class AdjustEvent {
        private var eventToken:String;
        private var revenue:Number;
        private var currency:String;
        private var callbackId:String;
        private var deduplicationId:String;
        private var productId:String;
        private var partnerParameters:Array;
        private var callbackParameters:Array;
        // ios only
        private var transactionId:String;
        // android only
        private var purchaseToken:String;

        public function AdjustEvent(eventToken:String) {
            this.eventToken = eventToken;
            this.partnerParameters = new Array();
            this.callbackParameters = new Array();
        }

        // common

        public function setRevenue(revenue:Number, currency:String):void {
            this.revenue = revenue;
            this.currency = currency;
        }

        public function setCallbackId(callbackId:String):void {
            this.callbackId = callbackId;
        }

        public function setDeduplicationId(deduplicationId:String):void {
            this.deduplicationId = deduplicationId;
        }

        public function setProductId(productId:String):void {
            this.productId = productId;
        }

        public function addCallbackParameter(key:String, value:String):void {
            this.callbackParameters.push(key);
            this.callbackParameters.push(value);
        }

        public function addPartnerParameter(key:String, value:String):void {
            this.partnerParameters.push(key);
            this.partnerParameters.push(value);
        }

        // ios only

        public function setTransactionId(transactionId:String):void {
            this.transactionId = transactionId;
        }

        // android only

        public function setPurchaseToken(purchaseToken:String):void {
            this.purchaseToken = purchaseToken;
        }

        // getters

        public function getEventToken():String {
            return this.eventToken;
        }

        public function getCurrency():String {
            return this.currency;
        }

        public function getRevenue():Number {
            return this.revenue;
        }

        public function getCallbackId():String {
            return this.callbackId;
        }

        public function getDeduplicationId():String {
            return this.deduplicationId;
        }

        public function getProductId():String {
            return this.productId;
        }

        public function getCallbackParameters():Array {
            return this.callbackParameters;
        }

        public function getPartnerParameters():Array {
            return this.partnerParameters;
        }

        public function getTransactionId():String {
            return this.transactionId;
        }

        public function getPurchaseToken():String {
            return this.purchaseToken;
        }
    }
}
