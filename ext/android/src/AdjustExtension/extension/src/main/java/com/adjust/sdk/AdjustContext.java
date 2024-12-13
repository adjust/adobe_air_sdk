//
//  AdjustContext.java
//  Adjust SDK
//
//  Created by Pedro Silva (@nonelse) on 31st July 2014.
//  Copyright (c) 2014-2018 Adjust GmbH. All rights reserved.
//

package com.adjust.sdk;

import java.util.Map;
import java.util.HashMap;
import android.content.Intent;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

public class AdjustContext extends FREContext {
    public static String InitSdk = "initSdk";
    public static String Enable = "enable";
    public static String Disable = "disable";
    public static String SwitchToOfflineMode = "switchToOfflineMode";
    public static String SwitchBackToOnlineMode = "switchBackToOnlineMode";
    public static String TrackEvent = "trackEvent";
    public static String TrackAdRevenue = "trackAdRevenue";
    public static String TrackThirdPartySharing = "trackThirdPartySharing";
    public static String TrackMeasurementConsent = "trackMeasurementConsent";
    public static String ProcessDeeplink = "processDeeplink";
    public static String ProcessAndResolveDeeplink = "processAndResolveDeeplink";
    public static String SetPushToken = "setPushToken";
    public static String GdprForgetMe = "gdprForgetMe";
    public static String AddGlobalCallbackParameter = "addGlobalCallbackParameter";
    public static String RemoveGlobalCallbackParameter = "removeGlobalCallbackParameter";
    public static String RemoveGlobalCallbackParameters = "removeGlobalCallbackParameters";
    public static String AddGlobalPartnerParameter = "addGlobalPartnerParameter";
    public static String RemoveGlobalPartnerParameter = "removeGlobalPartnerParameter";
    public static String RemoveGlobalPartnerParameters = "removeGlobalPartnerParameters";
    public static String IsEnabled = "isEnabled";
    public static String GetAdid = "getAdid";
    public static String GetAttribution = "getAttribution";
    public static String GetSdkVersion = "getSdkVersion";
    public static String GetLastDeeplink = "getLastDeeplink";
    // ios methods
    public static String TrackAppStoreSubscription = "trackAppStoreSubscription";
    public static String VerifyAppStorePurchase = "verifyAppStorePurchase";
    public static String VerifyAndTrackAppStorePurchase = "verifyAndTrackAppStorePurchase";
    public static String GetIdfa = "getIdfa";
    public static String GetIdfv = "getIdfv";
    public static String GetAppTrackingStatus = "getAppTrackingStatus";
    public static String RequestAppTrackingAuthorization = "requestAppTrackingAuthorization";
    public static String UpdateSkanConversionValue = "updateSkanConversionValue";
    // android methods
    public static String TrackPlayStoreSubscription = "trackPlayStoreSubscription";
    public static String VerifyPlayStorePurchase = "verifyPlayStorePurchase";
    public static String VerifyAndTrackPlayStorePurchase = "verifyAndTrackPlayStorePurchase";
    public static String GetGoogleAdId = "getGoogleAdId";
    public static String GetAmazonAdId = "getAmazonAdId";
    // test methods
    public static String OnResume = "onResume";
    public static String OnPause = "onPause";
    public static String SetTestOptions = "setTestOptions";
    public static String Teardown = "teardown";

    @Override
    public Map<String, FREFunction> getFunctions() {
        Map<String, FREFunction> functions = new HashMap<String, FREFunction>();
        // TODO: lowercase methods
        // common methods
        functions.put(AdjustContext.InitSdk, new AdjustFunction(AdjustContext.InitSdk));
        functions.put(AdjustContext.Enable, new AdjustFunction(AdjustContext.Enable));
        functions.put(AdjustContext.Disable, new AdjustFunction(AdjustContext.Disable));
        functions.put(AdjustContext.SwitchToOfflineMode, new AdjustFunction(AdjustContext.SwitchToOfflineMode));
        functions.put(AdjustContext.SwitchBackToOnlineMode, new AdjustFunction(AdjustContext.SwitchBackToOnlineMode));
        functions.put(AdjustContext.TrackEvent, new AdjustFunction(AdjustContext.TrackEvent));
        functions.put(AdjustContext.TrackAdRevenue, new AdjustFunction(AdjustContext.TrackAdRevenue));
        functions.put(AdjustContext.TrackThirdPartySharing, new AdjustFunction(AdjustContext.TrackThirdPartySharing));
        functions.put(AdjustContext.TrackMeasurementConsent, new AdjustFunction(AdjustContext.TrackMeasurementConsent));
        functions.put(AdjustContext.ProcessDeeplink, new AdjustFunction(AdjustContext.ProcessDeeplink));
        functions.put(AdjustContext.ProcessAndResolveDeeplink, new AdjustFunction(AdjustContext.ProcessAndResolveDeeplink));
        functions.put(AdjustContext.SetPushToken, new AdjustFunction(AdjustContext.SetPushToken));
        functions.put(AdjustContext.GdprForgetMe, new AdjustFunction(AdjustContext.GdprForgetMe));
        functions.put(AdjustContext.AddGlobalCallbackParameter, new AdjustFunction(AdjustContext.AddGlobalCallbackParameter));
        functions.put(AdjustContext.RemoveGlobalCallbackParameter, new AdjustFunction(AdjustContext.RemoveGlobalCallbackParameter));
        functions.put(AdjustContext.RemoveGlobalCallbackParameters, new AdjustFunction(AdjustContext.RemoveGlobalCallbackParameters));
        functions.put(AdjustContext.AddGlobalPartnerParameter, new AdjustFunction(AdjustContext.AddGlobalPartnerParameter));
        functions.put(AdjustContext.RemoveGlobalPartnerParameter, new AdjustFunction(AdjustContext.RemoveGlobalPartnerParameter));
        functions.put(AdjustContext.RemoveGlobalPartnerParameters, new AdjustFunction(AdjustContext.RemoveGlobalPartnerParameters));
        functions.put(AdjustContext.IsEnabled, new AdjustFunction(AdjustContext.IsEnabled));
        functions.put(AdjustContext.GetAdid, new AdjustFunction(AdjustContext.GetAdid));
        functions.put(AdjustContext.GetAttribution, new AdjustFunction(AdjustContext.GetAttribution));
        functions.put(AdjustContext.GetSdkVersion, new AdjustFunction(AdjustContext.GetSdkVersion));
        functions.put(AdjustContext.GetLastDeeplink, new AdjustFunction(AdjustContext.GetLastDeeplink));
        // ios only methods
        functions.put(AdjustContext.TrackAppStoreSubscription, new AdjustFunction(AdjustContext.TrackAppStoreSubscription));
        functions.put(AdjustContext.VerifyAppStorePurchase, new AdjustFunction(AdjustContext.VerifyAppStorePurchase));
        functions.put(AdjustContext.VerifyAndTrackAppStorePurchase, new AdjustFunction(AdjustContext.VerifyAndTrackAppStorePurchase));
        functions.put(AdjustContext.GetIdfa, new AdjustFunction(AdjustContext.GetIdfa));
        functions.put(AdjustContext.GetIdfv, new AdjustFunction(AdjustContext.GetIdfv));
        functions.put(AdjustContext.GetAppTrackingStatus, new AdjustFunction(AdjustContext.GetAppTrackingStatus));
        functions.put(AdjustContext.RequestAppTrackingAuthorization, new AdjustFunction(AdjustContext.RequestAppTrackingAuthorization));
        functions.put(AdjustContext.UpdateSkanConversionValue, new AdjustFunction(AdjustContext.UpdateSkanConversionValue));
        // android only methods
        functions.put(AdjustContext.TrackPlayStoreSubscription, new AdjustFunction(AdjustContext.TrackPlayStoreSubscription));
        functions.put(AdjustContext.VerifyPlayStorePurchase, new AdjustFunction(AdjustContext.VerifyPlayStorePurchase));
        functions.put(AdjustContext.VerifyAndTrackPlayStorePurchase, new AdjustFunction(AdjustContext.VerifyAndTrackPlayStorePurchase));
        functions.put(AdjustContext.GetGoogleAdId, new AdjustFunction(AdjustContext.GetGoogleAdId));
        functions.put(AdjustContext.GetAmazonAdId, new AdjustFunction(AdjustContext.GetAmazonAdId));
        // test only methods
        functions.put(AdjustContext.OnResume, new AdjustFunction(AdjustContext.OnResume));
        functions.put(AdjustContext.OnPause, new AdjustFunction(AdjustContext.OnPause));
        functions.put(AdjustContext.SetTestOptions, new AdjustFunction(AdjustContext.SetTestOptions));
        functions.put(AdjustContext.Teardown, new AdjustFunction(AdjustContext.Teardown));

        return functions;
    }

    @Override
    public void dispose() {}
}
