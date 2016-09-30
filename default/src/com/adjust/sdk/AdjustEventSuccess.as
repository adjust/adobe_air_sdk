package com.adjust.sdk {
    public class AdjustEventSuccess {
        private var adid:String;
        private var message:String;
        private var timestamp:String;
        private var eventToken:String;
        private var jsonResponse:String;

        public function AdjustEventSuccess(
            message:String,
            timestamp:String,
            adid:String,
            eventToken:String,
            jsonResponse:String) {
            this.adid = adid;
            this.message = message;
            this.timestamp = timestamp;
            this.eventToken = eventToken;
            this.jsonResponse = jsonResponse;
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
    }
}
