package {
    import com.adjust.sdk.Adjust;
    import com.adjust.test.AdjustTest;

    import flash.display.Sprite;
    import flash.system.Capabilities;

    public class Main extends Sprite {
        // For Android testing: Make sure to use HTTPS with port 8443 with a physical device
        // For iOS testing: Make sure to use HTTP with port 8080 with a physical device
        public static var baseUrl:String = 'https://192.168.8.50:8443';
        public static var gdprUrl:String = 'https://192.168.8.50:8443';

        private static var commandExecutor:CommandExecutor;

        public function Main() {
            commandExecutor = new CommandExecutor(baseUrl);

            // AdjustTest.addTestDirectory("current/gdpr/");
            // AdjustTest.addTest("current/gdpr/Test_GdprForgetMe_after_install");
            AdjustTest.startTestSession(baseUrl, testingCommandCallbackDelegate);
        }

        private static function testingCommandCallbackDelegate(json:String):void {
            var data:Object = JSON.parse(json);
            var className:String = data.className;
            var functionName:String = data.functionName;
            var params:Object = data.params;
            var order:int = parseInt(data.order);

            trace('[ADJUST][TEST] className: ' + className);
            trace('[ADJUST][TEST] functionName: ' + functionName);
            trace('[ADJUST][TEST] params: ' + params);
            trace('[ADJUST][TEST] order: ' + order);

            commandExecutor.scheduleCommand(className, functionName, params, order);
        }
    }
}
