/**
 * Created by pfms on 30/07/14.
 */
package com.adjust.sdk {
import flash.events.Event;
import flash.events.EventDispatcher;

public class Adjust extends EventDispatcher {
    public static function start(adjustConfig:AdjustConfig):void {
        trace("adjust: start called");
    }

    public static function trackEvent(adjustEvent:AdjustEvent):void {
        trace("adjust: trackEvent called");
    }

    public static function setEnabled(enabled:Boolean):void {
        trace("adjust: setEnabled called");
    }

    public static function isEnabled():Boolean {
        trace("adjust: isEnabled called");
    }

    public static function onResume(event:Event):void {
        trace("adjust: onResume called");
    }

    public static function onPause(event:Event):void {
        trace("adjust: onPause called");
    }

    public static function appWillOpenUrl(url:String):void {
        trace("adjust: appWillOpenUrl called");
    }

    public static function setOfflineMode(isOffline:Boolean):void {
        trace("adjust: setOfflineMode called");
    }

    public static function setReferrer(referrer:String):void {
        trace("adjust: setReferrer called");
    }

    public static function setDeviceToken(deviceToken:String):void {
        trace("adjust: setDeviceToken called");
    }
}
}
