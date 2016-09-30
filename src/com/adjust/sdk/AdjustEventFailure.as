package com.adjust.sdk {
    public class AdjustEventFailure {
        private var willRetry:Boolean;

        private var adid:String;
        private var message:String;
        private var timestamp:String;
        private var eventToken:String;
        private var jsonResponse:String;

        public function AdjustEventFailure(
            message:String,
            timestamp:String,
            adid:String,
            eventToken:String,
            jsonResponse:String,
            willRetry:Boolean) {
            this.adid = adid;
            this.message = message;
            this.timestamp = timestamp;
            this.eventToken = eventToken;
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

        public function getEventToken():String {
            return this.eventToken;
        }

        public function getJsonResponse():String {
            return this.jsonResponse;
        }

        public function getWillRetry():Boolean {
            return this.willRetry;
        }
    }
}
