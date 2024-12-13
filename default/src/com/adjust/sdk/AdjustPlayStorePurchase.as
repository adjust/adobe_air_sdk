package com.adjust.sdk {
    public class AdjustPlayStorePurchase {
        private var productId:String;
        private var purchaseToken:String;

        public function AdjustPlayStorePurchase(productId:String, purchaseToken:String) {
            this.productId = productId;
            this.purchaseToken = purchaseToken;
        }

        // getters

        public function getProductId():String {
            return this.productId;
        }

        public function getPurchaseToken():String {
            return this.purchaseToken;
        }
    }
}
