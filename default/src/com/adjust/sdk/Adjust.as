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

      return false;
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

    public static function getIdfa():void {
      trace("adjust: getIdfa called");
    }

    public static function getGoogleAdId(callback:Function):void {
      trace("adjust: getGoogleAdId called");
    }

    public static function addSessionCallbackParameter(key:String, value:String):void {
      trace("adjust: addSessionCallbackParameter called");
    }

    public static function removeSessionCallbackParameter(key:String):void {
      trace("adjust: removeSessionCallbackParameter called");
    }

    public static function resetSessionCallbackParameter():void {
      trace("adjust: resetSessionCallbackParameter called");
    }

    public static function addSessionPartnerParameter(key:String, value:String):void {
      trace("adjust: addSessionPartnerParameter called");
    }

    public static function removeSessionPartnerParameter(key:String):void {
      trace("adjust: removeSessionPartnerParameter called");
    }

    public static function resetSessionPartnerParameter():void {
      trace("adjust: resetSessionPartnerParameter called");
    }

    public static function setPushToken(token:String):void {
      trace("adjust: setPushToken called");
    }
  }
}
