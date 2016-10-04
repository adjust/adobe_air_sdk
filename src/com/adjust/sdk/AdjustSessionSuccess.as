package com.adjust.sdk {
    public class AdjustSessionSuccess {
        private var adid:String;
        private var message:String;
        private var timestamp:String;
        private var jsonResponse:String;

        public function AdjustSessionSuccess(
            message:String,
            timestamp:String,
            adid:String,
            jsonResponse:String) {
            this.adid = adid;
            this.message = message;
            this.timestamp = timestamp;
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

        public function getJsonResponse():String {
            return this.jsonResponse;
        }
    }
}
