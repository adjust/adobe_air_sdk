package com.adjust.sdk {
    public class AdjustConfig {
        private var delayStart:Number;

        private var appToken:String;
        private var logLevel:String;
        private var userAgent:String;
        private var environment:String;
        private var defaultTracker:String;
        private var externalDeviceId:String;

        private var sendInBackground:Boolean;
        private var shouldLaunchDeeplink:Boolean;
        private var eventBufferingEnabled:Boolean;
        private var isDeviceKnown:Boolean;

        private var attributionCallbackDelegate:Function;
        private var eventTrackingSucceededDelegate:Function;
        private var eventTrackingFailedDelegate:Function;
        private var sessionTrackingSucceededDelegate:Function;
        private var sessionTrackingFailedDelegate:Function;
        private var deferredDeeplinkDelegate:Function;

        private var secretId:String;
        private var info1:String;
        private var info2:String;
        private var info3:String;
        private var info4:String;

        // Android only
        private var processName:String;
        private var readMobileEquipmentIdentity:Boolean;

        // iOS only
        private var allowiAdInfoReading:Boolean;
        private var allowIdfaReading:Boolean;

        public function AdjustConfig(appToken:String, environment:String) {
            this.appToken = appToken;
            this.environment = environment;
        }

        public function setLogLevel(logLevel:String):void {
            this.logLevel = logLevel;
        }

        public function setEventBufferingEnabled(eventBufferingEnabled:Boolean):void {
            this.eventBufferingEnabled = eventBufferingEnabled;
        }

        public function setDelayStart(delayStart:Number):void {
            this.delayStart = delayStart;
        }

        public function setUserAgent(userAgent:String):void {
            this.userAgent = userAgent;
        }

        public function setSendInBackground(sendInBackground:Boolean):void {
            this.sendInBackground = sendInBackground;
        }

        public function setDefaultTracker(defaultTracker:String):void {
            this.defaultTracker = defaultTracker;
        }

        public function setExternalDeviceId(externalDeviceId:String):void {
            this.externalDeviceId = externalDeviceId;
        }

        public function setProcessName(processName:String):void {
            this.processName = processName;
        }

        public function setAttributionCallbackDelegate(attributionCallback:Function):void {
            this.attributionCallbackDelegate = attributionCallback;
        }

        public function setEventTrackingSucceededDelegate(eventTrackingSucceededDelegate:Function):void {
            this.eventTrackingSucceededDelegate = eventTrackingSucceededDelegate;
        }

        public function setEventTrackingFailedDelegate(eventTrackingFailedDelegate:Function):void {
            this.eventTrackingFailedDelegate = eventTrackingFailedDelegate;
        }

        public function setSessionTrackingSucceededDelegate(sessionTrackingSucceededDelegate:Function):void {
            this.sessionTrackingSucceededDelegate = sessionTrackingSucceededDelegate;
        }

        public function setSessionTrackingFailedDelegate(sessionTrackingFailedDelegate:Function):void {
            this.sessionTrackingFailedDelegate = sessionTrackingFailedDelegate;
        }

        public function setDeferredDeeplinkDelegate(deferredDeeplinkDelegate:Function):void {
            this.deferredDeeplinkDelegate = deferredDeeplinkDelegate;
        }

        public function setShouldLaunchDeeplink(shouldLaunchDeeplink:Boolean):void {
            this.shouldLaunchDeeplink = shouldLaunchDeeplink;
        }

        public function setAppSecret(secretId:Number, info1:Number, info2:Number, info3:Number, info4:Number):void {
            if (!isNaN(secretId)) {
                this.secretId = secretId.toString();
            }

            if (!isNaN(info1)) {
                this.info1 = info1.toString();
            }

            if (!isNaN(info2)) {
                this.info2 = info2.toString();
            }

            if (!isNaN(info3)) {
                this.info3 = info3.toString();
            }

            if (!isNaN(info4)) {
                this.info4 = info4.toString();
            }
        }

        public function setDeviceKnown(isDeviceKnown:Boolean):void {
            this.isDeviceKnown = isDeviceKnown;
        }

        public function setReadMobileEquipmentIdentity(readMobileEquipmentIdentity:Boolean):void {
            this.readMobileEquipmentIdentity = readMobileEquipmentIdentity;
        }

        public function setAllowiAdInfoReading(allowiAdInfoReading:Boolean):void {
            this.allowiAdInfoReading = allowiAdInfoReading;
        }

        public function setAllowIdfaReading(allowIdfaReading:Boolean):void {
            this.allowIdfaReading = allowIdfaReading;
        }

        // Getters
        public function getAppToken():String {
            return this.appToken;
        }

        public function getEnvironment():String {
            return this.environment;
        }

        public function getLogLevel():String {
            return this.logLevel;
        }

        public function getEventBufferingEnabled():Boolean {
            return this.eventBufferingEnabled;
        }

        public function getDelayStart():Number {
            return this.delayStart;
        }

        public function getUserAgent():String {
            return this.userAgent;
        }

        public function getSendInBackground():Boolean {
            return this.sendInBackground;
        }

        public function getDefaultTracker():String {
            return this.defaultTracker;
        }

        public function getExternalDeviceId():String {
            return this.externalDeviceId;
        }

        public function getProcessName():String {
            return this.processName;
        }

        public function getAttributionCallbackDelegate():Function {
            return this.attributionCallbackDelegate;
        }

        public function getEventTrackingSucceededDelegate():Function {
            return this.eventTrackingSucceededDelegate;
        }

        public function getEventTrackingFailedDelegate():Function {
            return this.eventTrackingFailedDelegate;
        }

        public function getSessionTrackingSucceededDelegate():Function {
            return this.sessionTrackingSucceededDelegate;
        }

        public function getSessionTrackingFailedDelegate():Function {
            return this.sessionTrackingFailedDelegate;
        }

        public function getDeferredDeeplinkDelegate():Function {
            return this.deferredDeeplinkDelegate;
        }

        public function getShouldLaunchDeeplink():Boolean {
            return this.shouldLaunchDeeplink;
        }

        public function getSecretId():String {
            return this.secretId;
        }

        public function getInfo1():String {
            return this.info1;
        }

        public function getInfo2():String {
            return this.info2;
        }

        public function getInfo3():String {
            return this.info3;
        }

        public function getInfo4():String {
            return this.info4;
        }

        public function getIsDeviceKnown():Boolean {
            return this.isDeviceKnown;
        }

        public function getReadMobileEquipmentIdentity():Boolean {
            return this.readMobileEquipmentIdentity;
        }

        public function getAllowiAdInfoReading():Boolean {
            return this.allowiAdInfoReading;
        }

        public function getAllowIdfaReading():Boolean {
            return this.allowIdfaReading;
        }
    }
}
