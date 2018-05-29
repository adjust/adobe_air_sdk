package com.adjust.test {
    import flash.desktop.NativeApplication;
    import flash.events.*;
    import flash.external.ExtensionContext;

    public class AdjustTest extends EventDispatcher {
        private static var mExtensionContext:ExtensionContext = null;
        private static var mTestingCommandCallbackDelegate:Function;

        private static function getExtensionContext():ExtensionContext {
            if (mExtensionContext != null) {
                return mExtensionContext;
            }

            return mExtensionContext = ExtensionContext.createExtensionContext("com.adjust.test", null);
        }

        public static function startTestSession(baseUrl:String, testingCommandCallbackDelegate:Function):void {
            mTestingCommandCallbackDelegate = testingCommandCallbackDelegate;
            getExtensionContext().addEventListener(StatusEvent.STATUS, extensionResponseDelegate);

            getExtensionContext().call("startTestSession", baseUrl);
        }

        public static function addInfoToSend(key:String, value:String):void {
            if ("null" != value) {
                getExtensionContext().call("addInfoToSend", key, value);
            } else {
                getExtensionContext().call("addInfoToSend", key, null);
            }
        }

        public static function sendInfoToServer(basePath:String):void {
            getExtensionContext().call("sendInfoToServer", basePath);
        }

        public static function addTest(testToAdd:String):void {
            getExtensionContext().call("addTest", testToAdd);
        }

        public static function addTestDirectory(testDirToAdd:String):void {
            getExtensionContext().call("addTestDirectory", testDirToAdd);
        }

        private static function extensionResponseDelegate(statusEvent:StatusEvent):void {
            trace("Receiving event: ");
            trace(statusEvent)
            trace(statusEvent.level)

            if (statusEvent.code == "adjusttesting_command") {
                mTestingCommandCallbackDelegate(statusEvent.level);
            }
        }
    }
}
