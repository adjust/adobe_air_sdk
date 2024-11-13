package {
    import com.adjust.sdk.Adjust;
    import com.adjust.sdk.AdjustConfig;
    import com.adjust.sdk.AdjustEvent;
    import com.adjust.sdk.AdjustEventSuccess;
    import com.adjust.sdk.AdjustEventFailure;
    import com.adjust.sdk.AdjustSessionSuccess;
    import com.adjust.sdk.AdjustSessionFailure;
    import com.adjust.sdk.AdjustAttribution;
    import com.adjust.sdk.AdjustEnvironment;
    import com.adjust.sdk.AdjustLogLevel;

    import flash.display.SimpleButton;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.system.Capabilities;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;

    public class Main extends Sprite {
        private static var IsEnabledTextField:TextField;
        private static var DeviceIdTextField:TextField;

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
            DeviceIdTextField = buildButton(6, "Get IDs", GetIDs);

            // -------- Adjust Configuration -------- //
            var adjustConfig:AdjustConfig = new AdjustConfig("2fm9gkqubvpc", AdjustEnvironment.SANDBOX);
            adjustConfig.setLogLevel(AdjustLogLevel.VERBOSE);

            adjustConfig.setAttributionCallback(function (attribution:AdjustAttribution): void {
                trace("Tracker token = " + attribution.getTrackerToken());
                trace("Tracker name = " + attribution.getTrackerName());
                trace("Campaign = " + attribution.getCampaign());
                trace("Network = " + attribution.getNetwork());
                trace("Creative = " + attribution.getCreative());
                trace("Adgroup = " + attribution.getAdgroup());
                trace("Click label = " + attribution.getClickLabel());
                trace("Cost type = " + attribution.getCostType());
                trace("Cost amount = " + isNaN(attribution.getCostAmount()) ? "NaN" : attribution.getCostAmount().toString());
                trace("Cost currency = " + attribution.getCostCurrency());
                trace("FB install referrer = " + attribution.getFbInstallReferrer());
            });
            adjustConfig.setEventSuccessCallback(function (eventSuccess:AdjustEventSuccess):void {
                trace("Event tracking succeeded");
                trace("Message = " + eventSuccess.getMessage());
                trace("Timestamp = " + eventSuccess.getTimestamp());
                trace("Adid = " + eventSuccess.getAdid());
                trace("Event Token = " + eventSuccess.getEventToken());
                trace("Callback Id = " + eventSuccess.getCallbackId());
                trace("Json Response = " + eventSuccess.getJsonResponse());
            });
            adjustConfig.setEventFailureCallback(function (eventFailure:AdjustEventFailure):void {
                trace("Event tracking failed");
                trace("Message = " + eventFailure.getMessage());
                trace("Timestamp = " + eventFailure.getTimestamp());
                trace("Adid = " + eventFailure.getAdid());
                trace("Event Token = " + eventFailure.getEventToken());
                trace("Callback Id = " + eventFailure.getCallbackId());
                trace("Will Retry = " + eventFailure.getWillRetry().toString());
                trace("Json Response = " + eventFailure.getJsonResponse());
            });
            adjustConfig.setSessionSuccessCallback(function (sessionSuccess:AdjustSessionSuccess): void {
                trace("Session tracking succeeded");
                trace("Message = " + sessionSuccess.getMessage());
                trace("Timestamp = " + sessionSuccess.getTimestamp());
                trace("Adid = " + sessionSuccess.getAdid());
                trace("Json Response = " + sessionSuccess.getJsonResponse());
            });
            adjustConfig.setSessionFailureCallback(function (sessionFailure:AdjustSessionFailure):void {
                trace("Session tracking failed");
                trace("Message = " + sessionFailure.getMessage());
                trace("Timestamp = " + sessionFailure.getTimestamp());
                trace("Adid = " + sessionFailure.getAdid());
                trace("Will Retry = " + sessionFailure.getWillRetry().toString());
                trace("Json Response = " + sessionFailure.getJsonResponse());
            });
            adjustConfig.setDeferredDeeplinkCallback(function (deeplink:String):void {
                trace("Received deferred deep link");
                trace("Deep link = " + deeplink);
            });

            Adjust.addGlobalCallbackParameter("scpk1", "scpv1");
            Adjust.addGlobalCallbackParameter("scpk2", "scpv2");

            Adjust.addGlobalPartnerParameter("sppk1", "sppv1");
            Adjust.addGlobalPartnerParameter("sppk2", "sppv2");

            Adjust.removeGlobalCallbackParameter("scpk1");
            Adjust.removeGlobalPartnerParameter("sppk2");

            Adjust.initSdk(adjustConfig);

            // -------- Adjust Configuration -------- //
        }

        private static function TrackEventClick(Event:MouseEvent):void {
            trace ("Track simple event button tapped!");

            var adjustEvent:AdjustEvent = new AdjustEvent("g3mfiw");

            Adjust.trackEvent(adjustEvent);
        }

        private static function TrackRevenueClick(Event:MouseEvent):void {
            trace ("Track revenue event button tapped!");

            var adjustEvent:AdjustEvent = new AdjustEvent("a4fd35");
            adjustEvent.setRevenue(0.01, "EUR");

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
            Adjust.switchToOfflineMode();
        }

        private static function DisableOfflineModeClick(Event:MouseEvent):void {
            Adjust.switchBackToOnlineMode();
        }

        private static function SetEnableClick(Event:MouseEvent):void {
            Adjust.enable();
        }

        private static function SetDisableClick(Event:MouseEvent):void {
            Adjust.disable();
        }

        private static function IsEnabledClick(Event:MouseEvent):void {
            Adjust.isEnabled(function (isEnabled:Boolean): void {
                if (isEnabled) {
                    IsEnabledTextField.text = "Is enabled? TRUE";
                } else {
                    IsEnabledTextField.text = "Is enabled? FALSE";
                }
            });
        }

        private static function GetIDs(Event:MouseEvent):void {
            trace ("Get IDs button tapped");

            Adjust.getAdid(function (adid:String): void {
                GetIDs.text = "Adid = " + adid;
            });
            /*
            Adjust.getIdfa(function (idfa:String): void {
                trace("IDFA = " + idfa);
            });
            Adjust.getIdfv(function (idfv:String): void {
                trace("IDFV = " + idfv);
            });
            Adjust.getAmazonAdId(function (amazonAdId:String): void {
                trace("Amazon Ad ID = " + amazonAdId);
            });
            Adjust.getGoogleAdId(function (googleAdId:String): void {
                trace("Google Ad ID = " + googleAdId);
            });
            Adjust.getAttribution(function (attribution:AdjustAttribution): void {
                trace("Tracker token = " + attribution.getTrackerToken());
                trace("Tracker name = " + attribution.getTrackerName());
                trace("Campaign = " + attribution.getCampaign());
                trace("Network = " + attribution.getNetwork());
                trace("Creative = " + attribution.getCreative());
                trace("Adgroup = " + attribution.getAdgroup());
                trace("Click label = " + attribution.getClickLabel());
                trace("Cost type = " + attribution.getCostType());
                trace("Cost amount = " + isNaN(attribution.getCostAmount()) ? "NaN" : attribution.getCostAmount().toString());
                trace("Cost currency = " + attribution.getCostCurrency());
                trace("FB install referrer = " + attribution.getFbInstallReferrer());
            });
            */
        }

        private function buildButton(number:int, text:String, clickFunction:Function):TextField {
            var buttonHeight:int = 40;
            var yPosition:int = 20 + stage.stageHeight * 0.25 +
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
            buttonSprite.graphics.drawRect((stage.stageWidth - 400) * 0.5, yPosition, 400, buttonHeight);
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
