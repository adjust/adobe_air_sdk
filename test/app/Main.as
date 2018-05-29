package {
    import com.adjust.sdk.Adjust;
    import com.adjust.test.AdjustTest;

    import flash.display.Sprite;
    import flash.system.Capabilities;

    public class Main extends Sprite {
        private static var commandExecutor:CommandExecutor;

        public function Main() {
            // For Android testing: Make sure to use HTTPS with port 8443 with a physical device
            // For iOS testing: Make sure to use HTTP with port 8080 with a physical device
            var baseUrl:String = 'https://192.168.8.31:8443';
            //var baseUrl:String = 'http://192.168.8.35:8080';

            commandExecutor = new CommandExecutor(baseUrl);

            // AdjustTest.addTestDirectory("current/offlineMode/");
            // AdjustTest.addTest("current/sendInBackground/Test_SendInBackground_send_true");
            AdjustTest.startTestSession(baseUrl, testingCommandCallbackDelegate);

            trace('[AdjustTest][AS3]: HERE I AM!');
            trace('[AdjustTest][AS3]: HERE I AM!');
            trace('[AdjustTest][AS3]: HERE I AM!');
            trace('[AdjustTest][AS3]: HERE I AM!');
            trace('[AdjustTest][AS3]: HERE I AM!');
            trace('[AdjustTest][AS3]: HERE I AM!');
        }

        private static function testingCommandCallbackDelegate(json:String):void {
            var data:Object         = JSON.parse(json);

            var className:String    = data.className;
            var functionName:String = data.functionName;
            var params:Object       = data.params;
            var order:int           = parseInt(data.order);

            trace('AS3>> className: ' + className);
            trace('AS3>> functionName: ' + functionName);
            trace('AS3>> params: ' + params);
            trace('AS3>> order: ' + order);

            commandExecutor.scheduleCommand(className, functionName, params, order);
        }
    }
}
