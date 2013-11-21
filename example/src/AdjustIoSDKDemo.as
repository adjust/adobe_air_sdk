package {

import com.adeven.adjustio.AdjustIo;
import com.adeven.adjustio.Environment;
import com.adeven.adjustio.LogLevel;

import flash.desktop.NativeApplication;
import flash.desktop.SystemIdleMode;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.ui.Keyboard;

public class AdjustIoSDKDemo extends Sprite {
    private static const ADJUST_APP_TOKEN: String = "kxrqhmmtwtr2";

    AdjustIo.initialize(ADJUST_APP_TOKEN, Environment.SANDBOX, LogLevel.VERBOSE, true);

    public function AdjustIoSDKDemo() {
        addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(event: Event = null): void {
        removeEventListener(Event.ADDED_TO_STAGE, init);

        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        stage.addEventListener(TouchEvent.TOUCH_TAP, trackEvent);
        stage.addEventListener(MouseEvent.CLICK, trackEvent);
        stage.addEventListener(KeyboardEvent.KEY_UP, exitOnBackButtonClick, false, 0, true);
        NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
    }

    private static function trackEvent(event: Event): void {
        if (! AdjustIo.instance.trackEvent("token1")) {
            trace("Failed to track event with token 'token1'!");
        }
    }

    private static function exitOnBackButtonClick(event: KeyboardEvent): void {
        if (event.keyCode == Keyboard.BACK) {
            NativeApplication.nativeApplication.exit(0);
        }
    }
}
}
