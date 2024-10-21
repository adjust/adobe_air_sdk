package com.adjust.sdk {
    public class AdjustConfig {
        private var appToken:String;
        private var environment:String;
        private var logLevel:String;
        private var defaultTracker:String;
        private var externalDeviceId:String;

        private var isCoppaComplianceEnabled:Boolean;
        private var isSendingInBackgroundEnabled:Boolean;
        private var isDeferredDeeplinkOpeningEnabled:Boolean;
        private var isCostDataInAttributionEnabled:Boolean;
        private var isDeviceIdsReadingOnceEnabled:Boolean;

        private var attributionCallback:Function;
        private var eventSuccessCallback:Function;
        private var eventFailureCallback:Function;
        private var sessionSuccessCallback:Function;
        private var sessionFailureCallback:Function;
        private var deferredDeeplinkCallback:Function;

        private var eventDeduplicationIdsMaxSize:int;

        // URL strategy
        private var urlStrategyDomains:Array;
        private var isDataResidency:Object;
        private var useSubdomains:Object;

        // android only
        private var fbAppId:String;
        private var processName:String;
        private var preinstallFilePath:String;
        private var isPreinstallTrackingEnabled:Boolean;
        private var isPlayStoreKidsComplianceEnabled:Boolean;

        // ios only
        private var isLinkMeEnabled:Boolean;
        private var isAdServicesEnabled:Boolean;
        private var isIdfaReadingEnabled:Boolean;
        private var isIdfvReadingEnabled:Boolean;
        private var isSkanAttributionEnabled:Boolean;
        private var attConsentWaitingInterval:int;
        private var skanUpdatedCallback:Function;

        public function AdjustConfig(appToken:String, environment:String) {
            this.appToken = appToken;
            this.environment = environment;

            // set boolean members to their default values
            this.isCoppaComplianceEnabled = false;
            this.isSendingInBackgroundEnabled = false;
            this.isDeferredDeeplinkOpeningEnabled = true;
            this.isCostDataInAttributionEnabled = false;
            this.isDeviceIdsReadingOnceEnabled = false;

            // set int members to default invalid values
            this.eventDeduplicationIdsMaxSize = -1;
            this.attConsentWaitingInterval = -1;

            // android only
            this.isPreinstallTrackingEnabled = false;
            this.isPlayStoreKidsComplianceEnabled = false;

            // ios only
            this.isLinkMeEnabled = false;
            this.isAdServicesEnabled = true;
            this.isIdfaReadingEnabled = true;
            this.isIdfvReadingEnabled = true;
            this.isSkanAttributionEnabled = true;
        }

        // common

        public function setLogLevel(logLevel:String):void {
            this.logLevel = logLevel;
        }

        public function setDefaultTracker(defaultTracker:String):void {
            this.defaultTracker = defaultTracker;
        }

        public function setExternalDeviceId(externalDeviceId:String):void {
            this.externalDeviceId = externalDeviceId;
        }

        public function setUrlStrategy(urlStrategyDomains:Array, isDataResidency:Boolean, useSubdomains:Boolean):void {
            this.urlStrategyDomains = urlStrategyDomains;
            this.isDataResidency = isDataResidency;
            this.useSubdomains = useSubdomains;
        }

        public function enableCoppaCompliance():void {
            this.isCoppaComplianceEnabled = true;
        }

        public function enableSendingInBackground():void {
            this.isSendingInBackgroundEnabled = true;
        }

        public function disableDeferredDeeplinkOpening():void {
            this.isDeferredDeeplinkOpeningEnabled = false;
        }

        public function enableCostDataInAttribution():void {
            this.isCostDataInAttributionEnabled = true;
        }

        public function enableDeviceIdsReadingOnce():void {
            this.isDeviceIdsReadingOnceEnabled = true;
        }

        public function setEventDeduplicationIdsMaxSize(eventDeduplicationIdsMaxSize:int):void {
            this.eventDeduplicationIdsMaxSize = eventDeduplicationIdsMaxSize;
        }

        public function setAttributionCallback(callback:Function):void {
            this.attributionCallback = callback;
        }

        public function setEventSuccessCallback(callback:Function):void {
            this.eventSuccessCallback = callback;
        }

        public function setEventFailureCallback(callback:Function):void {
            this.eventFailureCallback = callback;
        }

        public function setSessionSuccessCallback(callback:Function):void {
            this.sessionSuccessCallback = callback;
        }

        public function setSessionFailureCallback(callback:Function):void {
            this.sessionFailureCallback = callback;
        }

        public function setDeferredDeeplinkCallback(callback:Function):void {
            this.deferredDeeplinkCallback = callback;
        }

        // android only

        public function setFbAppId(fbAppId:String):void {
            this.fbAppId = fbAppId;
        }

        public function setProcessName(processName:String):void {
            this.processName = processName;
        }

        public function setPreinstallFilePath(preinstallFilePath:String):void {
            this.preinstallFilePath = preinstallFilePath;
        }

        public function enablePlayStoreKidsCompliance():void {
            this.isPlayStoreKidsComplianceEnabled = true;
        }

        public function enablePreinstallTracking():void {
            this.isPreinstallTrackingEnabled = true;
        }

        // ios only

        public function enableLinkMe():void {
            this.isLinkMeEnabled = true;
        }

        public function disableSkanAttribution():void {
            this.isSkanAttributionEnabled = false;
        }

        public function disableAdServices():void {
            this.isAdServicesEnabled = false;
        }

        public function disableIdfaReading():void {
            this.isIdfaReadingEnabled = false;
        }

        public function disableIdfvReading():void {
            this.isIdfvReadingEnabled = false;
        }

        public function setAttConsentWaitingInterval(attConsentWaitingInterval:int):void {
            this.attConsentWaitingInterval = attConsentWaitingInterval;
        }

        public function setSkanUpdatedCallback(callback:Function):void {
            this.skanUpdatedCallback = callback;
        }

        // common getters

        public function getAppToken():String {
            return this.appToken;
        }

        public function getEnvironment():String {
            return this.environment;
        }

        public function getLogLevel():String {
            return this.logLevel;
        }

        public function getDefaultTracker():String {
            return this.defaultTracker;
        }

        public function getExternalDeviceId():String {
            return this.externalDeviceId;
        }

        public function getIsCoppaComplianceEnabled():Boolean {
            return this.isCoppaComplianceEnabled;
        }

        public function getIsSendingInBackgroundEnabled():Boolean {
            return this.isSendingInBackgroundEnabled;
        }

        public function getIsDeferredDeeplinkOpeningEnabled():Boolean {
            return this.isDeferredDeeplinkOpeningEnabled;
        }

        public function getIsCostDataInAttributionEnabled():Boolean {
            return this.isCostDataInAttributionEnabled;
        }

        public function getIsDeviceIdsReadingOnceEnabled():Boolean {
            return this.isDeviceIdsReadingOnceEnabled;
        }

        public function getUrlStrategyDomains():Array {
            return this.urlStrategyDomains;
        }

        public function getIsDataResidency():Object {
            return this.isDataResidency;
        }

        public function getUseSubdomains():Object {
            return this.useSubdomains;
        }

        public function getEventDedupliactionIdsMaxSize():int {
            return this.eventDeduplicationIdsMaxSize;
        }

        public function getAttributionCallback():Function {
            return this.attributionCallback;
        }

        public function getEventSuccessCallback():Function {
            return this.eventSuccessCallback;
        }

        public function getEventFailureCallback():Function {
            return this.eventFailureCallback;
        }

        public function getSessionSuccessCallback():Function {
            return this.sessionSuccessCallback;
        }

        public function getSessionFailureCallback():Function {
            return this.sessionFailureCallback;
        }

        public function getDeferredDeeplinkCallback():Function {
            return this.deferredDeeplinkCallback;
        }

        // android only getters

        public function getFbAppId():String {
            return this.fbAppId;
        }

        public function getProcessName():String {
            return this.processName;
        }

        public function getPreinstallFilePath():String {
            return this.preinstallFilePath;
        }

        public function getIsPlayStoreKidsComplianceEnabled():Boolean {
            return this.isPlayStoreKidsComplianceEnabled;
        }

        public function getIsPreinstallTrackingEnabled():Boolean {
            return this.isPreinstallTrackingEnabled;
        }

        // ios only getters

        public function getIsLinkMeEnabled():Boolean {
            return this.isLinkMeEnabled;
        }

        public function getIsAdServicesEnabled():Boolean {
            return this.isAdServicesEnabled;
        }

        public function getIsIdfaReadingEnabled():Boolean {
            return this.isIdfaReadingEnabled;
        }

        public function getIsIdfvReadingEnabled():Boolean {
            return this.isIdfvReadingEnabled;
        }

        public function getIsSkanAttributionEnabled():Boolean {
            return this.isSkanAttributionEnabled;
        }

        public function getAttConsentWaitingInterval():int {
            return this.attConsentWaitingInterval;
        }

        public function getSkanUpdatedCallback():Function {
            return this.skanUpdatedCallback;
        }
    }
}
