package com.adjust.sdk {
    public class AdjustConfig {
        // For iOS & Android
        private var appToken:String;
        private var environment:String;
        private var logLevel:String;
        private var attributionCallbackDelegate: Function;
        private var eventBufferingEnabled:Boolean;
        private var defaultTracker:String;

        // iOS specific
        private var macMd5TrackingEnabled:Boolean;

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

        public function setAttributionCallbackDelegate(attributionCallback:Function):void {
            this.attributionCallbackDelegate = attributionCallback;
        }

        public function setDefaultTracker(defaultTracker:String):void {
            this.defaultTracker = defaultTracker;
        }

        public function setMacMd5TrackingEnabled(macMd5TrackingEnabled:Boolean):void {
            this.macMd5TrackingEnabled = macMd5TrackingEnabled;
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

        public function getAttributionCallbackDelegate():Function {
            return this.attributionCallbackDelegate;
        }

        public function getDefaultTracker():String {
            return this.defaultTracker;
        }

        public function getMacMd5TrackingEnabled():Boolean {
            return this.macMd5TrackingEnabled;
        }
    }
}
