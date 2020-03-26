package com.adjust.sdk {
    public class AdjustTestOptions {
        public var teardown:Boolean = false;
        public var hasContext:Boolean = false;
        public var noBackoffWait:Boolean = false;
        public var tryInstallReferrer:Boolean = false;
        public var useTestConnectionOptions:Boolean = false;
        public var iAdFrameworkEnabled:Boolean = false;

        public var baseUrl:String = null;
        public var gdprUrl:String = null;
        public var basePath:String = null;
        public var gdprPath:String = null;
        public var timerStartInMilliseconds:String = null;
        public var timerIntervalInMilliseconds:String = null;
        public var sessionIntervalInMilliseconds:String = null;
        public var subsessionIntervalInMilliseconds:String = null;
    }
}
