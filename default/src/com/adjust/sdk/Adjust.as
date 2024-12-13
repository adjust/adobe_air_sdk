package com.adjust.sdk {
    import flash.events.Event;
    import flash.events.EventDispatcher;

    public class Adjust extends EventDispatcher {
        // common

        public static function initSdk(adjustConfig:AdjustConfig):void {
            trace("Adjust: Adjust.initSdk called");
        }

        public static function enable():void {
            trace("Adjust: Adjust.enable called");
        }

        public static function disable():void {
            trace("Adjust: Adjust.disable called");
        }

        public static function switchToOfflineMode():void {
            trace("Adjust: Adjust.switchToOfflineMode called");
        }

        public static function switchBackToOnlineMode():void {
            trace("Adjust: Adjust.switchBackToOnlineMode called");
        }

        public static function trackEvent(adjustEvent:AdjustEvent):void {
            trace("Adjust: Adjust.trackEvent called");
        }

        public static function trackAdRevenue(adjustAdRevenue:AdjustAdRevenue):void {
            trace("Adjust: Adjust.trackAdRevenue called");
        }

        public static function trackThirdPartySharing(adjustThirdPartySharing:AdjustThirdPartySharing):void {
            trace("Adjust: Adjust.trackThirdPartySharing called");
        }

        public static function trackMeasurementConsent(measurementConsent:Boolean):void {
            trace("Adjust: Adjust.trackMeasurementConsent called");
        }

        public static function processDeeplink(adjustDeeplink:AdjustDeeplink):void {
            trace("Adjust: Adjust.processDeeplink called");
        }

        public static function processAndResolveDeeplink(
            adjustDeeplink:AdjustDeeplink,
            callback:Function):void {
            trace("Adjust: Adjust.processAndResolveDeeplink called");
        }

        public static function setPushToken(pushToken:String):void {
            trace("Adjust: Adjust.setPushToken called");
        }

        public static function gdprForgetMe():void {
            trace("Adjust: Adjust.gdprForgetMe called");
        }

        public static function addGlobalCallbackParameter(key:String, value:String):void {
            trace("Adjust: Adjust.addGlobalCallbackParameter called");
        }

        public static function removeGlobalCallbackParameter(key:String):void {
            trace("Adjust: Adjust.removeGlobalCallbackParameter called");
        }

        public static function removeGlobalCallbackParameters():void {
            trace("Adjust: Adjust.removeGlobalCallbackParameters called");
        }

        public static function addGlobalPartnerParameter(key:String, value:String):void {
            trace("Adjust: Adjust.addGlobalPartnerParameter called");
        }

        public static function removeGlobalPartnerParameter(key:String):void {
            trace("Adjust: Adjust.removeGlobalPartnerParameter called");
        }

        public static function removeGlobalPartnerParameters():void {
            trace("Adjust: Adjust.removeGlobalCallbackParameters called");
        }

        public static function isEnabled(callback:Function):void {
            trace("Adjust: Adjust.isEnabled called");
        }

        public static function getAdid(callback:Function):void {
            trace("Adjust: Adjust.getAdid called");
        }

        public static function getAttribution(callback:Function):void {
            trace("Adjust: Adjust.getAttribution called");
        }

        public static function getSdkVersion(callback:Function):void {
            trace("Adjust: Adjust.getSdkVersion called");
        }

        public static function getLastDeeplink(callback:Function):void {
            trace("Adjust: Adjust.getLastDeeplink called");
        }

        // ios only

        public static function trackAppStoreSubscription(adjustAppStoreSubscription:AdjustAppStoreSubscription):void {
            trace("Adjust: Adjust.trackAppStoreSubscription called");
        }

        public static function verifyAppStorePurchase(
            adjustAppStorePurchase:AdjustAppStorePurchase,
            callback:Function):void {
            trace("Adjust: Adjust.verifyAppStorePurchase called");
        }

        public static function verifyAndTrackAppStorePurchase(
            adjustEvent:AdjustEvent,
            callback:Function):void {
            trace("Adjust: Adjust.verifyAndTrackAppStorePurchase called");
        }

        public static function getIdfa(callback:Function):void {
            trace("Adjust: Adjust.getIdfa called");
        }

        public static function getIdfv(callback:Function):void {
            trace("Adjust: Adjust.getIdfv called");
        }

        public static function getAppTrackingStatus(callback:Function):void {
            trace("Adjust: Adjust.getAppTrackingStatus called");
        }

        public static function requestAppTrackingAuthorization(callback:Function):void {
            trace("Adjust: Adjust.requestAppTrackingAuthorization called");
        }

        // android only

        public static function trackPlayStoreSubscription(adjustPlayStoreSubscription:AdjustPlayStoreSubscription):void {
            trace("Adjust: Adjust.trackPlayStoreSubscription called");
        }

        public static function verifyPlayStorePurchase(
            adjustPlayStorePurchase:AdjustPlayStorePurchase,
            callback:Function):void {
            trace("Adjust: Adjust.verifyPlayStorePurchase called");
        }

        public static function verifyAndTrackPlayStorePurchase(
            adjustEvent:AdjustEvent,
            callback:Function):void {
            trace("Adjust: Adjust.verifyAndTrackPlayStorePurchase called");
        }

        public static function getGoogleAdId(callback:Function):void {
            trace("Adjust: Adjust.getGoogleAdId called");
        }

        public static function getAmazonAdId(callback:Function):void {
            trace("Adjust: Adjust.getAmazonAdId called");
        }

        // testing only

        public static function onResume():void {
            trace("Adjust: Adjust.onResume called");
        }

        public static function onPause():void {
            trace("Adjust: Adjust.onPause called");
        }

        public static function setTestOptions(testOptions:AdjustTestOptions):void {
            trace("Adjust: Adjust.setTestOptions called");
        }

        public static function teardown():void {
            trace("Adjust: Adjust.teardown called");
        }
    }
}
