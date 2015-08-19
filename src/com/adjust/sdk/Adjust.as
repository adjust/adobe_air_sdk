/**
 * Created by pfms on 30/07/14.
 */
package com.adjust.sdk {
import flash.desktop.NativeApplication;
import flash.events.BrowserInvokeEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.InvokeEvent;
import flash.events.StatusEvent;
import flash.external.ExtensionContext;

public class Adjust extends EventDispatcher {
    private static var errorMessage:String = "adjust: SDK not started. Start it manually using the 'start' method";
    private static var extensionContext:ExtensionContext;
    private static var attributionCallbackDelegate:Function;
    
    public static function start(adjustConfig:AdjustConfig):void {
        if (extensionContext) {
            trace("adjust warning: SDK already started");
        }

        try {
            extensionContext = ExtensionContext.createExtensionContext("com.adjust.sdk", null);
        } catch (exception) {
            trace(exception.toString());
        }

        if (!extensionContext) {
            trace("adjust error: cannot open ANE 'com.adjust.sdk' for this platform");
            return;
        }

        var app:NativeApplication = NativeApplication.nativeApplication;
        app.addEventListener(Event.ACTIVATE, onResume);
        app.addEventListener(Event.DEACTIVATE, onPause);
        app.addEventListener(InvokeEvent.INVOKE, onInvoke);
        app.addEventListener(BrowserInvokeEvent.BROWSER_INVOKE, onBrowserInvoke);

        if (adjustConfig.getAttributionCallbackDelegate() != null) {
            attributionCallbackDelegate = adjustConfig.getAttributionCallbackDelegate();
            extensionContext.addEventListener(StatusEvent.STATUS, extensionResponseDelegate);

            extensionContext.call("onCreate", adjustConfig.getAppToken(), adjustConfig.getEnvironment(),
                    adjustConfig.getLogLevel(), adjustConfig.getEventBufferingEnabled(), true,
                    adjustConfig.getDefaultTracker(), adjustConfig.getMacMd5TrackingEnabled());
        } else {
            extensionContext.call("onCreate", adjustConfig.getAppToken(), adjustConfig.getEnvironment(),
                    adjustConfig.getLogLevel(), adjustConfig.getEventBufferingEnabled(), false,
                    adjustConfig.getDefaultTracker(), adjustConfig.getMacMd5TrackingEnabled());
        }

        // For now, call onResume after onCreate.
        extensionContext.call("onResume");
    }

    public static function trackEvent(adjustEvent:AdjustEvent):void {
        if (!extensionContext) {
            trace(errorMessage);
            return;
        }

        extensionContext.call("trackEvent", adjustEvent.getEventToken(), adjustEvent.getCurrency(),
        adjustEvent.getRevenue(), adjustEvent.getCallbackParameters(), adjustEvent.getPartnerParameters(),
        adjustEvent.getTransactionId(), adjustEvent.getReceipt(), adjustEvent.getIsReceiptSet());
    }

    public static function setEnabled(enabled:Boolean):void {
        if (!extensionContext) {
            trace(errorMessage);
            return;
        }

        extensionContext.call("setEnabled", enabled);
    }

    public static function isEnabled():Boolean {
        if (!extensionContext) {
            trace(errorMessage);
            return false;
        }

        var isEnabled:int = int (extensionContext.call("isEnabled"));
        return isEnabled;
    }

    public static function onResume(event:Event):void {
        if (!extensionContext) {
            trace(errorMessage);
            return;
        }

        extensionContext.call("onResume");
    }

    public static function onPause(event:Event):void {
        if (!extensionContext) {
            trace(errorMessage);
            return;
        }

        extensionContext.call("onPause");
    }

    public static function appWillOpenUrl(url:String):void {
        if (!extensionContext) {
            trace(errorMessage);
            return;
        }

        extensionContext.call("appWillOpenUrl", url);
    }

    private static function extensionResponseDelegate(statusEvent:StatusEvent):void {
        if (statusEvent.code != "adjust_attributionData") {
            return;
        }

        var attribution:AdjustAttribution = getAttributionFromResponse(statusEvent.level);

        attributionCallbackDelegate(attribution);
    }

    private static function getAttributionFromResponse(response:String):AdjustAttribution {
        var trackerToken:String = "";
        var trackerName:String = "";
        var campaign:String = "";
        var network:String = "";
        var creative:String = "";
        var adgroup:String = "";
        var clickLabel:String = "";

        var attributionParts:Array = response.split(",");

        for (var i:int = 0; i < attributionParts.length; i++) {
            var attributionField:Array = attributionParts[i].split("=");
            var key:String = attributionField[0];
            var value:String = attributionField[1];

            if (key == "trackerToken") {
                trackerToken = value;
            } else if (key == "trackerName") {
                trackerName = value;
            } else if (key == "campaign") {
                campaign = value;
            } else if (key == "network") {
                network = value;
            } else if (key == "creative") {
                creative = value;
            } else if (key == "adgroup") {
                adgroup = value;
            } else if (key == "clickLabel") {
                clickLabel = value;
            }
        }

        return new AdjustAttribution(trackerToken, trackerName, campaign, network, creative, adgroup, clickLabel);
    }

    private static function onInvoke(event:InvokeEvent):void {
        for (var i:int = 0; i < event.arguments.length; i++) {
            var argument:String = event.arguments[i];
            trace(argument);

            extensionContext.call("appWillOpenUrl", argument);

            break;
        }
    }

    private static function onBrowserInvoke(event:InvokeEvent):void {
        
    }
}
}
