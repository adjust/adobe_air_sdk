/**
 * Created by pfms on 30/07/14.
 */
package com.adjust.sdk {
import flash.desktop.NativeApplication;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.external.ExtensionContext;

public class Adjust extends EventDispatcher {
    private static var errorMessage: String = "adjust: SDK not started. Start it manually using the 'start' method";
    private static var extensionContext: ExtensionContext;
    private static var nativeResponseDelegate: Function;
    
    public static function start(adjustConfig:AdjustConfig):void {
        if (extensionContext) {
            trace("adjust warning: SDK already started");
        }

        extensionContext = ExtensionContext.createExtensionContext("com.adjust.sdk", null);

        if (!extensionContext) {
            trace("adjust error: cannot open ANE 'com.adjust.sdk' for this platform");
            return;
        }

        var app:NativeApplication = NativeApplication.nativeApplication;
        app.addEventListener(Event.ACTIVATE, onResume);
        app.addEventListener(Event.DEACTIVATE, onPause);

        extensionContext.call("onCreate", adjustConfig.getAppToken(), adjustConfig.getEnvironment(),
        adjustConfig.getLogLevel(), adjustConfig.getEventBufferingEnabled());

        // For now, call onResume after onCreate.
        extensionContext.call("onResume");
    }

    public static function trackEvent(adjustEvent:AdjustEvent): void {
        if (!extensionContext) {
            trace(errorMessage);
            return;
        }

        extensionContext.call("trackEvent", adjustEvent.getEventToken(), adjustEvent.getCurrency(),
        adjustEvent.getRevenue(), adjustEvent.getCallbackParameters(), adjustEvent.getPartnerParameters());
    }

    public static function setEnabled(enabled: Boolean): void {
        if (!extensionContext) {
            trace(errorMessage);
            return;
        }

        extensionContext.call("setEnabled", enabled);
    }

    public static function isEnabled(): Boolean {
        if (!extensionContext) {
            trace(errorMessage);
            return false;
        }

        var isEnabled:int = int (extensionContext.call("isEnabled"));
        return isEnabled;
    }

    public static function onResume(event:Event): void {
        if (!extensionContext) {
            trace(errorMessage);
            return;
        }

        extensionContext.call("onResume");
    }

    public static function onPause(event:Event): void {
        if (!extensionContext) {
            trace(errorMessage);
            return;
        }

        extensionContext.call("onPause");
    }

    //    public static function setResponseDelegate(responseDelegate: Function): void {
    //        if (!extensionContext) {
    //            trace(errorMessage);
    //            return;
    //        }
    //
    //        nativeResponseDelegate = responseDelegate;
    //        extensionContext.addEventListener(StatusEvent.STATUS, extensionResponseDelegate);
    //        extensionContext.call("setResponseDelegate");
    //    }

    //    private static function extensionResponseDelegate(statusEvent: StatusEvent): void {
    //        if (statusEvent.code != "adjust_responseData") {
    //            return;
    //        }
    //
    //        nativeResponseDelegate(JSON.parse(statusEvent.level));
    //    }
}
}
