/**
 * Created by pfms on 30/07/14.
 */
package com.adjust.sdk {
import flash.desktop.NativeApplication;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.InvokeEvent;
import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.html.script.Package;

public class Adjust extends EventDispatcher{
    private static var extensionContext: ExtensionContext;
    private static var errorMessage: String = "adjust: SDK not started. Start it manually using the 'appDidLaunch' method";
    private static var nativeResponseDelegate: Function;

    public static function appDidLaunch(appToken: String, environment: String, logLevel: String, eventBuffering: Boolean): void {
        if (extensionContext) {
            trace("adjust warning: SDK already started");
            // adjust: warning, SDK already started. Restarting
        }

        extensionContext = ExtensionContext.createExtensionContext("com.adjust.sdk", null);

        if (!extensionContext) {
            trace("adjust error: cannot open ANE 'com.adjust.sdk' for this platform");
            return;
            // adjust: error, SDK not loaded
        }

        var app:NativeApplication = NativeApplication.nativeApplication;
        app.addEventListener(Event.ACTIVATE, onResume);
        app.addEventListener(Event.DEACTIVATE, onPause);
        //app.addEventListener(InvokeEvent.INVOKE, appDidLaunch);

        extensionContext.call("appDidLaunch", appToken, environment, logLevel, eventBuffering, "air3.4.1");
    }

    public static function trackEvent(eventToken: String, parameters: Object = null): void {
        if (!extensionContext) {
            trace(errorMessage);
            return;
        }
        extensionContext.call("trackEvent", eventToken, injectKeys(parameters));
    }

    public static function trackRevenue(amountInCents: Number, eventToken: String = null, parameters: Object = null): void {
        if (!extensionContext) {
            trace(errorMessage);
            return;
        }
        extensionContext.call("trackRevenue", amountInCents, eventToken, injectKeys(parameters));
    }

    public static function setEnabled(enabled: Boolean): void {
        if (!extensionContext) {
            trace(errorMessage);
            return;
        }
        extensionContext.call("setEnable", enabled);
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

    public static function setResponseDelegate(responseDelegate: Function): void {
        if (!extensionContext) {
            trace(errorMessage);
            return;
        }
        nativeResponseDelegate = responseDelegate;
        extensionContext.addEventListener(StatusEvent.STATUS, extensionResponseDelegate);
        extensionContext.call("setResponseDelegate");
    }

    private static function injectKeys(object: Object): Object {
        if (!object) return null;

        var keys: Array = new Array();
        for (var key:String in object) {
            keys.push(key);
        }
        object["adjust keys"] = keys;
        return object;
    }

    private static function extensionResponseDelegate(statusEvent: StatusEvent): void {
        if (statusEvent.code != "adjust_responseData") {
            return;
        }

        nativeResponseDelegate(JSON.parse(statusEvent.level));
    }
}
}
