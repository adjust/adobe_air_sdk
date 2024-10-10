package com.adjust.sdk {
    import flash.events.*;
    import flash.external.ExtensionContext;

    public class Adjust extends EventDispatcher {
        private static var sdkPrefix:String = "adobe_air5.0.0";
        private static var errorMessage:String = "Adjust: SDK not started. Start it manually using the 'initSdk' method";

        private static var extensionContext:ExtensionContext = null;

        private static var attributionCallback:Function;
        private static var eventSuccessCallback:Function;
        private static var eventFailureCallback:Function;
        private static var sessionSuccessCallback:Function;
        private static var sessionFailureCallback:Function;
        private static var deferredDeeplinkCallback:Function;
        private static var skanUpdatedCallback:Function;

        private static var isEnabledCalback:Function;
        private static var getAdidCallback:Function;
        private static var getAttributionCallback:Function;
        private static var getSdkVersionCallbak:Function;
        private static var getLastDeeplinkCallback:Function;
        private static var processAndResolveDeeplinkCallback:Function;
        
        private static var getGoogleAdIdCallback:Function;
        private static var getAmazonAdIdCallback:Function;
        private static var verifyPlayStorePurchaseCallback:Function;
        private static var verifyAndTrackPlayStorePurchaseCallback:Function;

        private static var getIdfaCallback:Function;
        private static var getIdfvCallback:Function;
        private static var getAppTrackingStatusCallback:Function;
        private static var requestAppTrackingAuthorizationCallback:Function;
        private static var verifyAppStorePurchaseCallback:Function;
        private static var verifyAndTrackAppStorePurchaseCallback:Function;

        private static function getExtensionContext():ExtensionContext {
            if (extensionContext != null) {
                return extensionContext;
            }
            return extensionContext = ExtensionContext.createExtensionContext("com.adjust.sdk", null);
        }

        // common

        public static function initSdk(adjustConfig:AdjustConfig):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().addEventListener(StatusEvent.STATUS, extensionResponseDelegate);

            attributionCallback = adjustConfig.getAttributionCallback();
            eventSuccessCallback = adjustConfig.getEventSuccessCallback();
            eventFailureCallback = adjustConfig.getEventFailureCallback();
            sessionSuccessCallback = adjustConfig.getSessionSuccessCallback();
            sessionFailureCallback = adjustConfig.getSessionFailureCallback();
            deferredDeeplinkCallback = adjustConfig.getDeferredDeeplinkCallback();
            skanUpdatedCallback = adjustConfig.getSkanUpdatedCallback();

            getExtensionContext().call("initSdk",
                // common
                adjustConfig.getAppToken(), // [0]
                adjustConfig.getEnvironment(), // [1]
                adjustConfig.getLogLevel(),  // [2]
                sdkPrefix, // [3]
                adjustConfig.getDefaultTracker(), // [4]
                adjustConfig.getExternalDeviceId(), // [5]
                adjustConfig.getIsCoppaComplianceEnabled(), // [6]
                adjustConfig.getIsSendingInBackgroundEnabled(), // [7]
                adjustConfig.getIsDeferredDeeplinkOpeningEnabled(), // [8]
                adjustConfig.getIsCostDataInAttributionEnabled(), // [9]
                adjustConfig.getIsDeviceIdsReadingOnceEnabled(), // [10]
                adjustConfig.getAttributionCallback() != null, // [11]
                adjustConfig.getEventSuccessCallback() != null, // [12]
                adjustConfig.getEventFailureCallback() != null, // [13]
                adjustConfig.getSessionSuccessCallback() != null, // [14]
                adjustConfig.getSessionFailureCallback() != null, // [15]
                adjustConfig.getDeferredDeeplinkCallback() != null, // [16]
                adjustConfig.getEventDedupliactionIdsMaxSize() > -1 ?
                    adjustConfig.getEventDedupliactionIdsMaxSize() : null, // [17]
                adjustConfig.getUrlStrategyDomains(), // [18]
                adjustConfig.getUseSubdomains(), // [19]
                adjustConfig.getIsDataResidency(), // [20]
                // android only
                adjustConfig.getFbAppId(), // [21]
                adjustConfig.getProcessName(), // [22]
                adjustConfig.getPreinstallFilePath(), // [23]
                adjustConfig.getIsPreinstallTrackingEnabled(), // [24]
                adjustConfig.getIsPlayStoreKidsComplianceEnabled(), // [25]
                // ios only
                adjustConfig.getIsLinkMeEnabled(), // [26]
                adjustConfig.getIsAdServicesEnabled(), // [27]
                adjustConfig.getIsIdfaReadingEnabled(), // [28]
                adjustConfig.getIsIdfvReadingEnabled(), // [29]
                adjustConfig.getIsSkanAttributionEnabled(), // [30]
                adjustConfig.getAttConsentWaitingInterval(), // [31]
                adjustConfig.getSkanUpdatedCallback() != null); // [32]
        }

        public static function enable():void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().call("enable");
        }

        public static function disable():void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().call("disable");
        }

        public static function switchToOfflineMode():void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().call("switchToOfflineMode");
        }

        public static function switchBackToOnlineMode():void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().call("switchBackToOnlineMode");
        }

        public static function trackEvent(adjustEvent:AdjustEvent):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().call("trackEvent",
                // common
                adjustEvent.getEventToken(), // [0]
                adjustEvent.getRevenue(), // [1]
                adjustEvent.getCurrency(), // [2]
                adjustEvent.getCallbackId(), // [3]
                adjustEvent.getDeduplicationId(), // [4]
                adjustEvent.getProductId(), // [5]
                adjustEvent.getCallbackParameters(), // [6]
                adjustEvent.getPartnerParameters(), // [7]
                // ios only
                adjustEvent.getTransactionId(), // [8]
                // android only
                adjustEvent.getPurchaseToken()); // [9]
        }

        public static function trackAdRevenue(adjustAdRevenue:AdjustAdRevenue):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().call("trackAdRevenue",
                adjustAdRevenue.getSource(), // [0]
                adjustAdRevenue.getRevenue(), // [1]
                adjustAdRevenue.getCurrency(), // [2]
                adjustAdRevenue.getAdImpressionsCount(), // [3]
                adjustAdRevenue.getAdRevenueNetwork(), // [4]
                adjustAdRevenue.getAdRevenueUnit(), // [5]
                adjustAdRevenue.getAdRevenuePlacement(), // [6]
                adjustAdRevenue.getCallbackParameters(), // [7]
                adjustAdRevenue.getPartnerParameters()); // [8]
        }

        public static function trackThirdPartySharing(adjustThirdPartySharing:AdjustThirdPartySharing):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().call("trackThirdPartySharing",
                adjustThirdPartySharing.getIsEnabled(), // [0]
                adjustThirdPartySharing.getGranularOptions(), // [1]
                adjustThirdPartySharing.getPartnerSharingSettings()); // [2]
        }

        public static function trackMeasurementConsent(measurementConsent:Boolean):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().call("trackMeasurementConsent", measurementConsent);
        }

        public static function processDeeplink(adjustDeeplink:AdjustDeeplink):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().call("processDeeplink", adjustDeeplink.getDeeplink());
        }

        public static function processAndResolveDeeplink(
            adjustDeeplink:AdjustDeeplink,
            callback:Function):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            processAndResolveDeeplinkCallback = callback;
            getExtensionContext().call("processAndResolveDeeplink",
                adjustDeeplink.getDeeplink()); // [0]
        }

        public static function setPushToken(pushToken:String):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().call("setPushToken", pushToken);
        }

        public static function gdprForgetMe():void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().call("gdprForgetMe");
        }

        public static function addGlobalCallbackParameter(key:String, value:String):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().call("addGlobalCallbackParameter", key, value);
        }

        public static function removeGlobalCallbackParameter(key:String):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().call("removeGlobalCallbackParameter", key);
        }

        public static function removeGlobalCallbackParameters():void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().call("removeGlobalCallbackParameters");
        }

        public static function addGlobalPartnerParameter(key:String, value:String):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().call("addGlobalPartnerParameter", key, value);
        }

        public static function removeGlobalPartnerParameter(key:String):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().call("removeGlobalPartnerParameter", key);
        }

        public static function removeGlobalPartnerParameters():void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().call("removeGlobalPartnerParameters");
        }

        public static function isEnabled(callback:Function):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            isEnabledCalback = callback;
            getExtensionContext().call("isEnabled");
        }

        public static function getAdid(callback:Function):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getAdidCallback = callback;
            getExtensionContext().call("getAdid");
        }

        public static function getAttribution(callback:Function):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getAttributionCallback = callback;
            getExtensionContext().call("getAttribution");
        }

        public static function getSdkVersion(callback:Function):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().addEventListener(StatusEvent.STATUS, extensionResponseDelegate);
            getSdkVersionCallbak = callback;
            getExtensionContext().call("getSdkVersion");
        }

        public static function getLastDeeplink(callback:Function):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().addEventListener(StatusEvent.STATUS, extensionResponseDelegate);
            getLastDeeplinkCallback = callback;
            getExtensionContext().call("getLastDeeplink");
        }

        // ios only

        public static function trackAppStoreSubscription(adjustAppStoreSubscription:AdjustAppStoreSubscription):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().call("trackAppStoreSubscription",
                adjustAppStoreSubscription.getPrice(), // [0]
                adjustAppStoreSubscription.getCurrency(), // [1]
                adjustAppStoreSubscription.getTransactionId(), // [2]
                adjustAppStoreSubscription.getTransactionDate(), // [3]
                adjustAppStoreSubscription.getSalesRegion(), // [4]
                adjustAppStoreSubscription.getCallbackParameters(), // [5]
                adjustAppStoreSubscription.getPartnerParameters()); // [6]
        }

        public static function verifyAppStorePurchase(
            adjustAppStorePurchase:AdjustAppStorePurchase,
            callback:Function):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            verifyAppStorePurchaseCallback = callback;
            getExtensionContext().call("verifyAppStorePurchase",
                adjustAppStorePurchase.getProductId(), // [0]
                adjustAppStorePurchase.getTransactionId()); // [1]
        }

        public static function verifyAndTrackAppStorePurchase(
            adjustEvent:AdjustEvent,
            callback:Function):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            verifyAndTrackAppStorePurchaseCallback = callback;
            getExtensionContext().call("verifyAndTrackAppStorePurchase",
                // common
                adjustEvent.getEventToken(), // [0]
                adjustEvent.getRevenue(), // [1]
                adjustEvent.getCurrency(), // [2]
                adjustEvent.getCallbackId(), // [3]
                adjustEvent.getDeduplicationId(), // [4]
                adjustEvent.getProductId(), // [5]
                adjustEvent.getCallbackParameters(), // [6]
                adjustEvent.getPartnerParameters(), // [7]
                // ios only
                adjustEvent.getTransactionId(), // [8]
                // android only
                adjustEvent.getPurchaseToken()); // [9]
        }

        public static function getIdfa(callback:Function):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().addEventListener(StatusEvent.STATUS, extensionResponseDelegate);
            getIdfaCallback = callback;
            getExtensionContext().call("getIdfa");
        }

        public static function getIdfv(callback:Function):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().addEventListener(StatusEvent.STATUS, extensionResponseDelegate);
            getIdfvCallback = callback;
            getExtensionContext().call("getIdfv");
        }

        public static function getAppTrackingStatus(callback:Function):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().addEventListener(StatusEvent.STATUS, extensionResponseDelegate);
            getAppTrackingStatusCallback = callback;
            getExtensionContext().call("getAppTrackingStatus");
        }

        public static function requestAppTrackingAuthorization(callback:Function):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().addEventListener(StatusEvent.STATUS, extensionResponseDelegate);
            requestAppTrackingAuthorizationCallback = callback;
            getExtensionContext().call("requestAppTrackingAuthorization");
        }

        // android only

        public static function trackPlayStoreSubscription(adjustPlayStoreSubscription:AdjustPlayStoreSubscription):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().call("trackPlayStoreSubscription",
                adjustPlayStoreSubscription.getPrice(), // [0]
                adjustPlayStoreSubscription.getCurrency(), // [1]
                adjustPlayStoreSubscription.getSku(), // [2]
                adjustPlayStoreSubscription.getOrderId(), // [3]
                adjustPlayStoreSubscription.getSignature(), // [4]
                adjustPlayStoreSubscription.getPurchaseToken(), // [5]
                adjustPlayStoreSubscription.getPurchaseTime(), // [6]
                adjustPlayStoreSubscription.getCallbackParameters(), // [7]
                adjustPlayStoreSubscription.getPartnerParameters()); // [8]
        }

        public static function verifyPlayStorePurchase(
            adjustPlayStorePurchase:AdjustPlayStorePurchase,
            callback:Function):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            verifyPlayStorePurchaseCallback = callback;
            getExtensionContext().call("verifyPlayStorePurchase",
                adjustPlayStorePurchase.getProductId(), // [0]
                adjustPlayStorePurchase.getPurchaseToken()); // [1]
        }

        public static function verifyAndTrackPlayStorePurchase(
            adjustEvent:AdjustEvent,
            callback:Function):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            verifyAndTrackPlayStorePurchaseCallback = callback;
            getExtensionContext().call("verifyAndTrackPlayStorePurchase",
                // common
                adjustEvent.getEventToken(), // [0]
                adjustEvent.getRevenue(), // [1]
                adjustEvent.getCurrency(), // [2]
                adjustEvent.getCallbackId(), // [3]
                adjustEvent.getDeduplicationId(), // [4]
                adjustEvent.getProductId(), // [5]
                adjustEvent.getCallbackParameters(), // [6]
                adjustEvent.getPartnerParameters(), // [7]
                // ios only
                adjustEvent.getTransactionId(), // [8]
                // android only
                adjustEvent.getPurchaseToken()); // [9]
        }

        public static function getGoogleAdId(callback:Function):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().addEventListener(StatusEvent.STATUS, extensionResponseDelegate);
            getGoogleAdIdCallback = callback;
            getExtensionContext().call("getGoogleAdId");
        }

        public static function getAmazonAdId(callback:Function):void {
            if (!getExtensionContext()) {
                trace(errorMessage);
                return;
            }

            getExtensionContext().addEventListener(StatusEvent.STATUS, extensionResponseDelegate);
            getAmazonAdIdCallback = callback;
            getExtensionContext().call("getAmazonAdId");
        }

        // testing only

        public static function onResume():void {
            getExtensionContext().call("onResume");
        }

        public static function onPause():void {
            getExtensionContext().call("onPause");
        }

        public static function setTestOptions(testOptions:AdjustTestOptions):void {
            getExtensionContext().call("setTestOptions", 
                testOptions.testUrlOverwrite, // [0]
                testOptions.extraPath, // [1]
                testOptions.timerIntervalInMilliseconds, // [2]
                testOptions.timerStartInMilliseconds, // [3]
                testOptions.sessionIntervalInMilliseconds, // [4]
                testOptions.subsessionIntervalInMilliseconds, // [5]
                testOptions.attStatus, // [6]
                testOptions.idfa, // [7]
                testOptions.noBackoffWait, // [8]
                testOptions.adServicesFrameworkEnabled, // [9]
                testOptions.teardown, // [10]
                testOptions.deleteState, // [11]
                testOptions.ignoreSystemLifecycleBootstrap); // [12]
        }

        public static function teardown():void {
            getExtensionContext().call("teardown");
        }

        // private and helper methods

        private static function extensionResponseDelegate(statusEvent:StatusEvent):void {
            if (statusEvent.code == "adjust_attributionCallback") {
                var attribution:AdjustAttribution = getAttributionFromResponse(statusEvent.level);
                attributionCallback(attribution);
            } else if (statusEvent.code == "adjust_eventSuccessCallback") {
                var eventSuccess:AdjustEventSuccess = getEventSuccessFromResponse(statusEvent.level);
                eventSuccessCallback(eventSuccess);
            } else if (statusEvent.code == "adjust_eventFailureCallback") {
                var eventFailure:AdjustEventFailure = getEventFailFromResponse(statusEvent.level);
                eventFailureCallback(eventFailure);
            } else if (statusEvent.code == "adjust_sessionSuccessCallback") {
                var sessionSuccess:AdjustSessionSuccess = getSessionSuccessFromResponse(statusEvent.level);
                sessionSuccessCallback(sessionSuccess);
            } else if (statusEvent.code == "adjust_sessionFailureCallback") {
                var sessionFailure:AdjustSessionFailure = getSessionFailFromResponse(statusEvent.level);
                sessionFailureCallback(sessionFailure);
            } else if (statusEvent.code == "adjust_deferredDeeplinkCallback") {
                var uri:String = getDeferredDeeplinkFromResponse(statusEvent.level);
                deferredDeeplinkCallback(uri);
            } else if (statusEvent.code == "adjust_isEnabled") {
                var isEnabled:String = statusEvent.level;
                isEnabledCalback(isEnabled == "true");
            } else if (statusEvent.code == "adjust_getAdid") {
                var adid:String = statusEvent.level;
                getAdidCallback(adid);
            } else if (statusEvent.code == "adjust_getAttribution") {
                var getAttribution:AdjustAttribution = getAttributionFromResponse(statusEvent.level);
                getAttributionCallback(getAttribution);
            } else if (statusEvent.code == "adjust_getSdkVersion") {
                var sdkVersion:String = statusEvent.level;
                getSdkVersionCallbak(sdkPrefix + "@" + sdkVersion);
            } else if (statusEvent.code == "adjust_getLastDeeplink") {
                var lastDeeplink:String = statusEvent.level;
                if (lastDeeplink == "ADJ__NULL") {
                    lastDeeplink = null;
                }
                getLastDeeplinkCallback(lastDeeplink);
            } else if (statusEvent.code == "adjust_getGoogleAdId") {
                var googleAdId:String = statusEvent.level;
                if (googleAdId == "ADJ__NULL") {
                    googleAdId = null;
                }
                getGoogleAdIdCallback(googleAdId);
            } else if (statusEvent.code == "adjust_getAmazonAdId") {
                var amazonAdId:String = statusEvent.level;
                if (amazonAdId == "ADJ__NULL") {
                    amazonAdId = null;
                }
                getAmazonAdIdCallback(amazonAdId);
            } else if (statusEvent.code == "adjust_verifyPlayStorePurchase") {
                var purchaseVerificationResultVerify:AdjustPurchaseVerificationResult = 
                getPurchaseVerificationResultFromResponse(statusEvent.level);
                verifyPlayStorePurchaseCallback(purchaseVerificationResultVerify);
            } else if (statusEvent.code == "adjust_verifyAndTrackPlayStorePurchase") {
                var purchaseVerificationResultVerifyAndTrack:AdjustPurchaseVerificationResult = 
                getPurchaseVerificationResultFromResponse(statusEvent.level);
                verifyAndTrackPlayStorePurchaseCallback(purchaseVerificationResultVerifyAndTrack);
            } else if (statusEvent.code == "adjust_processAndResolveDeeplink") {
                var resolvedLink:String = statusEvent.level;
                processAndResolveDeeplinkCallback(resolvedLink);
            } 
            // TODO: add ios events
            // else if (statusEvent.code == "adjust_authorizationStatus") {
            //     var authorizationStatus:String = statusEvent.level;
            //     getAppTrackingStatusCallback(authorizationStatus);
            // }

            // TODO: callbacks missing
        }

        private static function getEventSuccessFromResponse(response:String):AdjustEventSuccess {
            var adid:String;
            var message:String;
            var timestamp:String;
            var eventToken:String;
            var callbackId:String;
            var jsonResponse:String;
            var parts:Array = response.split("__");

            for (var i:int = 0; i < parts.length; i++) {
                var field:Array = parts[i].split("==");
                var key:String = field[0];
                var value:String = field[1];

                if (key == "message") {
                    message = value;
                } else if (key == "timestamp") {
                    timestamp = value;
                } else if (key == "adid") {
                    adid = value;
                } else if (key == "eventToken") {
                    eventToken = value;
                } else if (key == "callbackId") {
                    callbackId = value;
                } else if (key == "jsonResponse") {
                    jsonResponse = value;
                }
            }

            return new AdjustEventSuccess(message, timestamp, adid, eventToken, callbackId, jsonResponse);
        }

        private static function getEventFailFromResponse(response:String):AdjustEventFailure {
            var adid:String;
            var message:String;
            var timestamp:String;
            var eventToken:String;
            var callbackId:String;
            var willRetry:Boolean;
            var jsonResponse:String;
            var parts:Array = response.split("__");

            for (var i:int = 0; i < parts.length; i++) {
                var field:Array = parts[i].split("==");
                var key:String = field[0];
                var value:String = field[1];

                if (key == "message") {
                    message = value;
                } else if (key == "timestamp") {
                    timestamp = value;
                } else if (key == "adid") {
                    adid = value;
                } else if (key == "eventToken") {
                    eventToken = value;
                } else if (key == "callbackId") {
                    callbackId = value;
                } else if (key == "willRetry") {
                    var tempVal:String = value;
                    willRetry = tempVal == "true";
                } else if (key == "jsonResponse") {
                    jsonResponse = value;
                }
            }

            return new AdjustEventFailure(message, timestamp, adid, eventToken, callbackId, willRetry, jsonResponse);
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
                } else if (key == "timestamp") {
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
                } else if (key == "timestamp") {
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

            return new AdjustSessionFailure(message, timestamp, adid, willRetry, jsonResponse);
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
            var costType:String;
            var costAmount:Number;
            var costCurrency:String;
            var fbInstallReferrer:String;
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
                } else if (key == "costType") {
                    costType = value;
                } else if (key == "costAmount") {
                    costAmount = Number(value);
                } else if (key == "costCurrency") {
                    costCurrency = value;
                } else if (key == "fbInstallReferrer") {
                    fbInstallReferrer = value;
                }
            }

            return new AdjustAttribution(
                trackerToken,
                trackerName,
                campaign,
                network,
                creative,
                adgroup,
                clickLabel,
                costType,
                costAmount,
                costCurrency,
                fbInstallReferrer);
        }

        private static function getPurchaseVerificationResultFromResponse(response:String):AdjustPurchaseVerificationResult {
            var verificationStatus:String;
            var message:String;
            var code:Number;
            var parts:Array = response.split("__");

            for (var i:int = 0; i < parts.length; i++) {
                var field:Array = parts[i].split("==");
                var key:String = field[0];
                var value:String = field[1];

                if (key == "verificationStatus") {
                    verificationStatus = value;
                } else if (key == "message") {
                    message = value;
                } else if (key == "code") {
                    code = Number(value);
                }
            }

            return new AdjustPurchaseVerificationResult(code, message, verificationStatus);
        }
    }
}
