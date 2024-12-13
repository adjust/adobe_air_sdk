package com.adjust.sdk {
    public class AdjustDeeplink {
        private var deeplink:String;

        public function AdjustDeeplink(deeplink:String) {
            this.deeplink = deeplink;
        }

        // getters

        public function getDeeplink():String {
            return this.deeplink;
        }
    }
}
