package com.adjust.test {
    import flash.events.*;

    public class AdjustTest extends EventDispatcher {
        public static function startTestSession(baseUrl:String, controlUrl:String, clientSdk:String, testingCommandCallbackDelegate:Function):void {
            trace("adjust_testing: startTestSession called");
        }

        public static function addInfoToSend(key:String, value:String):void {
            trace("adjust_testing: addInfoToSend called");
        }

        public static function sendInfoToServer(basePath:String):void {
            trace("adjust_testing: sendInfoToServer called");
        }

        public static function addTest(testToAdd:String):void {
            trace("adjust_testing: addTest called");
        }

        public static function addTestDirectory(testDirToAdd:String):void {
            trace("adjust_testing: addTestDirectory called");
        }
    }
}
