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
    private static var adjustio: AdjustIo = AdjustIo.instance("amu9thg2tn3s", Environment.SANDBOX);

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
        adjustio.trackEvent("token1");
    }

    private static function exitOnBackButtonClick(event: KeyboardEvent): void {
        if (event.keyCode == Keyboard.BACK) {
            NativeApplication.nativeApplication.exit(0);
        }
    }
}
}
