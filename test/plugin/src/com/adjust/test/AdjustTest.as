package com.adjust.test {
    import flash.desktop.NativeApplication;
    import flash.events.*;
    import flash.external.ExtensionContext;

    public class AdjustTest extends EventDispatcher {
        private static var mExtensionContext:ExtensionContext = null;
        private static var mTestCommandCallback:Function;

        private static function getExtensionContext():ExtensionContext {
            if (mExtensionContext != null) {
                return mExtensionContext;
            }
            return mExtensionContext = ExtensionContext.createExtensionContext("com.adjust.test", null);
        }

        public static function startTestSession(baseUrl:String, controlUrl:String, clientSdk:String, testCommandCallback:Function):void {
            trace("[AdjustTest]: 'startTestSession' invoked!");
            trace("[AdjustTest]: 'baseUrl' = " + baseUrl);
            trace("[AdjustTest]: 'controlUrl' = " + controlUrl);
            trace("[AdjustTest]: 'clientSdk' = " + clientSdk);
            mTestCommandCallback = testCommandCallback;
            getExtensionContext().addEventListener(StatusEvent.STATUS, extensionResponseCallback);
            getExtensionContext().call("startTestSession", baseUrl, controlUrl, clientSdk);
        }

        public static function addInfoToSend(key:String, value:String):void {
            trace("[AdjustTest]: 'addInfoToSend' invoked!");
            trace("[AdjustTest]: 'key' = " + key);
            trace("[AdjustTest]: 'value' = " + value);
            if ("null" != value) {
                getExtensionContext().call("addInfoToSend", key, value);
            } else {
                getExtensionContext().call("addInfoToSend", key, null);
            }
        }

        public static function sendInfoToServer(basePath:String):void {
            trace("[AdjustTest]: 'sendInfoToServer' invoked!");
            trace("[AdjustTest]: 'basePath' = " + basePath);
            getExtensionContext().call("sendInfoToServer", basePath);
        }

        public static function addTest(testToAdd:String):void {
            trace("[AdjustTest]: 'addTest' invoked!");
            trace("[AdjustTest]: 'testToAdd' = " + testToAdd);
            getExtensionContext().call("addTest", testToAdd);
        }

        public static function addTestDirectory(testDirToAdd:String):void {
            trace("[AdjustTest]: 'addTestDirectory' invoked!");
            trace("[AdjustTest]: 'testDirToAdd' = " + testDirToAdd);
            getExtensionContext().call("addTestDirectory", testDirToAdd);
        }

        private static function extensionResponseCallback(statusEvent:StatusEvent):void {
            trace("[AdjustTest]: Received event!");
            trace("[AdjustTest]: 'statusEvent' = " + statusEvent)
            trace("[AdjustTest]: 'statusEvent.level' = " + statusEvent.level)
            if (statusEvent.code == "adjust_test_command") {
                mTestCommandCallback(statusEvent.level);
            }
        }
    }
}
