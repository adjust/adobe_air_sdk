package com.adjust.sdk {
    import flash.desktop.NativeApplication;
    import flash.events.*;
    import flash.external.ExtensionContext;

    public class Adjust extends EventDispatcher {
        private static var sdkPrefix:String = "adobe_air4.11.2";
        private static var errorMessage:String = "adjust: SDK not started. Start it manually using the 'start' method";
        
        private static var hasSdkStarted:Boolean = false;
        private static var extensionContext:ExtensionContext = null;
        
        private static var attributionCallbackDelegate:Function;
        private static var googleAdIdCallbackDelegate:Function;
        private static var eventTrackingSucceededDelegate:Function;
        private static var eventTrackingFailedDelegate:Function;
        private static var sessionTrackingSucceededDelegate:Function;
        private static var sessionTrackingFailedDelegate:Function;
        private static var deferredDeeplinkDelegate:Function;

        private static function getExtensionContext():ExtensionContext {
            if (extensionContext != null) {
                return extensionContext;
            }
            
            return extensionContext = ExtensionContext.createExtensionContext("com.adjust.sdk", null);
        }

        public static function start(adjustConfig:AdjustConfig):void {
            if (hasSdkStarted) {
                trace("adjust warning: SDK already started");
                return;
            }

            hasSdkStarted = true;

            var app:NativeApplication = NativeApplication.nativeApplication;
            app.addEventListener(Event.ACTIVATE, onResume);
            app.addEventListener(Event.DEACTIVATE, onPause);
            app.addEventListener(InvokeEvent.INVOKE, onInvoke);

            attributionCallbackDelegate = adjustConfig.getAttributionCallbackDelegate();
            getExtensionContext().addEventListener(StatusEvent.STATUS, extensionResponseDelegate);

            eventTrackingSucceededDelegate = adjustConfig.getEventTrackingSucceededDelegate();
            getExtensionContext().addEventListener(StatusEvent.STATUS, extensionResponseDelegate);

            eventTrackingFailedDelegate = adjustConfig.getEventTrackingFailedDelegate();
            getExtensionContext().addEventListener(StatusEvent.STATUS, extensionResponseDelegate);

            sessionTrackingSucceededDelegate = adjustConfig.getSessionTrackingSucceededDelegate();
            getExtensionContext().addEventListener(StatusEvent.STATUS, extensionResponseDelegate);

            sessionTrackingFailedDelegate = adjustConfig.getSessionTrackingFailedDelegate();
            getExtensionContext().addEventListener(StatusEvent.STATUS, extensionResponseDelegate);

            deferredDeeplinkDelegate = adjustConfig.getDeferredDeeplinkDelegate();
            getExtensionContext().addEventListener(StatusEvent.STATUS, extensionResponseDelegate);

            getExtensionContext().call("onCreate", 
                    adjustConfig.getAppToken(), 
                    adjustConfig.getEnvironment(),
                    adjustConfig.getLogLevel(), 
                    adjustConfig.getEventBufferingEnabled(),
                    adjustConfig.getAttributionCallbackDelegate() != null, 
                    adjustConfig.getEventTrackingSucceededDelegate() != null, 
                    adjustConfig.getEventTrackingFailedDelegate() != null, 
                    adjustConfig.getSessionTrackingSucceededDelegate() != null, 
                    adjustConfig.getSessionTrackingFailedDelegate() != null, 
                    adjustConfig.getDeferredDeeplinkDelegate() != null, 
                    adjustConfig.getDefaultTracker(),
                    sdkPrefix,
                    adjustConfig.getShouldLaunchDeeplink(),
                    adjustConfig.getProcessName(),
                    adjustConfig.getDelayStart(),
                    adjustConfig.getUserAgent(),
                    adjustConfig.getSendInBackground());

            // For now, call onResume after onCreate.
            getExtensionContext().call("onResume");
        }

        public static function trackEvent(adjustEvent:AdjustEvent):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().call("trackEvent", 
                    adjustEvent.getEventToken(), 
                    adjustEvent.getCurrency(),
                    adjustEvent.getRevenue(), 
                    adjustEvent.getCallbackParameters(), 
                    adjustEvent.getPartnerParameters(),
                    adjustEvent.getTransactionId(), 
                    adjustEvent.getReceipt(), 
                    adjustEvent.getIsReceiptSet());
        }

        public static function setEnabled(enabled:Boolean):void {
            getExtensionContext().call("setEnabled", enabled);
        }

        public static function isEnabled():Boolean {
            var isEnabled:int = int (getExtensionContext().call("isEnabled"));
            return isEnabled;
        }

        public static function onResume(event:Event):void {
            getExtensionContext().call("onResume");
        }

        public static function onPause(event:Event):void {
            getExtensionContext().call("onPause");
        }

        public static function appWillOpenUrl(url:String):void {
            getExtensionContext().call("appWillOpenUrl", url);
        }

        public static function setOfflineMode(isOffline:Boolean):void {
            getExtensionContext().call("setOfflineMode", isOffline);
        }

        public static function setReferrer(referrer:String):void {
            getExtensionContext().call("setReferrer", referrer);
        }

        public static function setDeviceToken(token:String):void {
            getExtensionContext().call("setDeviceToken", token);
        }

        public static function getIdfa():String {
            var idfa:String = String (getExtensionContext().call("getIdfa"));

            return idfa;
        }

        public static function getAdid():String {
            var adid:String = String (getExtensionContext().call("getAdid"));

            return adid;
        }

        public static function getAttribution():AdjustAttribution {
            var attributionString:String = String (getExtensionContext().call("getAttribution"));
            var attribution:AdjustAttribution = getAttributionFromResponse(attributionString);
            
            return attribution;
        }

        public static function getGoogleAdId(callback:Function):void {
            googleAdIdCallbackDelegate = callback;
            getExtensionContext().addEventListener(StatusEvent.STATUS, extensionResponseDelegate);

            getExtensionContext().call("getGoogleAdId");
        }

        public static function addSessionCallbackParameter(key:String, value:String):void {
            getExtensionContext().call("addSessionCallbackParameter", key, value);
        }

        public static function addSessionPartnerParameter(key:String, value:String):void {
            getExtensionContext().call("addSessionPartnerParameter", key, value);
        }

        public static function removeSessionCallbackParameter(key:String):void {
            getExtensionContext().call("removeSessionCallbackParameter", key);
        }

        public static function removeSessionPartnerParameter(key:String):void {
            getExtensionContext().call("removeSessionPartnerParameter", key);
        }

        public static function resetSessionCallbackParameters():void {
            getExtensionContext().call("resetSessionCallbackParameters");
        }

        public static function resetSessionPartnerParameters():void {
            getExtensionContext().call("resetSessionPartnerParameters");
        }

        public static function sendFirstPackages():void {
            getExtensionContext().call("sendFirstPackages");
        }

        private static function extensionResponseDelegate(statusEvent:StatusEvent):void {
            if (statusEvent.code == "adjust_attributionData") {
                var attribution:AdjustAttribution = getAttributionFromResponse(statusEvent.level);
                attributionCallbackDelegate(attribution);
            } else if (statusEvent.code == "adjust_eventTrackingSucceeded") {
                var eventSuccess:AdjustEventSuccess = getEventSuccessFromResponse(statusEvent.level);
                eventTrackingSucceededDelegate(eventSuccess);
            } else if (statusEvent.code == "adjust_eventTrackingFailed") {
                var eventFail:AdjustEventFailure = getEventFailFromResponse(statusEvent.level);
                eventTrackingFailedDelegate(eventFail);
            } else if (statusEvent.code == "adjust_sessionTrackingSucceeded") {
                var sessionSuccess:AdjustSessionSuccess = getSessionSuccessFromResponse(statusEvent.level);
                sessionTrackingSucceededDelegate(sessionSuccess);
            } else if (statusEvent.code == "adjust_sessionTrackingFailed") {
                var sessionFail:AdjustSessionFailure = getSessionFailFromResponse(statusEvent.level);
                sessionTrackingFailedDelegate(sessionFail);
            } else if (statusEvent.code == "adjust_deferredDeeplink") {
                var uri:String = getDeferredDeeplinkFromResponse(statusEvent.level);
                deferredDeeplinkDelegate(uri);
            } else if (statusEvent.code == "adjust_googleAdId") {
                var googleAdId:String = statusEvent.level;
                googleAdIdCallbackDelegate(googleAdId);
            }
        }

        private static function getEventSuccessFromResponse(response:String):AdjustEventSuccess {
            var adid:String;
            var message:String;
            var timestamp:String;
            var eventToken:String;
            var jsonResponse:String;

            var parts:Array = response.split("__");

            for (var i:int = 0; i < parts.length; i++) {
                var field:Array = parts[i].split("==");
                var key:String = field[0];
                var value:String = field[1];

                if (key == "message") {
                    message = value;
                } else if (key == "timeStamp") {
                    timestamp = value;
                } else if (key == "adid") {
                    adid = value;
                } else if (key == "eventToken") {
                    eventToken = value;
                } else if (key == "jsonResponse") {
                    jsonResponse = value;
                }
            }

            return new AdjustEventSuccess(message, timestamp, adid, eventToken, jsonResponse);
        }

        private static function getEventFailFromResponse(response:String):AdjustEventFailure {
            var adid:String;
            var message:String;
            var timestamp:String;
            var eventToken:String;
            var willRetry:Boolean;
            var jsonResponse:String;

            var parts:Array = response.split("__");

            for (var i:int = 0; i < parts.length; i++) {
                var field:Array = parts[i].split("==");
                var key:String = field[0];
                var value:String = field[1];

                if (key == "message") {
                    message = value;
                } else if (key == "timeStamp") {
                    timestamp = value;
                } else if (key == "adid") {
                    adid = value;
                } else if (key == "eventToken") {
                    eventToken = value;
                } else if (key == "willRetry") {
                    var tempVal:String = value;
                    willRetry = tempVal == "true";
                } else if (key == "jsonResponse") {
                    jsonResponse = value;
                }
            }

            return new AdjustEventFailure(message, timestamp, adid, eventToken, jsonResponse, willRetry);
        }

        private static function getSessionSuccessFromResponse(response:String):AdjustSessionSuccess {
            var adid:String;
            var message:String;
            var timestamp:String;
            var jsonResponse:String;

            var parts:Array = response.split("__");

            for (var i:int = 0; i < parts.length; i++) {
                var field:Array = parts[i].split("==");
                var key:String = field[0];
                var value:String = field[1];

                if (key == "message") {
                    message = value;
                } else if (key == "timeStamp") {
                    timestamp = value;
                } else if (key == "adid") {
                    adid = value;
                } else if (key == "jsonResponse") {
                    jsonResponse = value;
                }
            }

            return new AdjustSessionSuccess(message, timestamp, adid, jsonResponse);
        }

        private static function getSessionFailFromResponse(response:String):AdjustSessionFailure {
            var adid:String;
            var message:String;
            var timestamp:String;
            var willRetry:Boolean;
            var jsonResponse:String;

            var parts:Array = response.split("__");

            for (var i:int = 0; i < parts.length; i++) {
                var field:Array = parts[i].split("==");
                var key:String = field[0];
                var value:String = field[1];

                if (key == "message") {
                    message = value;
                } else if (key == "timeStamp") {
                    timestamp = value;
                } else if (key == "adid") {
                    adid = value;
                } else if (key == "willRetry") {
                    var tempVal:String = value;
                    willRetry = tempVal == "true";
                } else if (key == "jsonResponse") {
                    jsonResponse = value;
                }

            }

            return new AdjustSessionFailure(message, timestamp, adid, jsonResponse, willRetry);
        }


        private static function getDeferredDeeplinkFromResponse(response:String):String {
            return response;
        }

        private static function getAttributionFromResponse(response:String):AdjustAttribution {
            var trackerToken:String;
            var trackerName:String;
            var campaign:String;
            var network:String;
            var creative:String;
            var adgroup:String;
            var clickLabel:String;
            var adid:String;

            var parts:Array = response.split("__");

            for (var i:int = 0; i < parts.length; i++) {
                var field:Array = parts[i].split("==");
                var key:String = field[0];
                var value:String = field[1];

                if (key == "trackerToken") {
                    trackerToken = value;
                } else if (key == "trackerName") {
                    trackerName = value;
                } else if (key == "campaign") {
                    campaign = value;
                } else if (key == "network") {
                    network = value;
                } else if (key == "creative") {
                    creative = value;
                } else if (key == "adgroup") {
                    adgroup = value;
                } else if (key == "clickLabel") {
                    clickLabel = value;
                } else if (key == "adid") {
                    adid = value;
                }
            }

            return new AdjustAttribution(trackerToken, trackerName, campaign, network, creative, adgroup, clickLabel, adid);
        }

        private static function onInvoke(event:InvokeEvent):void {
            if (event.arguments.length == 0) {
                return;
            }

            var argument:String = event.arguments[0];
            appWillOpenUrl(argument);
        }
    }
}
