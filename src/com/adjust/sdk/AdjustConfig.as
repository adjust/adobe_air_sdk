package com.adjust.sdk {
    public class AdjustConfig {
        // For iOS & Android
        private var delayStart:Number;

        private var appToken:String;
        private var logLevel:String;
        private var userAgent:String;
        private var environment:String;
        private var defaultTracker:String;

        private var sendInBackground:Boolean;
        private var shouldLaunchDeeplink:Boolean;
        private var eventBufferingEnabled:Boolean;

        private var attributionCallbackDelegate:Function;
        private var eventTrackingSucceededDelegate:Function;
        private var eventTrackingFailedDelegate:Function;
        private var sessionTrackingSucceededDelegate:Function;
        private var sessionTrackingFailedDelegate:Function;
        private var deferredDeeplinkDelegate:Function;

        // For Android only
        private var referrer:String;
        private var processName:String;

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
    }
}
