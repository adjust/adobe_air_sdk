package com.adjust.sdk;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

import android.content.Intent;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by pfms on 31/07/14.
 */
public class AdjustContext extends FREContext {
    public static String OnCreate = "onCreate";
    public static String TrackEvent = "trackEvent";
    public static String SetEnabled = "setEnabled";
    public static String IsEnabled = "isEnabled";
    public static String OnResume = "onResume";
    public static String OnPause = "onPause";
    public static String AppWillOpenUrl = "appWillOpenUrl";
    public static String SetOfflineMode = "setOfflineMode";
    public static String SetReferrer = "setReferrer";
    public static String GetGoogleAdId = "getGoogleAdId";
    public static String GetAmazonAdId = "getAmazonAdId";
    public static String AddSessionCallbackParameter = "addSessionCallbackParameter";
    public static String RemoveSessionCallbackParameter = "removeSessionCallbackParameter";
    public static String ResetSessionCallbackParameters = "resetSessionCallbackParameters";
    public static String AddSessionPartnerParameter = "addSessionPartnerParameter";
    public static String RemoveSessionPartnerParameter = "removeSessionPartnerParameter";
    public static String ResetSessionPartnerParameters = "resetSessionPartnerParameters";
    public static String SetDeviceToken = "setDeviceToken";
    public static String SendFirstPackages = "sendFirstPackages";
    public static String GetAdid = "getAdid";
    public static String GetAttribution = "getAttribution";
    public static String GdprForgetMe = "gdprForgetMe";

    // iOS methods
    public static String GetIdfa = "getIdfa";

    @Override
    public Map<String, FREFunction> getFunctions() {
        Map<String, FREFunction> functions = new HashMap<String, FREFunction>();

        functions.put(AdjustContext.OnCreate, new AdjustFunction(AdjustContext.OnCreate));
        functions.put(AdjustContext.TrackEvent, new AdjustFunction(AdjustContext.TrackEvent));
        functions.put(AdjustContext.SetEnabled, new AdjustFunction(AdjustContext.SetEnabled));
        functions.put(AdjustContext.IsEnabled, new AdjustFunction(AdjustContext.IsEnabled));
        functions.put(AdjustContext.OnResume, new AdjustFunction(AdjustContext.OnResume));
        functions.put(AdjustContext.OnPause, new AdjustFunction(AdjustContext.OnPause));
        functions.put(AdjustContext.AppWillOpenUrl, new AdjustFunction(AdjustContext.AppWillOpenUrl));
        functions.put(AdjustContext.SetOfflineMode, new AdjustFunction(AdjustContext.SetOfflineMode));
        functions.put(AdjustContext.SetReferrer, new AdjustFunction(AdjustContext.SetReferrer));
        functions.put(AdjustContext.GetGoogleAdId, new AdjustFunction(AdjustContext.GetGoogleAdId));
        functions.put(AdjustContext.GetAmazonAdId, new AdjustFunction(AdjustContext.GetAmazonAdId));
        functions.put(AdjustContext.GetIdfa, new AdjustFunction(AdjustContext.GetIdfa));
        functions.put(AdjustContext.AddSessionCallbackParameter, new AdjustFunction(AdjustContext.AddSessionCallbackParameter));
        functions.put(AdjustContext.RemoveSessionCallbackParameter, new AdjustFunction(AdjustContext.RemoveSessionCallbackParameter));
        functions.put(AdjustContext.ResetSessionCallbackParameters, new AdjustFunction(AdjustContext.ResetSessionCallbackParameters));
        functions.put(AdjustContext.AddSessionPartnerParameter, new AdjustFunction(AdjustContext.AddSessionPartnerParameter));
        functions.put(AdjustContext.RemoveSessionPartnerParameter, new AdjustFunction(AdjustContext.RemoveSessionPartnerParameter));
        functions.put(AdjustContext.ResetSessionPartnerParameters, new AdjustFunction(AdjustContext.ResetSessionPartnerParameters));
        functions.put(AdjustContext.SetDeviceToken, new AdjustFunction(AdjustContext.SetDeviceToken));
        functions.put(AdjustContext.SendFirstPackages, new AdjustFunction(AdjustContext.SendFirstPackages));
        functions.put(AdjustContext.GetAdid, new AdjustFunction(AdjustContext.GetAdid));
        functions.put(AdjustContext.GetAttribution, new AdjustFunction(AdjustContext.GetAttribution));
        functions.put(AdjustContext.GdprForgetMe, new AdjustFunction(AdjustContext.GdprForgetMe));

        return functions;
    }

    @Override
    public void dispose() {}
}
