package {
    import com.adjust.sdk.Adjust;
    import com.adjust.sdk.AdjustConfig;
    import com.adjust.sdk.AdjustThirdPartySharing;
    import com.adjust.sdk.Environment;
    import com.adjust.sdk.LogLevel;
    import com.adjust.test.AdjustTest;

    import flash.display.Sprite;
    import flash.system.Capabilities;

    public class Main extends Sprite {
        // Android: Make sure to use HTTPS with port 8443 with a physical device.
        // iOS: Make sure to use HTTP with port 8080 with a physical device.
        public static var ipAddress:String = '192.168.86.126';
        public static var baseUrl:String = 'http://' + ipAddress + ':8080';
        public static var gdprUrl:String = 'http://' + ipAddress + ':8080';
        public static var controlUrl:String = 'ws://' + ipAddress + ':1987';

        private static var commandExecutor:CommandExecutor;

        public function Main() {
            commandExecutor = new CommandExecutor(baseUrl);
            trace('[ADJUST][TEST-APP]: Starting Adjust test application session!');
            Adjust.getSdkVersion(function (sdkVersion:String):void {
                // AdjustTest.addTestDirectory("ad-revenue");
                // AdjustTest.addTestDirectory("attribution-callback");
                // AdjustTest.addTestDirectory("attribution-getter");
                // AdjustTest.addTestDirectory("attribution-initiated-by");
                // AdjustTest.addTestDirectory("continue-in");
                // AdjustTest.addTestDirectory("coppa");
                // AdjustTest.addTestDirectory("deeplink");
                // AdjustTest.addTestDirectory("deeplink-deferred");
                // AdjustTest.addTestDirectory("deeplink-getter");
                // AdjustTest.addTestDirectory("default-tracker");
                // AdjustTest.addTestDirectory("disable-enable");
                // AdjustTest.addTestDirectory("error-responses");
                // AdjustTest.addTestDirectory("event-callbacks");
                // AdjustTest.addTestDirectory("event-tracking");
                // AdjustTest.addTestDirectory("exernal-device-id");
                // AdjustTest.addTestDirectory("gdpr");
                // AdjustTest.addTestDirectory("global-parameters");
                // AdjustTest.addTestDirectory("google-kids");
                // AdjustTest.addTestDirectory("init-malformed");
                // AdjustTest.addTestDirectory("lifecycle");
                // AdjustTest.addTestDirectory("link-shortener");
                // AdjustTest.addTestDirectory("measurement-consent");
                // AdjustTest.addTestDirectory("offline-mode");
                // AdjustTest.addTestDirectory("parameters");
                // AdjustTest.addTestDirectory("purchase-verification");
                // AdjustTest.addTestDirectory("push-token");
                // AdjustTest.addTestDirectory("queue-size");
                // AdjustTest.addTestDirectory("retry-in");
                // AdjustTest.addTestDirectory("sdk-prefix");
                // AdjustTest.addTestDirectory("send-in-background");
                // AdjustTest.addTestDirectory("session-callbacks");
                // AdjustTest.addTestDirectory("session-count");
                // AdjustTest.addTestDirectory("subscription");
                // AdjustTest.addTestDirectory("third-party-sharing");
                // AdjustTest.addTestDirectory("verify-track");
                AdjustTest.startTestSession(baseUrl, controlUrl, sdkVersion, testCommandCallbackDelegate);
            });
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
