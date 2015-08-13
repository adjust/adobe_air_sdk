package {

import com.adjust.sdk.Adjust;
import com.adjust.sdk.AdjustConfig;
import com.adjust.sdk.AdjustEvent;
import com.adjust.sdk.AdjustAttribution;
import com.adjust.sdk.Environment;
import com.adjust.sdk.LogLevel;

import flash.desktop.NativeApplication;
import flash.desktop.SystemIdleMode;

import flash.display.Shape;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.system.Capabilities;
import flash.text.TextField;

public class Main extends Sprite {
    private static var numberButtons:int = 2;
    private static var buttonHeight:int = 30;
    private static var IsEnabledTextField:TextField;
    public function Main() {
        //addEventListener(Event.ADDED_TO_STAGE, init);

        buildButton(0, "Start Manually", startManuallyClick);
        buildButton(1, "Track Simple Event", TrackEventClick);
        buildButton(2, "Track Revenue Event", TrackRevenueClick);
        buildButton(3, "Enable SDK", SetEnableClick);
        buildButton(4, "Disable SDK", SetDisableClick);
        IsEnabledTextField = buildButton(5, "Is SDK Enabled?", IsEnabledClick);
    }

    private static function startManuallyClick(Event:MouseEvent):void {
        var adjustConfig:AdjustConfig = new AdjustConfig("rb4g27fje5ej", Environment.SANDBOX);
        adjustConfig.setLogLevel(LogLevel.VERBOSE);
        // adjustConfig.setAttributionCallbackDelegate(AttributionCallbackDelegate);

        Adjust.start(adjustConfig);
    }

    private static function TrackEventClick(Event:MouseEvent):void {
        var adjustEvent:AdjustEvent = new AdjustEvent("uqg17r");
        adjustEvent.addCallbackParameter("foo", "bar");
        adjustEvent.addCallbackParameter("a", "b");
        adjustEvent.addCallbackParameter("foo", "c");

        Adjust.trackEvent(adjustEvent);
    }

    private static function TrackRevenueClick(Event:MouseEvent):void {
        var adjustEvent:AdjustEvent = new AdjustEvent("71iltz");
        adjustEvent.setRevenue(0.01, "EUR");
        adjustEvent.addPartnerParameter("key", "value");
        adjustEvent.addPartnerParameter("x", "y");
        adjustEvent.addPartnerParameter("key", "z");

        Adjust.trackEvent(adjustEvent);
    }

    private static function SetEnableClick(Event:MouseEvent):void {
        Adjust.setEnabled(true);
    }

    private static function SetDisableClick(Event:MouseEvent):void {
        Adjust.setEnabled(false);
    }

    private static function IsEnabledClick(Event:MouseEvent):void {
        var isEnabled: Boolean = Adjust.isEnabled();

        if (isEnabled) {
            IsEnabledTextField.text = "Is enabled? true";
        } else {
            IsEnabledTextField.text = "Is enabled? false";
        }
    }

    private static function AttributionCallbackDelegate(attribution:AdjustAttribution):void {
        trace("Attribution changed!");
        trace("Tracker token = " + attribution.getTrackerToken());
        trace("Tracker name = " + attribution.getTrackerName());
        trace("Campaign = " + attribution.getCampaign());
        trace("Network = " + attribution.getNetwork());
        trace("Creative = " + attribution.getCreative());
        trace("Adgroup = " + attribution.getAdGroup());
        trace("Click label = " + attribution.getClickLabel());
    }

    private static function ResponseDelegate(responseData: Object):void {
        trace("ResponseDelegate callback")
        for (var key:String in responseData) {
            trace(key + ": " + responseData[key]);
        }
    }

    private function buildButton(number: int, text: String, clickFunction: Function): TextField {
        trace("buildButton number " + number);
        var Ypos: int = (buttonHeight + 10) * number;

        var textField: TextField = new TextField();
        textField.text = text;
        textField.mouseEnabled = false;
        textField.x = 0;
        textField.y = Ypos;


        var buttonSprite: Sprite = new Sprite();
        buttonSprite.graphics.beginFill(0xFFCC00);
        //sprite.graphics.drawRect(0
        //        ,Capabilities.screenResolutionY * number / numberButtons
        //        ,Capabilities.screenResolutionX
        //        ,Capabilities.screenResolutionY / numberButtons);
        buttonSprite.graphics.drawRect(0, Ypos, 200, buttonHeight);
        buttonSprite.graphics.endFill();

        buttonSprite.addChild(textField);

        var simpleButton:SimpleButton = new SimpleButton();
        /*
        simpleButton.enabled = true;
        simpleButton.x = 0;
        simpleButton.y = Ypos;
        simpleButton.width = 200;
        simpleButton.height = buttonHeight;
*/
        //buttonSprite.buttonMode = true;
        //buttonSprite.useHandCursor = true;
        //buttonSprite.mouseChildren = false;

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
