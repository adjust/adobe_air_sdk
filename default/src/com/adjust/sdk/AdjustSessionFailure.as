package com.adjust.sdk {
    public class AdjustSessionFailure {
        private var adid:String;
        private var message:String;
        private var timestamp:String;
        private var willRetry:Boolean;
        private var jsonResponse:String;

        public function AdjustSessionFailure(
            message:String,
            timestamp:String,
            adid:String,
            willRetry:Boolean,
            jsonResponse:String) {
            this.adid = adid;
            this.message = message;
            this.timestamp = timestamp;
            this.willRetry = willRetry;
            this.jsonResponse = jsonResponse;
        }

        // getters

        public function getMessage():String {
            return this.message;
        }

        public function getTimestamp():String {
            return this.timestamp;
        }

        public function getAdid():String {
            return this.adid;
        }

        public function getWillRetry():Boolean {
            return this.willRetry;
        }

        public function getJsonResponse():String {
            return this.jsonResponse;
        }
    }
}
