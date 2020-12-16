package com.adjust.sdk {
    import flash.events.Event;
    import flash.events.EventDispatcher;

    public class Adjust extends EventDispatcher {
        public static function start(adjustConfig:AdjustConfig):void {
            trace("Adjust: start called");
        }

        public static function trackEvent(adjustEvent:AdjustEvent):void {
            trace("Adjust: trackEvent called");
        }

        public static function setEnabled(enabled:Boolean):void {
            trace("Adjust: setEnabled called");
        }

        public static function isEnabled():Boolean {
            trace("Adjust: isEnabled called");
            return false;
        }

        public static function onResume(event:Event):void {
            trace("Adjust: onResume called");
        }

        public static function onPause(event:Event):void {
            trace("Adjust: onPause called");
        }

        public static function appWillOpenUrl(url:String):void {
            trace("Adjust: appWillOpenUrl called");
        }

        public static function setOfflineMode(isOffline:Boolean):void {
            trace("Adjust: setOfflineMode called");
        }

        public static function setReferrer(referrer:String):void {
            trace("Adjust: setReferrer called");
        }

        public static function setDeviceToken(deviceToken:String):void {
            trace("Adjust: setDeviceToken called");
        }

        public static function getIdfa():void {
            trace("Adjust: getIdfa called");
        }

        public static function getAdid():void {
            trace("Adjust: getAdid called");
        }

        public static function getAttribution():void {
            trace("Adjust: getAttribution called");
        }

        public static function getSdkVersion():void {
            trace("Adjust: getSdkVersion called");
        }

        public static function getGoogleAdId(callback:Function):void {
            trace("Adjust: getGoogleAdId called");
        }

        public static function getAmazonAdId():void {
            trace("Adjust: getAmazonAdId called");
        }

        public static function addSessionCallbackParameter(key:String, value:String):void {
            trace("Adjust: addSessionCallbackParameter called");
        }

        public static function removeSessionCallbackParameter(key:String):void {
            trace("Adjust: removeSessionCallbackParameter called");
        }

        public static function resetSessionCallbackParameters():void {
            trace("Adjust: resetSessionCallbackParameters called");
        }

        public static function addSessionPartnerParameter(key:String, value:String):void {
            trace("Adjust: addSessionPartnerParameter called");
        }

        public static function removeSessionPartnerParameter(key:String):void {
            trace("Adjust: removeSessionPartnerParameter called");
        }

        public static function resetSessionPartnerParameters():void {
            trace("Adjust: resetSessionPartnerParameters called");
        }

        public static function gdprForgetMe():void {
            trace("Adjust: gdprForgetMe called");
        }

        public static function trackAdRevenue(source:String, payload:String):void {
            trace("Adjust: trackAdRevenue called");
        }

        public static function disableThirdPartySharing():void {
            trace("Adjust: disableThirdPartySharing called");
        }

        public static function requestTrackingAuthorizationWithCompletionHandler(callback:Function):void {
            trace("Adjust: requestTrackingAuthorizationWithCompletionHandler called");
        }

        public static function setTestOptions(testOptions:AdjustTestOptions):void {
            trace("Adjust: setTestOptions called");
        }

        public static function teardown():void {
            trace("Adjust: teardown called");
        }
    }
}
