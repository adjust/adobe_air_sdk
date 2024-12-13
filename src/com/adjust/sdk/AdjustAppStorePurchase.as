package com.adjust.sdk {
    public class AdjustAppStorePurchase {
        private var productId:String;
        private var transactionId:String;

        public function AdjustAppStorePurchase(productId:String, transactionId:String) {
            this.productId = productId;
            this.transactionId = transactionId;
        }

        // getters

        public function getProductId():String {
            return this.productId;
        }

        public function getTransactionId():String {
            return this.transactionId;
        }
    }
}
