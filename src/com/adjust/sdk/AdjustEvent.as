package com.adjust.sdk {
    public class AdjustEvent {
        // For iOS & Android
        private var revenue:Number;
        private var currency:String;
        private var eventToken:String;
        private var transactionId:String;
        private var partnerParameters:Array;
        private var callbackParameters:Array;

        // iOS specific
        private var receipt:String;
        private var isReceiptSet:Boolean;

        public function AdjustEvent(eventToken:String) {
            this.isReceiptSet = false;
            this.eventToken = eventToken;
            this.partnerParameters = new Array();
            this.callbackParameters = new Array();
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

        public function setTransactionId(transactionId:String):void {
            this.transactionId = transactionId;
        }

        public function setReceiptForTransactionId(receipt:String, transactionId:String):void {
            this.receipt = receipt;
            this.transactionId = transactionId;
            this.isReceiptSet = true;
        }

        // Getters
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

        public function getTransactionId():String {
            return this.transactionId;
        }

        public function getReceipt():String {
            return this.receipt;
        }

        public function getIsReceiptSet():Boolean {
            return this.isReceiptSet;
        }
    }
}
