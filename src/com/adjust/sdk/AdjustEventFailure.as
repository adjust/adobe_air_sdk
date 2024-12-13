package com.adjust.sdk {
    public class AdjustEventFailure {
        private var adid:String;
        private var message:String;
        private var timestamp:String;
        private var eventToken:String;
        private var callbackId:String;
        private var willRetry:Boolean;
        private var jsonResponse:String;

        public function AdjustEventFailure(
            message:String,
            timestamp:String,
            adid:String,
            eventToken:String,
            callbackId:String,
            willRetry:Boolean,
            jsonResponse:String) {
            this.adid = adid;
            this.message = message;
            this.timestamp = timestamp;
            this.eventToken = eventToken;
            this.callbackId = callbackId;
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

        public function getEventToken():String {
            return this.eventToken;
        }

        public function getCallbackId():String {
            return this.callbackId;
        }

        public function getWillRetry():Boolean {
            return this.willRetry;
        }

        public function getJsonResponse():String {
            return this.jsonResponse;
        }
    }
}
