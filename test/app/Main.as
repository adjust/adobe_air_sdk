package {
    import com.adjust.sdk.Adjust;
    import com.adjust.test.AdjustTest;

    import flash.display.Sprite;
    import flash.system.Capabilities;

    public class Main extends Sprite {
        // Android: Make sure to use HTTPS with port 8443 with a physical device.
        // iOS: Make sure to use HTTP with port 8080 with a physical device.
        public static var ipAddress:String = '192.168.86.28';
        public static var baseUrl:String = 'http://' + ipAddress + ':8080';
        public static var gdprUrl:String = 'http://' + ipAddress + ':8080';
        public static var controlUrl:String = 'ws://' + ipAddress + ':1987';

        private static var commandExecutor:CommandExecutor;

        public function Main() {
            commandExecutor = new CommandExecutor(baseUrl);
            trace('[ADJUST][TEST-APP]: Starting Adjust test application session!');
            AdjustTest.startTestSession(baseUrl, controlUrl, Adjust.getSdkVersion(), testCommandCallbackDelegate);
        }

        private static function testCommandCallbackDelegate(json:String):void {
            var data:Object = JSON.parse(json);
            var className:String = data.className;
            var functionName:String = data.functionName;
            var params:Object = data.params;
            var order:int = parseInt(data.order);

            trace('[ADJUST][TEST-APP]: Test command callback invoked!');
            trace('[ADJUST][TEST-APP]: className: ' + className);
            trace('[ADJUST][TEST-APP]: functionName: ' + functionName);
            trace('[ADJUST][TEST-APP]: params: ' + params);
            trace('[ADJUST][TEST-APP]: order: ' + order);

            commandExecutor.scheduleCommand(className, functionName, params, order);
        }
    }
}
