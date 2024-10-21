package com.adjust.sdk {
    public class AdjustPlayStoreSubscription {
        private var price:String;
        private var currency:String;
        private var sku:String;
        private var orderId:String;
        private var signature:String;
        private var purchaseToken:String;
        private var purchaseTime:String;
        private var partnerParameters:Array;
        private var callbackParameters:Array;

        public function AdjustPlayStoreSubscription(
            price:String,
            currency:String,
            sku:String,
            orderId:String,
            signature:String,
            purchaseToken:String) {
            this.price = price;
            this.currency = currency;
            this.sku = sku;
            this.orderId = orderId;
            this.signature = signature;
            this.purchaseToken = purchaseToken;
            this.partnerParameters = new Array();
            this.callbackParameters = new Array();
        }

        public function setPurchaseTime(purchaseTime:String):void {
            this.purchaseTime = purchaseTime;
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

        public function getSku():String {
            return this.sku;
        }

        public function getOrderId():String {
            return this.orderId;
        }

        public function getSignature():String {
            return this.signature;
        }

        public function getPurchaseToken():String {
            return this.purchaseToken;
        }

        public function getPurchaseTime():String {
            return this.purchaseTime;
        }

        public function getCallbackParameters():Array {
            return this.callbackParameters;
        }

        public function getPartnerParameters():Array {
            return this.partnerParameters;
        }
    }
}
