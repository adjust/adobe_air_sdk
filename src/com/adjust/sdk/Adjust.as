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

  public class Adjust extends EventDispatcher {
    private static var sdkPrefix:String = "adobe_air4.1.0";
    private static var errorMessage:String = "adjust: SDK not started. Start it manually using the 'start' method";
    private static var extensionContext:ExtensionContext;
    private static var attributionCallbackDelegate:Function;
    private static var googleAdIdCallbackDelegate:Function;
    private static var eventTrackingSucceededDelegate:Function;
    private static var eventTrackingFailedDelegate:Function;
    private static var sessionTrackingSucceededDelegate:Function;
    private static var sessionTrackingFailedDelegate:Function;
    private static var deferredDeeplinkDelegate:Function;

    public static function start(adjustConfig:AdjustConfig):void {
      if (extensionContext) {
        trace("adjust warning: SDK already started");
        //TODO: REMOVE RETURN
        return;
      }

      trace("EC: 1");
      extensionContext = ExtensionContext.createExtensionContext("com.adjust.sdk", null);
      trace("EC: 2");

      if (!extensionContext) {
        trace("adjust error: cannot open ANE 'com.adjust.sdk' for this platform");
        return;
      }

      //TODO: REMOVE COMMENT
      var app:NativeApplication = NativeApplication.nativeApplication;
      app.addEventListener(Event.ACTIVATE, onResume);
      app.addEventListener(Event.DEACTIVATE, onPause);
      app.addEventListener(InvokeEvent.INVOKE, onInvoke);

      attributionCallbackDelegate = adjustConfig.getAttributionCallbackDelegate();
      extensionContext.addEventListener(StatusEvent.STATUS, extensionResponseDelegate);

      eventTrackingSucceededDelegate = adjustConfig.getEventTrackingSucceededDelegate();
      extensionContext.addEventListener(StatusEvent.STATUS, extensionResponseDelegate);

      eventTrackingFailedDelegate = adjustConfig.getEventTrackingFailedDelegate();
      extensionContext.addEventListener(StatusEvent.STATUS, extensionResponseDelegate);

      sessionTrackingSucceededDelegate = adjustConfig.getSessionTrackingSucceededDelegate();
      extensionContext.addEventListener(StatusEvent.STATUS, extensionResponseDelegate);

      sessionTrackingFailedDelegate = adjustConfig.getSessionTrackingFailedDelegate();
      extensionContext.addEventListener(StatusEvent.STATUS, extensionResponseDelegate);

      deferredDeeplinkDelegate = adjustConfig.getDeferredDeeplinkDelegate();
      extensionContext.addEventListener(StatusEvent.STATUS, extensionResponseDelegate);

      trace("adjust: start [1]>>>")
        extensionContext.call("onCreate", 
            adjustConfig.getAppToken(), 
            adjustConfig.getEnvironment(),
            adjustConfig.getAllowSupressLogLevel(),
            adjustConfig.getLogLevel(), 
            adjustConfig.getEventBufferingEnabled(),
            adjustConfig.getAttributionCallbackDelegate() != null, 
            adjustConfig.getEventTrackingSucceededDelegate() != null, 
            adjustConfig.getEventTrackingFailedDelegate() != null, 
            adjustConfig.getSessionTrackingSucceededDelegate() != null, 
            adjustConfig.getSessionTrackingFailedDelegate() != null, 
            adjustConfig.getDeferredDeeplinkDelegate() != null, 
            adjustConfig.getDefaultTracker(),
            sdkPrefix,
            adjustConfig.getShouldLaunchDeeplink());


      trace("adjust: start [2]>>>")
        // For now, call onResume after onCreate.
        extensionContext.call("onResume");
      trace("adjust: start [3]>>>")
    }

    public static function trackEvent(adjustEvent:AdjustEvent):void {
      if (!extensionContext) {
        trace(errorMessage);
        return;
      }

      extensionContext.call("trackEvent", 
          adjustEvent.getEventToken(), 
          adjustEvent.getCurrency(),
          adjustEvent.getRevenue(), 
          adjustEvent.getCallbackParameters(), 
          adjustEvent.getPartnerParameters(),
          adjustEvent.getTransactionId(), 
          adjustEvent.getReceipt(), 
          adjustEvent.getIsReceiptSet());
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

    public static function setOfflineMode(isOffline:Boolean):void {
      if (!extensionContext) {
        trace(errorMessage);
        return;
      }

      extensionContext.call("setOfflineMode", isOffline);
    }

    public static function setReferrer(referrer:String):void {
      if (!extensionContext) {
        trace(errorMessage);
        return;
      }

      extensionContext.call("setReferrer", referrer);
    }

    public static function getIdfa():String {
      if (!extensionContext) {
        trace(errorMessage);
        return null;
      }

      var idfa:String = String (extensionContext.call("getIdfa"));

      return idfa;
    }

    public static function getGoogleAdId(callback:Function):void {
      if (!extensionContext) {
        trace(errorMessage);
        return;
      }

      googleAdIdCallbackDelegate = callback;
      extensionContext.addEventListener(StatusEvent.STATUS, extensionResponseDelegate);

      extensionContext.call("getGoogleAdId");
    }

    public static function addSessionCallbackParameter(key:String, value:String):void {
      trace("calling addSessionCallbackParameter");
      if (!extensionContext) {
        trace(errorMessage);
        return;
      }

      extensionContext.call("addSessionCallbackParameter", key, value);
    }

    public static function addSessionPartnerParameter(key:String, value:String):void {
      trace("calling addSessionPartnerParameter");
      if (!extensionContext) {
        trace(errorMessage);
        return;
      }

      extensionContext.call("addSessionPartnerParameter", key, value);
    }

    public static function removeSessionCallbackParameter(key:String):void {
      trace("calling removeSessionCallbackParameter");
      if (!extensionContext) {
        trace(errorMessage);
        return;
      }

      extensionContext.call("removeSessionCallbackParameter", key);
    }

    public static function removeSessionPartnerParameter(key:String):void {
      trace("calling removeSessionPartnerParameter");
      if (!extensionContext) {
        trace(errorMessage);
        return;
      }

      extensionContext.call("removeSessionPartnerParameter", key);
    }

    public static function resetSessionCallbackParameters():void {
      trace("calling resetSessionCallbackParameter");
      if (!extensionContext) {
        trace(errorMessage);
        return;
      }

      extensionContext.call("resetSessionCallbackParameters");
    }

    public static function resetSessionPartnerParameters():void {
      trace("calling resetSessionPartnerParameter");
      if (!extensionContext) {
        trace(errorMessage);
        return;
      }

      extensionContext.call("resetSessionPartnerParameters");
    }

    public static function setPushToken(token:String):void {
      trace("calling setPushToken");
      if (!extensionContext) {
        trace(errorMessage);
        return;
      }

      extensionContext.call("setPushToken", token);
    }

    private static function extensionResponseDelegate(statusEvent:StatusEvent):void {
      if (statusEvent.code == "adjust_attributionData") {
        var attribution:AdjustAttribution = getAttributionFromResponse(statusEvent.level);
        attributionCallbackDelegate(attribution);
      } 
      else if (statusEvent.code == "adjust_eventTrackingSucceeded") {
        var eventSuccess:AdjustEventSuccess = getEventSuccessFromResponse(statusEvent.level);
        eventTrackingSucceededDelegate(eventSuccess);
      } 
      else if (statusEvent.code == "adjust_eventTrackingFailed") {
        var eventFail:AdjustEventFail = getEventFailFromResponse(statusEvent.level);
        eventTrackingFailedDelegate(eventFail);
      }
      else if (statusEvent.code == "adjust_sessionTrackingSucceeded") {
        var sessionSuccess:AdjustSessionSuccess = getSessionSuccessFromResponse(statusEvent.level);
        sessionTrackingSucceededDelegate(sessionSuccess);
      }
      else if (statusEvent.code == "adjust_sessionTrackingFailed") {
        var sessionFail:AdjustSessionFail = getSessionFailFromResponse(statusEvent.level);
        sessionTrackingFailedDelegate(sessionFail);
      }
      else if (statusEvent.code == "adjust_deferredDeeplink") {
        var uri:String = getDeferredDeeplinkFromResponse(statusEvent.level);
        deferredDeeplinkDelegate(uri);
      }
      else if (statusEvent.code == "adjust_googleAdId") {
        var googleAdId:String = statusEvent.level;

        googleAdIdCallbackDelegate(googleAdId);
      }
    }

    private static function getEventSuccessFromResponse(response:String):AdjustEventSuccess {
      var message:String;
      var timestamp:String;
      var adid:String;
      var eventToken:String;

      var jsonSplit:Array = response.split(",jsonResponse=");
      var jsonResponse:String = jsonSplit[1];
      var nonJsonResponse:String = jsonSplit[0];

      var parts:Array = nonJsonResponse.split(",");

      for (var i:int = 0; i < parts.length; i++) {
        var field:Array = parts[i].split("=");
        var key:String = field[0];
        var value:String = field[1];

        if (key == "message") {
          message = value;
        } else if (key == "timestamp") {
          timestamp = value;
        } else if (key == "adid") {
          adid = value;
        } else if (key == "eventToken") {
          eventToken = value;
        }
      }

      return new AdjustEventSuccess(message, timestamp, adid, eventToken, jsonResponse);
    }

    private static function getEventFailFromResponse(response:String):AdjustEventFail {
      var message:String;
      var timestamp:String;
      var adid:String;
      var eventToken:String;
      var willRetry:Boolean;

      var jsonSplit:Array = response.split(",jsonResponse=");
      var jsonResponse:String = jsonSplit[1];
      var nonJsonResponse:String = jsonSplit[0];

      var parts:Array = nonJsonResponse.split(",");

      for (var i:int = 0; i < parts.length; i++) {
        var field:Array = parts[i].split("=");
        var key:String = field[0];
        var value:String = field[1];

        if (key == "message") {
          message = value;
        } else if (key == "timestamp") {
          timestamp = value;
        } else if (key == "adid") {
          adid = value;
        } else if (key == "eventToken") {
          eventToken = value;
        } else if (key == "willRetry") {
          var tempVal:String = value;
          willRetry = tempVal == "true";
        }
      }

      return new AdjustEventFail(message, timestamp, adid, eventToken, jsonResponse, willRetry);
    }

    private static function getSessionSuccessFromResponse(response:String):AdjustSessionSuccess {
      var message:String;
      var timestamp:String;
      var adid:String;

      var jsonSplit:Array = response.split(",jsonResponse=");
      var jsonResponse:String = jsonSplit[1];
      var nonJsonResponse:String = jsonSplit[0];

      var parts:Array = nonJsonResponse.split(",");

      for (var i:int = 0; i < parts.length; i++) {
        var field:Array = parts[i].split("=");
        var key:String = field[0];
        var value:String = field[1];

        if (key == "message") {
          message = value;
        } else if (key == "timestamp") {
          timestamp = value;
        } else if (key == "adid") {
          adid = value;
        }
      }

      return new AdjustSessionSuccess(message, timestamp, adid, jsonResponse);
    }

    private static function getSessionFailFromResponse(response:String):AdjustSessionFail {
      var message:String;
      var timestamp:String;
      var adid:String;
      var willRetry:Boolean;

      var jsonSplit:Array = response.split(",jsonResponse=");
      var jsonResponse:String = jsonSplit[1];
      var nonJsonResponse:String = jsonSplit[0];

      var parts:Array = nonJsonResponse.split(",");

      for (var i:int = 0; i < parts.length; i++) {
        var field:Array = parts[i].split("=");
        var key:String = field[0];
        var value:String = field[1];

        if (key == "message") {
          message = value;
        } else if (key == "timestamp") {
          timestamp = value;
        } else if (key == "adid") {
          adid = value;
        } else if (key == "willRetry") {
          var tempVal:String = value;
          willRetry = tempVal == "true";
        }
      }

      return new AdjustSessionFail(message, timestamp, adid, jsonResponse, willRetry);
    }


    private static function getDeferredDeeplinkFromResponse(response:String):String {
      return response;
    }

    private static function getAttributionFromResponse(response:String):AdjustAttribution {
      var trackerToken:String;
      var trackerName:String;
      var campaign:String;
      var network:String;
      var creative:String;
      var adgroup:String;
      var clickLabel:String;

      var parts:Array = response.split(",");

      for (var i:int = 0; i < parts.length; i++) {
        var field:Array = parts[i].split("=");
        var key:String = field[0];
        var value:String = field[1];

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

        trace("adjust: Trying to open deep link");
        trace(argument);

        appWillOpenUrl(argument);

        break;
      }
    }
  }
}
