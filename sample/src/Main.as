package {

import com.adjust.sdk.Adjust;
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
        buildButton(1, "Trace Event", TrackEventClick);
        buildButton(2, "Trace Revenue", TrackRevenueClick);
        buildButton(3, "Set Enable", SetEnableClick);
        buildButton(4, "Set Disable", SetDisableClick);
        IsEnabledTextField = buildButton(5, "Is Enabled?", IsEnabledClick);
        buildButton(6, "Set Callback", SetCallbackClick);
    }

    private static function startManuallyClick(Event:MouseEvent): void {
        trace("startManuallyClick");
        Adjust.appDidLaunch("qwerty123456",Environment.SANDBOX, LogLevel.VERBOSE, false);
    }

    private static function TrackEventClick(Event:MouseEvent): void {
        trace("TrackEventClick");
        Adjust.trackEvent("eve001");

        var parameters: Object = new Object();
        parameters["key"] = "value";
        parameters["foo"] = "bar";

        Adjust.trackEvent("eve002", parameters);
    }

    private static function TrackRevenueClick(Event:MouseEvent): void {
        trace("TrackRevenueClick");
        Adjust.trackRevenue(3.44);

        Adjust.trackRevenue(3.45, "rev001");

        var parameters: Object = new Object();
        parameters["key"] = "value";
        parameters["foo"] = "bar";
        Adjust.trackRevenue(0.1, "rev002", parameters);
    }

    private static function SetEnableClick(Event:MouseEvent): void {
        trace("SetEnableClick");
        Adjust.setEnabled(true);
    }

    private static function SetDisableClick(Event:MouseEvent): void {
        trace("SetDisableClick");
        Adjust.setEnabled(false);
    }

    private static function IsEnabledClick(Event:MouseEvent): void {
        trace("IsEnabledClick");
        var isEnabled: Boolean = Adjust.isEnabled();
        if (isEnabled) {
            IsEnabledTextField.text = "Is enabled? true";
        } else {
            IsEnabledTextField.text = "Is enabled? false";
        }
    }

    private static function SetCallbackClick(Event:MouseEvent): void {
        trace("SetCallbackClick");
        Adjust.setResponseDelegate(ResponseDelegate);
    }

    private static function ResponseDelegate(responseData: Object): void {
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
