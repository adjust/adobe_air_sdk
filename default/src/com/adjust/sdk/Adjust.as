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
    private static const LOGTAG: String = "Adjust: ";

    public static function appDidLaunch(appToken: String, environment: String, logLevel: String, eventBuffering: Boolean): void {
        var app:NativeApplication = NativeApplication.nativeApplication;
        app.addEventListener(Event.ACTIVATE, onResume);
        app.addEventListener(Event.DEACTIVATE, onPause);
        //app.addEventListener(InvokeEvent.INVOKE, appDidLaunch);

        logAdjust("appDidLaunch called with app token '" + appToken + "'");
        logAdjust("using " + environment + " environment");
        logAdjust("log level is set to " + logLevel);
        logAdjust("event buffering is " + (eventBuffering ? "enabled" : "disabled"));
    }

    public static function trackEvent(eventToken: String, parameters: Object = null): void {
        if (parameters) {
            logAdjust("trackEvent called with token '" + eventToken + "' and parameters: ");
        } else {
            logAdjust("trackEvent called with token '" + eventToken + "'");
        }
    }

    public static function trackRevenue(amountInCents: Number, eventToken: String = null, parameters: Object = null): void {
        if (! eventToken) {
            logAdjust("trackRevenue called with amount " + amountInCents.toString());
        } else if (! parameters) {
            logAdjust("trackRevenue called with amount " + amountInCents.toString() + " with event token '" + eventToken + "'");
        } else {
            logAdjust("trackRevenue called with amount " + amountInCents.toString() + " with event token '" + eventToken + "' and parameters");
        }
    }

    public static function setEnabled(enabled: Boolean): void {
        logAdjust("setEnabled called with enabled as " + enabled);
    }

    public static function isEnabled(): Boolean {
        logAdjust("isEnabled called");
        return false;
    }

    public static function onResume(event:Event): void {
        logAdjust("onResume called");
    }

    public static function onPause(event:Event): void {
        logAdjust("onPause called");
    }

    public static function setResponseDelegate(responseDelegate: Function): void {
        logAdjust("setResponseDelegate called");
    }

    private static function logAdjust(message: String, ...rest): void {
        trace.apply(null, [LOGTAG + message].concat(rest));
    }
}
}
