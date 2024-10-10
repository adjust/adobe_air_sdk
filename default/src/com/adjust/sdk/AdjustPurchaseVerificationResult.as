package com.adjust.sdk {
    public class AdjustPurchaseVerificationResult {
        private var code:int;
        private var message:String;
        private var verificationStatus:String;

        public function AdjustPurchaseVerificationResult(code:int, message:String, verificationStatus:String) {
            this.code = code;
            this.message = message;
            this.verificationStatus = verificationStatus;
        }

        // getters

        public function getCode():int {
            return this.code;
        }

        public function getMessage():String {
            return this.message;
        }

        public function getVerificationStatus():String {
            return this.verificationStatus;
        }
    }
}
