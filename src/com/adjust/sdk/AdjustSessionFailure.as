package com.adjust.sdk {
    public class AdjustSessionFailure {
        private var willRetry:Boolean;

        private var adid:String;
        private var message:String;
        private var timestamp:String;
        private var jsonResponse:String;

        public function AdjustSessionFailure(
            message:String,
            timestamp:String,
            adid:String,
            jsonResponse:String,
            willRetry:Boolean) {
            this.adid = adid;
            this.message = message;
            this.timestamp = timestamp;
            this.jsonResponse = jsonResponse;
            this.willRetry = willRetry;
        }

        // Getters
        public function getMessage():String {
            return this.message;
        }

        public function getTimeStamp():String {
            return this.timestamp;
        }

        public function getAdid():String {
            return this.adid;
        }

        public function getJsonResponse():String {
            return this.jsonResponse;
        }

        public function getWillRetry():Boolean {
            return this.willRetry;
        }
    }
}
