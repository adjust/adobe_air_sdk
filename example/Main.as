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
    import flash.text.TextFormat;
    import flash.text.TextFieldAutoSize;
    import flash.utils.Dictionary;

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
                var message:String = "Tracker token = " + attribution.getTrackerToken() + "\n" +
                                     "Tracker name = " + attribution.getTrackerName() + "\n" +
                                     "Campaign = " + attribution.getCampaign() + "\n" +
                                     "Network = " + attribution.getNetwork() + "\n" +
                                     "Creative = " + attribution.getCreative() + "\n" +
                                     "Adgroup = " + attribution.getAdgroup() + "\n" +
                                     "Click label = " + attribution.getClickLabel() + "\n" +
                                     "Cost type = " + attribution.getCostType() + "\n" +
                                     "Cost amount = " + (isNaN(attribution.getCostAmount()) ? "NaN" : attribution.getCostAmount().toString()) + "\n" +
                                     "Cost currency = " + attribution.getCostCurrency() + "\n" +
                                     "FB install referrer = " + attribution.getFbInstallReferrer();
                showCustomAlert(message, "Attribution Callback");
            });
            adjustConfig.setEventSuccessCallback(function (eventSuccess:AdjustEventSuccess):void {
                var message:String = "Event tracking succeeded\n" +
                                     "Message = " + eventSuccess.getMessage() + "\n" +
                                     "Timestamp = " + eventSuccess.getTimestamp() + "\n" +
                                     "Adid = " + eventSuccess.getAdid() + "\n" +
                                     "Event Token = " + eventSuccess.getEventToken() + "\n" +
                                     "Callback Id = " + eventSuccess.getCallbackId() + "\n" +
                                     "Json Response = " + eventSuccess.getJsonResponse();
                showCustomAlert(message, "Event Success Callback");
            });
            adjustConfig.setEventFailureCallback(function (eventFailure:AdjustEventFailure):void {
                var message:String = "Event tracking failed\n" +
                                     "Message = " + eventFailure.getMessage() + "\n" +
                                     "Timestamp = " + eventFailure.getTimestamp() + "\n" +
                                     "Adid = " + eventFailure.getAdid() + "\n" +
                                     "Event Token = " + eventFailure.getEventToken() + "\n" +
                                     "Callback Id = " + eventFailure.getCallbackId() + "\n" +
                                     "Will Retry = " + eventFailure.getWillRetry().toString() + "\n" +
                                     "Json Response = " + eventFailure.getJsonResponse();
                showCustomAlert(message, "Event Failure Callback");
            });
            adjustConfig.setSessionSuccessCallback(function (sessionSuccess:AdjustSessionSuccess): void {
                var message:String = "Session tracking succeeded\n" +
                                     "Message = " + sessionSuccess.getMessage() + "\n" +
                                     "Timestamp = " + sessionSuccess.getTimestamp() + "\n" +
                                     "Adid = " + sessionSuccess.getAdid() + "\n" +
                                     "Json Response = " + sessionSuccess.getJsonResponse();
                showCustomAlert(message, "Session Success Callback");
            });
            adjustConfig.setSessionFailureCallback(function (sessionFailure:AdjustSessionFailure):void {
                var message:String = "Session tracking failed\n" +
                                     "Message = " + sessionFailure.getMessage() + "\n" +
                                     "Timestamp = " + sessionFailure.getTimestamp() + "\n" +
                                     "Adid = " + sessionFailure.getAdid() + "\n" +
                                     "Will Retry = " + sessionFailure.getWillRetry().toString() + "\n" +
                                     "Json Response = " + sessionFailure.getJsonResponse();
                showCustomAlert(message, "Session Failure Callback");
            });
            adjustConfig.setDeferredDeeplinkCallback(function (deeplink:String):void {
                var message:String = "Received deferred deep link\n" +
                                     "Deep link = " + deeplink;
                showCustomAlert(message, "Deferred Deeplink Callback");
            });
            adjustConfig.setSkanUpdatedCallback(function (skanUpdatedData:Dictionary):void {
                var message:String = "SKAN values updated\n" +
                                     "Conversion value = " + skanUpdatedData["conversionValue"].toString() + "\n" +
                                     "Coarse value = " + skanUpdatedData["coarseValue"] + "\n" +
                                     "Lock window = " + skanUpdatedData["lockWindow"].toString() + "\n" +
                                     "Error = " + skanUpdatedData["error"];
                showCustomAlert(message, "SKAN Updated Callback");
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
            Adjust.getAdid(function (adid:String): void {
                trace("Adid = " + adid);
            });
            Adjust.getLastDeeplink(function (lastDeeplink:String): void {
                trace("Last deeplink = " + lastDeeplink);
            });
            Adjust.getIdfa(function (idfa:String): void {
                trace("IDFA = " + idfa);
            });
            Adjust.getIdfv(function (idfv:String): void {
                trace("IDFV = " + idfv);
            });
            Adjust.getAppTrackingStatus(function (status:String): void {
                trace("Authorization status = " + status);
            });
            Adjust.requestAppTrackingAuthorization(function (status:String): void {
                trace("Authorization status = " + status);
            });
            Adjust.updateSkanConversionValue(6, "low", false, function (error:String): void {
                trace("Error = " + error);
            });
            Adjust.getGoogleAdId(function (googleAdId:String): void {
                trace("Google Ad ID = " + googleAdId);
            });
            Adjust.getAmazonAdId(function (amazonAdId:String): void {
                trace("Amazon Ad ID = " + amazonAdId);
            });
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

        private function showCustomAlert(message:String, title:String = "Alert"):void {
            var alert:Sprite = new Sprite();
            alert.graphics.beginFill(0xCCCCCC, 1);
            alert.graphics.drawRect(0, 0, 300, 200);
            alert.graphics.endFill();
            alert.x = stage.stageWidth / 2 - 150;
            alert.y = stage.stageHeight / 2 - 100;

            var titleField:TextField = new TextField();
            titleField.defaultTextFormat = new TextFormat("Arial", 16, 0x000000, true);
            titleField.text = title;
            titleField.width = 280;
            titleField.height = 30;
            titleField.x = 10;
            titleField.y = 10;
            titleField.selectable = false;
            alert.addChild(titleField);

            var messageField:TextField = new TextField();
            messageField.defaultTextFormat = new TextFormat("Arial", 14, 0x000000);
            messageField.text = message;
            messageField.width = 280;
            messageField.height = 100;
            messageField.wordWrap = true;
            messageField.x = 10;
            messageField.y = 50;
            messageField.selectable = false;
            alert.addChild(messageField);

            var closeButton:Sprite = new Sprite();
            closeButton.graphics.beginFill(0x000000, 1);
            closeButton.graphics.drawRect(0, 0, 80, 30);
            closeButton.graphics.endFill();
            closeButton.x = 110;
            closeButton.y = 150;

            var closeText:TextField = new TextField();
            closeText.defaultTextFormat = new TextFormat("Arial", 14, 0xFFFFFF, true);
            closeText.text = "Close";
            closeText.width = 80;
            closeText.height = 30;
            closeText.mouseEnabled = false;
            closeButton.addChild(closeText);

            closeButton.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
                stage.removeChild(alert);
            });

            alert.addChild(closeButton);
            stage.addChild(alert);
        }
    }
}
