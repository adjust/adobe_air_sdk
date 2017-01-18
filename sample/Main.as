package {
    import com.adjust.sdk.Adjust;
    import com.adjust.sdk.AdjustConfig;
    import com.adjust.sdk.AdjustEvent;
    import com.adjust.sdk.AdjustEventSuccess;
    import com.adjust.sdk.AdjustEventFailure;
    import com.adjust.sdk.AdjustSessionSuccess;
    import com.adjust.sdk.AdjustSessionFailure;
    import com.adjust.sdk.AdjustAttribution;
    import com.adjust.sdk.Environment;
    import com.adjust.sdk.LogLevel;

    import flash.display.SimpleButton;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.system.Capabilities;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;

    public class Main extends Sprite {
        private static var IsEnabledTextField:TextField;

        public function Main() {
            buildButton(-4, "Track Simple Event", TrackEventClick);
            buildButton(-3, "Track Revenue Event", TrackRevenueClick);
            buildButton(-2, "Track Callback Event", TrackCallbackClick);
            buildButton(-1, "Track Partner Event", TrackPartnerClick);
            buildButton(1, "Enable Offline Mode", EnableOfflineModeClick);
            buildButton(2, "Disable Offline Mode", DisableOfflineModeClick);
            buildButton(3, "Enable SDK", SetEnableClick);
            buildButton(4, "Disable SDK", SetDisableClick);

            IsEnabledTextField = buildButton(5, "Is SDK Enabled?", IsEnabledClick);

            // -------- Adjust Configuration -------- //
            var adjustConfig:AdjustConfig = new AdjustConfig("2fm9gkqubvpc", Environment.SANDBOX);

            adjustConfig.setAttributionCallbackDelegate(attributionCallbackDelegate);
            adjustConfig.setEventTrackingSucceededDelegate(eventTrackingSucceededDelegate);
            adjustConfig.setEventTrackingFailedDelegate(eventTrackingFailedDelegate);
            adjustConfig.setSessionTrackingSucceededDelegate(sessionTrackingSucceededDelegate);
            adjustConfig.setSessionTrackingFailedDelegate(sessionTrackingFailedDelegate);
            adjustConfig.setDeferredDeeplinkDelegate(deferredDeeplinkDelegate);
            adjustConfig.setShouldLaunchDeeplink(true);
            adjustConfig.setLogLevel(LogLevel.VERBOSE);

            Adjust.addSessionCallbackParameter("dummy_foo", "dummy_bar");
            Adjust.addSessionCallbackParameter("dummy_foo_foo", "dummy_bar");

            Adjust.addSessionPartnerParameter("dummy_foo", "dummy_bar");
            Adjust.addSessionPartnerParameter("dummy_foo_foo", "dummy_bar");

            Adjust.removeSessionCallbackParameter("dummy_foo");
            Adjust.removeSessionPartnerParameter("dummy_foo");

            //Adjust.resetSessionCallbackParameters();
            //Adjust.resetSessionPartnerParameters();

            adjustConfig.setDelayStart(3.0);
            adjustConfig.setUserAgent("little_bunny_foo_foo");
            adjustConfig.setSendInBackground(true);

            Adjust.setDeviceToken("dummy_token_1");

            Adjust.start(adjustConfig);

            Adjust.setDeviceToken("bunny_foo_foo");
            Adjust.sendFirstPackages();

            // -------- Adjust Configuration -------- //
        }

        private static function TrackEventClick(Event:MouseEvent):void {
            trace ("Track simple event button tapped!");

            var adjustEvent:AdjustEvent = new AdjustEvent("g3mfiw");

            Adjust.trackEvent(adjustEvent);

            trace("Adid = " + Adjust.getAdid());

            var attribution:AdjustAttribution = Adjust.getAttribution();

            trace("Tracker token = " + attribution.getTrackerToken());
            trace("Tracker name = " + attribution.getTrackerName());
            trace("Campaign = " + attribution.getCampaign());
            trace("Network = " + attribution.getNetwork());
            trace("Creative = " + attribution.getCreative());
            trace("Adgroup = " + attribution.getAdGroup());
            trace("Click label = " + attribution.getClickLabel());
            trace("Adid = " + attribution.getAdid());
        }

        private static function TrackRevenueClick(Event:MouseEvent):void {
            trace ("Track revenue event button tapped!");

            var adjustEvent:AdjustEvent = new AdjustEvent("a4fd35");
            adjustEvent.setRevenue(0.01, "EUR");
            adjustEvent.setTransactionId("dummy_id");

            Adjust.trackEvent(adjustEvent);
        }

        private static function TrackCallbackClick(Event:MouseEvent):void {
            trace ("Track callback event button tapped!");

            var adjustEvent:AdjustEvent = new AdjustEvent("34vgg9");

            adjustEvent.addCallbackParameter("foo", "bar");
            adjustEvent.addCallbackParameter("a", "b");
            adjustEvent.addCallbackParameter("foo", "c");

            Adjust.trackEvent(adjustEvent);
        }

        private static function TrackPartnerClick(Event:MouseEvent):void {
            trace ("Track partner event button tapped!");

            var adjustEvent:AdjustEvent = new AdjustEvent("w788qs");

            adjustEvent.addPartnerParameter("foo", "bar");
            adjustEvent.addPartnerParameter("x", "y");
            adjustEvent.addPartnerParameter("foo", "z");

            Adjust.trackEvent(adjustEvent);
        }

        private static function EnableOfflineModeClick(Event:MouseEvent):void {
            Adjust.setOfflineMode(true);
        }

        private static function DisableOfflineModeClick(Event:MouseEvent):void {
            Adjust.setOfflineMode(false);
        }

        private static function SetEnableClick(Event:MouseEvent):void {
            Adjust.setEnabled(true);
        }

        private static function SetDisableClick(Event:MouseEvent):void {
            Adjust.setEnabled(false);
        }

        private static function IsEnabledClick(Event:MouseEvent):void {
            var isEnabled:Boolean = Adjust.isEnabled();

            if (isEnabled) {
                IsEnabledTextField.text = "Is enabled? TRUE";
            } else {
                IsEnabledTextField.text = "Is enabled? FALSE";
            }
        }

        private static function attributionCallbackDelegate(attribution:AdjustAttribution):void {
            trace("Attribution changed!");
            trace("Tracker token = " + attribution.getTrackerToken());
            trace("Tracker name = " + attribution.getTrackerName());
            trace("Campaign = " + attribution.getCampaign());
            trace("Network = " + attribution.getNetwork());
            trace("Creative = " + attribution.getCreative());
            trace("Adgroup = " + attribution.getAdGroup());
            trace("Click label = " + attribution.getClickLabel());
            trace("Adid = " + attribution.getAdid());
        }

        private static function eventTrackingSucceededDelegate(eventSuccess:AdjustEventSuccess):void {
            trace("Event tracking succeeded");
            trace("Message = " + eventSuccess.getMessage());
            trace("Timestamp = " + eventSuccess.getTimeStamp());
            trace("Adid = " + eventSuccess.getAdid());
            trace("Event token = " + eventSuccess.getEventToken());
            trace("JSON Response = " + eventSuccess.getJsonResponse());
        }

        private static function eventTrackingFailedDelegate(eventFail:AdjustEventFailure):void {
            trace("Event tracking failed");
            trace("Message = " + eventFail.getMessage());
            trace("Timestamp = " + eventFail.getTimeStamp());
            trace("Adid = " + eventFail.getAdid());
            trace("Event token = " + eventFail.getEventToken());
            trace("Will retry = " + eventFail.getWillRetry());
            trace("JSON response = " + eventFail.getJsonResponse());
        }

        private static function sessionTrackingSucceededDelegate(sessionSuccess:AdjustSessionSuccess):void {
            trace("Session tracking succeeded");
            trace("Message = " + sessionSuccess.getMessage());
            trace("Timestamp = " + sessionSuccess.getTimeStamp());
            trace("Adid = " + sessionSuccess.getAdid());
            trace("JSON response = " + sessionSuccess.getJsonResponse());
        }

        private static function sessionTrackingFailedDelegate(sessionFail:AdjustSessionFailure):void {
            trace("Session tracking failed");
            trace("Message = " + sessionFail.getMessage());
            trace("Timestamp = " + sessionFail.getTimeStamp());
            trace("Adid = " + sessionFail.getAdid());
            trace("Will retry = " + sessionFail.getWillRetry());
            trace("JSON response = " + sessionFail.getJsonResponse());
        }

        private static function deferredDeeplinkDelegate(uri:String):void {
            trace("Received Deferred Deeplink");
            trace("URI = " + uri);
        }

        private function buildButton(number:int, text:String, clickFunction:Function):TextField {
            var buttonHeight:int = 40;
            var yPosition:int = 100 + stage.stageHeight * 0.25 +
                (number < 0 ? number * buttonHeight : (number - 1) * buttonHeight) + ((number != 1 && number != -1) ?
                        (number > 0 ? 20 * Math.abs(number) : -20 * Math.abs(number)) : number * 10);

            var textField:TextField = new TextField();
            textField.text = text;
            textField.autoSize = TextFieldAutoSize.CENTER;
            textField.mouseEnabled = false;
            textField.x = (stage.stageWidth - textField.width) * 0.5;
            textField.y = yPosition + 10;

            var buttonSprite:Sprite = new Sprite();
            buttonSprite.graphics.beginFill(0x82F0FF);
            buttonSprite.graphics.drawRect((stage.stageWidth - 250) * 0.5, yPosition, 250, buttonHeight);
            buttonSprite.graphics.endFill();
            buttonSprite.addChild(textField);

            var simpleButton:SimpleButton = new SimpleButton();
            simpleButton.downState = buttonSprite;
            simpleButton.upState = buttonSprite;
            simpleButton.overState = buttonSprite;
            simpleButton.hitTestState = buttonSprite;
            simpleButton.addEventListener(MouseEvent.CLICK, clickFunction);

            addChild(simpleButton);

            return textField;
        }
    }
}
