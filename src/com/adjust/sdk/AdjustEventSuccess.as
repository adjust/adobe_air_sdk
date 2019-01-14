package com.adjust.sdk {
    public class AdjustEventSuccess {
        private var adid:String;
        private var message:String;
        private var timestamp:String;
        private var eventToken:String;
        private var callbackId:String;
        private var jsonResponse:String;

        public function AdjustEventSuccess(
            message:String,
            timestamp:String,
            adid:String,
            eventToken:String,
            callbackId:String,
            jsonResponse:String) {
            this.message = message;
            this.timestamp = timestamp;
            this.adid = adid;
            this.eventToken = eventToken;
            this.callbackId = callbackId;
            this.jsonResponse = jsonResponse;
        }

        // Getters.
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

        public function getCallbackId():String {
            return this.callbackId;
        }

        public function getJsonResponse():String {
            return this.jsonResponse;
        }
    }
}
