//
//  AdjustFunction.java
//  Adjust SDK
//
//  Created by Pedro Silva (@nonelse) on 31st July 2014.
//  Copyright (c) 2014-2018 Adjust GmbH. All rights reserved.
//

package com.adjust.sdk;

import java.lang.*;
import java.util.ArrayList;

import com.adobe.fre.*;
import android.net.Uri;
import android.util.Log;
import org.json.JSONObject;

public class AdjustFunction implements FREFunction,
       OnAttributionChangedListener,
       OnEventTrackingSucceededListener,
       OnEventTrackingFailedListener,
       OnSessionTrackingSucceededListener,
       OnSessionTrackingFailedListener,
       OnDeferredDeeplinkResponseListener {
    private final String functionName;
    private Boolean shouldLaunchDeeplink;

    public AdjustFunction(String functionName) {
        this.functionName = functionName;
    }

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        AdjustExtension.context = (AdjustContext) freContext;

        // common methods
        if (functionName.equals(AdjustContext.InitSdk)) {
            return InitSdk(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.Enable)) {
            return Enable();
        }
        if (functionName.equals(AdjustContext.Disable)) {
            return Disable();
        }
        if (functionName.equals(AdjustContext.SwitchToOfflineMode)) {
            return SwitchToOfflineMode();
        }
        if (functionName.equals(AdjustContext.SwitchBackToOnlineMode)) {
            return SwitchBackToOnlineMode();
        }
        if (functionName.equals(AdjustContext.TrackEvent)) {
            return TrackEvent(freObjects);
        }
        if (functionName.equals(AdjustContext.TrackAdRevenue)) {
            return TrackAdRevenue(freObjects);
        }
        if (functionName.equals(AdjustContext.TrackThirdPartySharing)) {
            return TrackThirdPartySharing(freObjects);
        }
        if (functionName.equals(AdjustContext.TrackMeasurementConsent)) {
            return TrackMeasurementConsent(freObjects);
        }
        if (functionName.equals(AdjustContext.ProcessDeeplink)) {
            return ProcessDeeplink(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.ProcessAndResolveDeeplink)) {
            return ProcessAndResolveDeeplink(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.SetPushToken)) {
            return SetPushToken(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.GdprForgetMe)) {
            return GdprForgetMe(freContext);
        }
        if (functionName.equals(AdjustContext.AddGlobalCallbackParameter)) {
            return AddGlobalCallbackParameter(freObjects);
        }
        if (functionName.equals(AdjustContext.RemoveGlobalCallbackParameter)) {
            return RemoveGlobalCallbackParameter(freObjects);
        }
        if (functionName.equals(AdjustContext.RemoveGlobalCallbackParameters)) {
            return RemoveGlobalCallbackParameters();
        }
        if (functionName.equals(AdjustContext.AddGlobalPartnerParameter)) {
            return AddGlobalPartnerParameter(freObjects);
        }
        if (functionName.equals(AdjustContext.RemoveGlobalPartnerParameter)) {
            return RemoveGlobalPartnerParameter(freObjects);
        }
        if (functionName.equals(AdjustContext.RemoveGlobalPartnerParameters)) {
            return RemoveGlobalPartnerParameters();
        }
        if (functionName.equals(AdjustContext.IsEnabled)) {
            return IsEnabled(freContext);
        }
        if (functionName.equals(AdjustContext.GetAdid)) {
            return GetAdid(freContext);
        }
        if (functionName.equals(AdjustContext.GetAttribution)) {
            return GetAttribution(freContext);
        }
        if (functionName.equals(AdjustContext.GetSdkVersion)) {
            return GetSdkVersion(freContext);
        }
        if (functionName.equals(AdjustContext.GetLastDeeplink)) {
            return GetLastDeeplink(freContext);
        }
        // android only methods
        if (functionName.equals(AdjustContext.TrackPlayStoreSubscription)) {
            return TrackPlayStoreSubscription(freObjects);
        }
        if (functionName.equals(AdjustContext.VerifyPlayStorePurchase)) {
            return VerifyPlayStorePurchase(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.VerifyAndTrackPlayStorePurchase)) {
            return VerifyAndTrackPlayStorePurchase(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.GetGoogleAdId)) {
            return GetGoogleAdId(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.GetAmazonAdId)) {
            return GetAmazonAdId(freContext, freObjects);
        }
        // ios only methods
        if (functionName.equals(AdjustContext.TrackAppStoreSubscription)) {
            return TrackAppStoreSubscription();
        }
        if (functionName.equals(AdjustContext.VerifyAppStorePurchase)) {
            return VerifyAppStorePurchase(freContext);
        }
        if (functionName.equals(AdjustContext.VerifyAndTrackAppStorePurchase)) {
            return VerifyAndTrackAppStorePurchase(freContext);
        }
        if (functionName.equals(AdjustContext.GetIdfa)) {
            return GetIdfa(freContext);
        }
        if (functionName.equals(AdjustContext.GetIdfv)) {
            return GetIdfv(freContext);
        }
        if (functionName.equals(AdjustContext.GetAppTrackingStatus)) {
            return GetAppTrackingStatus(freContext);
        }
        if (functionName.equals(AdjustContext.RequestAppTrackingAuthorization)) {
            return RequestAppTrackingAuthorization(freContext);
        }
        if (functionName.equals(AdjustContext.UpdateSkanConversionValue)) {
            return UpdateSkanConversionValue(freContext);
        }
        // test only methods
        if (functionName.equals(AdjustContext.OnResume)) {
            return OnResume();
        }
        if (functionName.equals(AdjustContext.OnPause)) {
            return OnPause();
        }
        if (functionName.equals(AdjustContext.SetTestOptions)) {
            return SetTestOptions(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.Teardown)) {
            return Teardown();
        }

        return null;
    }

    // common

    private FREObject InitSdk(FREContext freContext, FREObject[] freObjects) {
        try {
            String appToken = null;
            String environment = null;
            String logLevel = null;
            boolean allowSuppressLogLevel = false;

            // app token [0]
            if (freObjects[0] != null) {
                appToken = freObjects[0].getAsString();
            }

            // environment [1]
            if (freObjects[1] != null) {
                environment = freObjects[1].getAsString();
            }

            // log level [2]
            if (freObjects[2] != null) {
                logLevel = freObjects[2].getAsString();
            }

            // check if suppress log level is selected
            if (logLevel != null && logLevel.equals("suppress")) {
                allowSuppressLogLevel = true;
            }

            AdjustConfig adjustConfig = new AdjustConfig(
                    freContext.getActivity(),
                    appToken,
                    environment,
                    allowSuppressLogLevel);

            if (logLevel != null) {
                switch (logLevel) {
                    case "verbose":
                        adjustConfig.setLogLevel(LogLevel.VERBOSE);
                        break;
                    case "debug":
                        adjustConfig.setLogLevel(LogLevel.DEBUG);
                        break;
                    case "warn":
                        adjustConfig.setLogLevel(LogLevel.WARN);
                        break;
                    case "error":
                        adjustConfig.setLogLevel(LogLevel.ERROR);
                        break;
                    case "assert":
                        adjustConfig.setLogLevel(LogLevel.ASSERT);
                        break;
                    case "suppress":
                        adjustConfig.setLogLevel(LogLevel.SUPPRESS);
                        break;
                    default:
                        adjustConfig.setLogLevel(LogLevel.INFO);
                        break;
                }
            }

            // SDK prefix [3]
            if (freObjects[3] != null) {
                String sdkPrefix = freObjects[3].getAsString();
                if (sdkPrefix != null) {
                    adjustConfig.setSdkPrefix(sdkPrefix);
                }
            }

            // default tracker [4]
            if (freObjects[4] != null) {
                String defaultTracker = freObjects[4].getAsString();
                if (defaultTracker != null) {
                    adjustConfig.setDefaultTracker(defaultTracker);
                }
            }

            // external device ID [5]
            if (freObjects[5] != null) {
                String externalDeviceId = freObjects[5].getAsString();
                if (externalDeviceId != null) {
                    adjustConfig.setExternalDeviceId(externalDeviceId);
                }
            }

            // COPPA compliance [6]
            if (freObjects[6] != null) {
                boolean isCoppaComplianceEnabled = freObjects[6].getAsBool();
                if (isCoppaComplianceEnabled) {
                    adjustConfig.enableCoppaCompliance();
                }
            }

            // send in background [7]
            if (freObjects[7] != null) {
                boolean isSendingInBackgroundEnabled = freObjects[7].getAsBool();
                if (isSendingInBackgroundEnabled) {
                    adjustConfig.enableSendingInBackground();
                }
            }

            // should deferred deep link be opened [8]
            if (freObjects[8] != null) {
                shouldLaunchDeeplink = freObjects[8].getAsBool();
            }

            // cost data in attribution callback [9]
            if (freObjects[9] != null) {
                boolean isCostDataInAttributionEnabled = freObjects[9].getAsBool();
                if (isCostDataInAttributionEnabled) {
                    adjustConfig.enableCostDataInAttribution();
                }
            }

            // read device info only once [10]
            if (freObjects[10] != null) {
                boolean isDeviceIdsReadingOnceEnabled = freObjects[10].getAsBool();
                if (isDeviceIdsReadingOnceEnabled) {
                    adjustConfig.enableDeviceIdsReadingOnce();
                }
            }

            // attribution callback [11]
            if (freObjects[11] != null) {
                boolean isAttributionCallbackSet = freObjects[11].getAsBool();
                if (isAttributionCallbackSet) {
                    adjustConfig.setOnAttributionChangedListener(this);
                }
            }

            // event tracking success callback [12]
            if (freObjects[12] != null) {
                boolean isEventSuccessCallbackSet = freObjects[12].getAsBool();
                if (isEventSuccessCallbackSet) {
                    adjustConfig.setOnEventTrackingSucceededListener(this);
                }
            }

            // event tracking failure callback [13]
            if (freObjects[13] != null) {
                boolean isEventFailureCallbackSet = freObjects[13].getAsBool();
                if (isEventFailureCallbackSet) {
                    adjustConfig.setOnEventTrackingFailedListener(this);
                }
            }

            // session tracking success callback [14]
            if (freObjects[14] != null) {
                boolean isSessionSuccessCallbackSet = freObjects[14].getAsBool();
                if (isSessionSuccessCallbackSet) {
                    adjustConfig.setOnSessionTrackingSucceededListener(this);
                }
            }

            // session tracking failure callback [15]
            if (freObjects[15] != null) {
                boolean isSessionFailureCallbackSet = freObjects[15].getAsBool();
                if (isSessionFailureCallbackSet) {
                    adjustConfig.setOnSessionTrackingFailedListener(this);
                }
            }

            // deferred deep link callback [16]
            if (freObjects[16] != null) {
                boolean isDeferredDeeplinkCallbackSet = freObjects[16].getAsBool();
                if (isDeferredDeeplinkCallbackSet) {
                    adjustConfig.setOnDeferredDeeplinkResponseListener(this);
                }
            }

            // event deduplication buffer size [17]
            if (freObjects[17] != null) {
                int eventDeduplicationIdsMaxSize = freObjects[17].getAsInt();
                adjustConfig.setEventDeduplicationIdsMaxSize(eventDeduplicationIdsMaxSize);
            }

            // URL strategy subdomains [18]
            // URL strategy use subdomains [19]
            // URL strategy is data residency [20]
            if (freObjects[18] != null && freObjects[19] != null && freObjects[20] != null) {
                ArrayList<String> urlDomains = new ArrayList<>();
                boolean useSubdomains = freObjects[19].getAsBool();
                boolean isDataResidency = freObjects[20].getAsBool();
                for (int i = 0; i < ((FREArray) freObjects[18]).getLength(); i += 1) {
                    if (((FREArray) freObjects[18]).getObjectAt(i) != null) {
                        urlDomains.add(((FREArray) freObjects[18]).getObjectAt(i).getAsString());
                    }
                }
                adjustConfig.setUrlStrategy(urlDomains, useSubdomains, isDataResidency);
            }

            // META install referrer [21]
            if (freObjects[21] != null) {
                String fbAppId = freObjects[21].getAsString();
                if (fbAppId != null) {
                    adjustConfig.setFbAppId(fbAppId);
                }
            }

            // process name [22]
            if (freObjects[22] != null) {
                String processName = freObjects[22].getAsString();
                if (processName != null) {
                    adjustConfig.setProcessName(processName);
                }
            }

            // preinstall file path [23]
            if (freObjects[23] != null) {
                String preinstallFilePath = freObjects[23].getAsString();
                if (preinstallFilePath != null) {
                    adjustConfig.setPreinstallFilePath(preinstallFilePath);
                }
            }

            // preinstall tracking [24]
            if (freObjects[24] != null) {
                boolean isPreinstallTrackingEnabled = freObjects[24].getAsBool();
                if (isPreinstallTrackingEnabled) {
                    adjustConfig.enablePreinstallTracking();
                }
            }

            // play store kids compliance [25]
            if (freObjects[25] != null) {
                boolean isPlayStoreKidsComplianceEnabled = freObjects[25].getAsBool();
                if (isPlayStoreKidsComplianceEnabled) {
                    adjustConfig.enablePlayStoreKidsCompliance();
                }
            }

            Adjust.initSdk(adjustConfig);
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, "" + e.getMessage());
        }

        return null;
    }

    private FREObject Enable() {
        Adjust.enable();
        return null;
    }

    private FREObject Disable() {
        Adjust.disable();
        return null;
    }

    private FREObject SwitchToOfflineMode() {
        Adjust.switchToOfflineMode();
        return null;
    }

    private FREObject SwitchBackToOnlineMode() {
        Adjust.switchBackToOnlineMode();
        return null;
    }

    private FREObject TrackEvent(FREObject[] freObjects) {
        try {
            String eventToken = null;

            // event token [0]
            if (freObjects[0] != null) {
                eventToken = freObjects[0].getAsString();
            }

            AdjustEvent adjustEvent = new AdjustEvent(eventToken);

            // revenue [1]
            // currency [2]
            if (freObjects[2] != null) {
                String currency = freObjects[2].getAsString();
                if (freObjects[1] != null) {
                    double revenue = freObjects[1].getAsDouble();
                    adjustEvent.setRevenue(revenue, currency);
                }
            }

            // callback ID [3]
            if (freObjects[3] != null) {
                String callbackId = freObjects[3].getAsString();
                adjustEvent.setCallbackId(callbackId);
            }

            // deduplication ID [4]
            if (freObjects[4] != null) {
                String deduplicationId = freObjects[4].getAsString();
                adjustEvent.setDeduplicationId(deduplicationId);
            }

            // product ID [5]
            if (freObjects[5] != null) {
                String productId = freObjects[5].getAsString();
                adjustEvent.setProductId(productId);
            }

            // callback parameters [6]
            if (freObjects[6] != null) {
                for (int i = 0; i < ((FREArray) freObjects[6]).getLength(); i += 2) {
                    String key = null;
                    String value = null;
                    if (((FREArray) freObjects[6]).getObjectAt(i) != null) {
                        key = ((FREArray) freObjects[6]).getObjectAt(i).getAsString();
                    }
                    if (((FREArray) freObjects[6]).getObjectAt(i + 1) != null) {
                        value = ((FREArray) freObjects[6]).getObjectAt(i + 1).getAsString();
                    }
                    if (key != null && key.equals("ADJ__NULL")) {
                        key = null;
                    }
                    if (value != null && value.equals("ADJ__NULL")) {
                        value = null;
                    }
                    adjustEvent.addCallbackParameter(key, value);
                }
            }

            // partner parameters [7]
            if (freObjects[7] != null) {
                for (int i = 0; i < ((FREArray) freObjects[7]).getLength(); i += 2) {
                    String key = null;
                    String value = null;
                    if (((FREArray) freObjects[7]).getObjectAt(i) != null) {
                        key = ((FREArray) freObjects[7]).getObjectAt(i).getAsString();
                    }
                    if (((FREArray) freObjects[7]).getObjectAt(i + 1) != null) {
                        value = ((FREArray) freObjects[7]).getObjectAt(i + 1).getAsString();
                    }
                    if (key != null && key.equals("ADJ__NULL")) {
                        key = null;
                    }
                    if (value != null && value.equals("ADJ__NULL")) {
                        value = null;
                    }
                    adjustEvent.addPartnerParameter(key, value);
                }
            }

            // purchase token [9]
            if (freObjects[9] != null) {
                String purchaseToken = freObjects[9].getAsString();
                adjustEvent.setPurchaseToken(purchaseToken);
            }

            Adjust.trackEvent(adjustEvent);
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, "" + e.getMessage());
        }

       return null;
    }

    private FREObject TrackAdRevenue(FREObject[] freObjects) {
        try {
            String source = null;

            // source [0]
            if (freObjects[0] != null) {
                source = freObjects[0].getAsString();
            }

            AdjustAdRevenue adjustAdRevenue = new AdjustAdRevenue(source);

            // revenue [1]
            // currency [2]
            if (freObjects[2] != null) {
                String currency = freObjects[2].getAsString();
                if (freObjects[1] != null) {
                    double revenue = freObjects[1].getAsDouble();
                    adjustAdRevenue.setRevenue(revenue, currency);
                }
            }

            // ad impressions count [3]
            if (freObjects[3] != null) {
                int adImpressionsCount = freObjects[3].getAsInt();
                adjustAdRevenue.setAdImpressionsCount(adImpressionsCount);
            }

            // ad revenue network [4]
            if (freObjects[4] != null) {
                String adRevenueNetwork = freObjects[4].getAsString();
                if (adRevenueNetwork != null) {
                    adjustAdRevenue.setAdRevenueNetwork(adRevenueNetwork);
                }
            }

            // ad revenue unit [5]
            if (freObjects[5] != null) {
                String adRevenueUnit = freObjects[5].getAsString();
                if (adRevenueUnit != null) {
                    adjustAdRevenue.setAdRevenueUnit(adRevenueUnit);
                }
            }

            // ad revenue placement [6]
            if (freObjects[6] != null) {
                String adRevenuePlacement = freObjects[6].getAsString();
                if (adRevenuePlacement != null) {
                    adjustAdRevenue.setAdRevenuePlacement(adRevenuePlacement);
                }
            }

            // callback parameters [7]
            if (freObjects[7] != null) {
                for (int i = 0; i < ((FREArray) freObjects[7]).getLength(); i += 2) {
                    String key = null;
                    String value = null;
                    if (((FREArray) freObjects[7]).getObjectAt(i) != null) {
                        key = ((FREArray) freObjects[7]).getObjectAt(i).getAsString();
                    }
                    if (((FREArray) freObjects[7]).getObjectAt(i + 1) != null) {
                        value = ((FREArray) freObjects[7]).getObjectAt(i + 1).getAsString();
                    }
                    if (key != null && key.equals("ADJ__NULL")) {
                        key = null;
                    }
                    if (value != null && value.equals("ADJ__NULL")) {
                        value = null;
                    }
                    adjustAdRevenue.addCallbackParameter(key, value);
                }
            }

            // partner parameters [8]
            if (freObjects[7] != null) {
                for (int i = 0; i < ((FREArray) freObjects[8]).getLength(); i += 2) {
                    String key = null;
                    String value = null;
                    if (((FREArray) freObjects[8]).getObjectAt(i) != null) {
                        key = ((FREArray) freObjects[8]).getObjectAt(i).getAsString();
                    }
                    if (((FREArray) freObjects[8]).getObjectAt(i + 1) != null) {
                        value = ((FREArray) freObjects[8]).getObjectAt(i + 1).getAsString();
                    }
                    if (key != null && key.equals("ADJ__NULL")) {
                        key = null;
                    }
                    if (value != null && value.equals("ADJ__NULL")) {
                        value = null;
                    }
                    adjustAdRevenue.addPartnerParameter(key, value);
                }
            }

            Adjust.trackAdRevenue(adjustAdRevenue);
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, "" + e.getMessage());
        }

        return null;
    }

    private FREObject TrackThirdPartySharing(FREObject[] freObjects) {
        try {
            // isEnabled [0]
            Boolean isEnabled = null;
            if (freObjects[0] != null) {
                String strIsEnabled = freObjects[0].getAsString();
                isEnabled = Boolean.valueOf(strIsEnabled);
            }

            AdjustThirdPartySharing adjustThirdPartySharing = new AdjustThirdPartySharing(isEnabled);

            // granular options [1]
            if (freObjects[1] != null) {
                for (int i = 0; i < ((FREArray) freObjects[1]).getLength(); i += 3) {
                    String partnerName = null;
                    String key = null;
                    String value = null;
                    if (((FREArray) freObjects[1]).getObjectAt(i) != null) {
                        partnerName = ((FREArray) freObjects[1]).getObjectAt(i).getAsString();
                    }
                    if (((FREArray) freObjects[1]).getObjectAt(i + 1) != null) {
                        key = ((FREArray) freObjects[1]).getObjectAt(i + 1).getAsString();
                    }
                    if (((FREArray) freObjects[1]).getObjectAt(i + 2) != null) {
                        value = ((FREArray) freObjects[1]).getObjectAt(i + 2).getAsString();
                    }
                    if (partnerName != null && partnerName.equals("ADJ__NULL")) {
                        partnerName = null;
                    }
                    if (key != null && key.equals("ADJ__NULL")) {
                        key = null;
                    }
                    if (value != null && value.equals("ADJ__NULL")) {
                        value = null;
                    }
                    adjustThirdPartySharing.addGranularOption(partnerName, key, value);
                }
            }

            // partner sharing settings [2]
            if (freObjects[2] != null) {
                for (int i = 0; i < ((FREArray) freObjects[2]).getLength(); i += 3) {
                    String partnerName = null;
                    String key = null;
                    String value = null;
                    if (((FREArray) freObjects[2]).getObjectAt(i) != null) {
                        partnerName = ((FREArray) freObjects[2]).getObjectAt(i).getAsString();
                    }
                    if (((FREArray) freObjects[2]).getObjectAt(i + 1) != null) {
                        key = ((FREArray) freObjects[2]).getObjectAt(i + 1).getAsString();
                    }
                    if (((FREArray) freObjects[2]).getObjectAt(i + 2) != null) {
                        value = ((FREArray) freObjects[2]).getObjectAt(i + 2).getAsString();
                    }
                    if (partnerName != null && partnerName.equals("ADJ__NULL")) {
                        partnerName = null;
                    }
                    if (key != null && key.equals("ADJ__NULL")) {
                        key = null;
                    }
                    adjustThirdPartySharing.addPartnerSharingSetting(
                            partnerName,
                            key,
                            Boolean.valueOf(value));
                }
            }

            Adjust.trackThirdPartySharing(adjustThirdPartySharing);
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, "" + e.getMessage());
        }

        return null;
    }

    private FREObject TrackMeasurementConsent(FREObject[] freObjects) {
        try {
            if (freObjects[0] != null) {
                Adjust.trackMeasurementConsent(freObjects[0].getAsBool());
            }
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, "" + e.getMessage());
        }

        return null;
    }

    private FREObject ProcessDeeplink(FREContext freContext, FREObject[] freObjects) {
        try {
            String deeplink = null;
            if (freObjects[0] != null) {
                deeplink = freObjects[0].getAsString();
            }
            AdjustDeeplink adjustDeeplink = new AdjustDeeplink(Uri.parse(deeplink));
            Adjust.processDeeplink(adjustDeeplink, freContext.getActivity());
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, "" + e.getMessage());
        }

        return null;
    }

    private FREObject ProcessAndResolveDeeplink(FREContext freContext, FREObject[] freObjects) {
        try {
            String deeplink = null;
            if (freObjects[0] != null) {
                deeplink = freObjects[0].getAsString();
            }
            AdjustDeeplink adjustDeeplink = new AdjustDeeplink(Uri.parse(deeplink));
            Adjust.processAndResolveDeeplink(
                    adjustDeeplink,
                    freContext.getActivity(),
                    new OnDeeplinkResolvedListener() {
                        @Override
                        public void onDeeplinkResolved(String resolvedLink) {
                            freContext.dispatchStatusEventAsync(
                                    "adjust_processAndResolveDeeplink",
                                    resolvedLink != null ? resolvedLink : "ADJ__NULL");
                        }
                    });
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, "" + e.getMessage());
        }

        return null;
    }

    private FREObject SetPushToken(FREContext freContext, FREObject[] freObjects) {
        try {
            String pushToken = null;
            if (freObjects[0] != null) {
                pushToken = freObjects[0].getAsString();
            }
            Adjust.setPushToken(pushToken, freContext.getActivity());
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, "" + e.getMessage());
        }

        return null;
    }

    private FREObject GdprForgetMe(FREContext freContext) {
        try {
            Adjust.gdprForgetMe(freContext.getActivity());
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, "" + e.getMessage());
        }

        return null;
    }

    private FREObject AddGlobalCallbackParameter(FREObject[] freObjects) {
        try {
            String key = null;
            String value = null;
            if (freObjects[0] != null) {
                key = freObjects[0].getAsString();
            }
            if (freObjects[1] != null) {
                value = freObjects[1].getAsString();
            }
            Adjust.addGlobalCallbackParameter(key, value);
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, "" + e.getMessage());
        }

        return null;
    }

    private FREObject RemoveGlobalCallbackParameter(FREObject[] freObjects) {
        try {
            String key = null;
            if (freObjects[0] != null) {
                key = freObjects[0].getAsString();
            }
            Adjust.removeGlobalCallbackParameter(key);
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, "" + e.getMessage());
        }

        return null;
    }

    private FREObject RemoveGlobalCallbackParameters() {
        try {
            Adjust.removeGlobalCallbackParameters();
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, "" + e.getMessage());
        }

        return null;
    }

    private FREObject AddGlobalPartnerParameter(FREObject[] freObjects) {
        try {
            String key = null;
            String value = null;
            if (freObjects[0] != null) {
                key = freObjects[0].getAsString();
            }
            if (freObjects[1] != null) {
                value = freObjects[1].getAsString();
            }
            Adjust.addGlobalPartnerParameter(key, value);
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, "" + e.getMessage());
        }

        return null;
    }

    private FREObject RemoveGlobalPartnerParameter(FREObject[] freObjects) {
        try {
            String key = null;
            if (freObjects[0] != null) {
                key = freObjects[0].getAsString();
            }
            Adjust.removeGlobalPartnerParameter(key);
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, "" + e.getMessage());
        }

        return null;
    }

    private FREObject RemoveGlobalPartnerParameters() {
        try {
            Adjust.removeGlobalPartnerParameters();
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, "" + e.getMessage());
        }

        return null;
    }

    private FREObject IsEnabled(final FREContext freContext) {
        Adjust.isEnabled(freContext.getActivity(), new OnIsEnabledListener() {
            @Override
            public void onIsEnabledRead(boolean isEnabled) {
                freContext.dispatchStatusEventAsync(
                        "adjust_isEnabled",
                        isEnabled ? "true" : "false");
            }
        });

        return null;
    }

    private FREObject GetAdid(final FREContext freContext) {
        Adjust.getAdid(new OnAdidReadListener() {
            @Override
            public void onAdidRead(String adid) {
                freContext.dispatchStatusEventAsync(
                        "adjust_getAdid",
                        adid != null ? adid : "ADJ__NULL");
            }
        });

        return null;
    }

    private FREObject GetAttribution(final FREContext freContext) {
        Adjust.getAttribution(new OnAttributionReadListener() {
            @Override
            public void onAttributionRead(AdjustAttribution attribution) {
                if (attribution == null) {
                    freContext.dispatchStatusEventAsync("adjust_getAttribution", "ADJ__NULL");
                    return;
                }

                String response = "trackerToken==" + attribution.trackerToken + "__"
                        + "trackerName==" + attribution.trackerName + "__"
                        + "campaign==" + attribution.campaign + "__"
                        + "network==" + attribution.network + "__"
                        + "creative==" + attribution.creative + "__"
                        + "adgroup==" + attribution.adgroup + "__"
                        + "clickLabel==" + attribution.clickLabel + "__"
                        + "costType==" + attribution.costType + "__"
                        + "costAmount==" + (attribution.costAmount.isNaN() ? "" : attribution.costAmount.toString()) + "__"
                        + "costCurrency==" + attribution.costCurrency + "__"
                        + "fbInstallReferrer==" + attribution.fbInstallReferrer;
                freContext.dispatchStatusEventAsync("adjust_getAttribution", response);
            }
        });

        return null;
    }

    private FREObject GetSdkVersion(final FREContext freContext) {
        Adjust.getSdkVersion(new OnSdkVersionReadListener() {
            @Override
            public void onSdkVersionRead(String sdkVersion) {
                freContext.dispatchStatusEventAsync(
                        "adjust_getSdkVersion",
                        sdkVersion != null ? sdkVersion : "ADJ__NULL");
            }
        });

        return null;
    }

    private FREObject GetLastDeeplink(final FREContext freContext) {
        Adjust.getLastDeeplink(
                freContext.getActivity(),
                new OnLastDeeplinkReadListener() {
            @Override
            public void onLastDeeplinkRead(Uri deeplink) {
                freContext.dispatchStatusEventAsync(
                        "adjust_getLastDeeplink",
                        deeplink != null ? deeplink.toString() : "ADJ__NULL");
            }
        });

        return null;
    }

    // android only

    private FREObject TrackPlayStoreSubscription(FREObject[] freObjects) {
        try {
            long price = -1;
            String currency = null;
            String sku = null;
            String orderId = null;
            String signature = null;
            String purchaseToken = null;

            // price [0]
            if (freObjects[0] != null) {
                // using string not to lose precision (long vs. getAsInt())
                String strPrice = freObjects[0].getAsString();
                price = Long.parseLong(strPrice);
            }

            // currency [1]
            if (freObjects[1] != null) {
                currency = freObjects[1].getAsString();
            }

            // SKU [2]
            if (freObjects[2] != null) {
                sku = freObjects[2].getAsString();
            }

            // order ID [3]
            if (freObjects[3] != null) {
                orderId = freObjects[3].getAsString();
            }

            // signature [4]
            if (freObjects[4] != null) {
                signature = freObjects[4].getAsString();
            }

            // purchase token [5]
            if (freObjects[5] != null) {
                purchaseToken = freObjects[5].getAsString();
            }

            AdjustPlayStoreSubscription adjustPlayStoreSubscription = new AdjustPlayStoreSubscription(
                    price,
                    currency,
                    sku,
                    orderId,
                    signature,
                    purchaseToken);

            // purchase time [6]
            if (freObjects[6] != null) {
                String strPurchaseTime = freObjects[6].getAsString();
                long purchaseTime = Long.parseLong(strPurchaseTime);
                adjustPlayStoreSubscription.setPurchaseTime(purchaseTime);
            }

            // callback parameters [7]
            if (freObjects[7] != null) {
                for (int i = 0; i < ((FREArray) freObjects[7]).getLength(); i += 2) {
                    String key = null;
                    String value = null;
                    if (((FREArray) freObjects[7]).getObjectAt(i) != null) {
                        key = ((FREArray) freObjects[7]).getObjectAt(i).getAsString();
                    }
                    if (((FREArray) freObjects[7]).getObjectAt(i + 1) != null) {
                        value = ((FREArray) freObjects[7]).getObjectAt(i + 1).getAsString();
                    }
                    if (key != null && key.equals("ADJ__NULL")) {
                        key = null;
                    }
                    if (value != null && value.equals("ADJ__NULL")) {
                        value = null;
                    }
                    adjustPlayStoreSubscription.addCallbackParameter(key, value);
                }
            }

            // partner parameters [8]
            if (freObjects[8] != null) {
                for (int i = 0; i < ((FREArray) freObjects[8]).getLength(); i += 2) {
                    String key = null;
                    String value = null;
                    if (((FREArray) freObjects[8]).getObjectAt(i) != null) {
                        key = ((FREArray) freObjects[8]).getObjectAt(i).getAsString();
                    }
                    if (((FREArray) freObjects[8]).getObjectAt(i + 1) != null) {
                        value = ((FREArray) freObjects[8]).getObjectAt(i + 1).getAsString();
                    }
                    if (key != null && key.equals("ADJ__NULL")) {
                        key = null;
                    }
                    if (value != null && value.equals("ADJ__NULL")) {
                        value = null;
                    }
                    adjustPlayStoreSubscription.addPartnerParameter(key, value);
                }
            }

            Adjust.trackPlayStoreSubscription(adjustPlayStoreSubscription);
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, "" + e.getMessage());
        }

        return null;
    }

    private FREObject VerifyPlayStorePurchase(FREContext freContext, FREObject[] freObjects) {
        try {
            String productId = null;
            String purchaseToken = null;

            // product ID [0]
            if (freObjects[0] != null) {
                productId = freObjects[0].getAsString();
            }

            // purchase token [1]
            if (freObjects[1] != null) {
                purchaseToken = freObjects[1].getAsString();
            }

            AdjustPlayStorePurchase adjustPlayStorePurchase = new AdjustPlayStorePurchase(
                    productId,
                    purchaseToken);
            Adjust.verifyPlayStorePurchase(
                    adjustPlayStorePurchase,
                    new OnPurchaseVerificationFinishedListener() {
                @Override
                public void onVerificationFinished(AdjustPurchaseVerificationResult result) {
                    if (result == null) {
                        freContext.dispatchStatusEventAsync(
                                "adjust_verifyPlayStorePurchase",
                                "ADJ__NULL");
                        return;
                    }

                    String response = "verificationStatus==" + result.getVerificationStatus() + "__"
                            + "message==" + result.getMessage() + "__"
                            + "code==" + result.getCode();
                    freContext.dispatchStatusEventAsync("adjust_verifyPlayStorePurchase", response);
                }
            });
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, "" + e.getMessage());
        }

        return null;
    }

    private FREObject VerifyAndTrackPlayStorePurchase(FREContext freContext, FREObject[] freObjects) {
        try {
            String eventToken = null;

            // event token [0]
            if (freObjects[0] != null) {
                eventToken = freObjects[0].getAsString();
            }

            AdjustEvent adjustEvent = new AdjustEvent(eventToken);

            // revenue [1]
            // currency [2]
            if (freObjects[2] != null) {
                String currency = freObjects[2].getAsString();
                if (freObjects[1] != null) {
                    double revenue = freObjects[1].getAsDouble();
                    adjustEvent.setRevenue(revenue, currency);
                }
            }

            // callback ID [3]
            if (freObjects[3] != null) {
                String callbackId = freObjects[3].getAsString();
                adjustEvent.setCallbackId(callbackId);
            }

            // deduplication ID [4]
            if (freObjects[4] != null) {
                String deduplicationId = freObjects[4].getAsString();
                adjustEvent.setDeduplicationId(deduplicationId);
            }

            // product ID [5]
            if (freObjects[5] != null) {
                String productId = freObjects[5].getAsString();
                adjustEvent.setProductId(productId);
            }

            // callback parameters [6]
            if (freObjects[6] != null) {
                for (int i = 0; i < ((FREArray) freObjects[6]).getLength(); i += 2) {
                    String key = null;
                    String value = null;
                    if (((FREArray) freObjects[6]).getObjectAt(i) != null) {
                        key = ((FREArray) freObjects[6]).getObjectAt(i).getAsString();
                    }
                    if (((FREArray) freObjects[6]).getObjectAt(i + 1) != null) {
                        value = ((FREArray) freObjects[6]).getObjectAt(i + 1).getAsString();
                    }
                    if (key != null && key.equals("ADJ__NULL")) {
                        key = null;
                    }
                    if (value != null && value.equals("ADJ__NULL")) {
                        value = null;
                    }
                    adjustEvent.addCallbackParameter(key, value);
                }
            }

            // partner parameters [7]
            if (freObjects[7] != null) {
                for (int i = 0; i < ((FREArray) freObjects[7]).getLength(); i += 2) {
                    String key = null;
                    String value = null;
                    if (((FREArray) freObjects[7]).getObjectAt(i) != null) {
                        key = ((FREArray) freObjects[7]).getObjectAt(i).getAsString();
                    }
                    if (((FREArray) freObjects[7]).getObjectAt(i + 1) != null) {
                        value = ((FREArray) freObjects[7]).getObjectAt(i + 1).getAsString();
                    }
                    if (key != null && key.equals("ADJ__NULL")) {
                        key = null;
                    }
                    if (value != null && value.equals("ADJ__NULL")) {
                        value = null;
                    }
                    adjustEvent.addPartnerParameter(key, value);
                }
            }

            // purchase token [9]
            if (freObjects[9] != null) {
                String purchaseToken = freObjects[9].getAsString();
                adjustEvent.setPurchaseToken(purchaseToken);
            }

            Adjust.verifyAndTrackPlayStorePurchase(
                    adjustEvent,
                    new OnPurchaseVerificationFinishedListener() {
                @Override
                public void onVerificationFinished(AdjustPurchaseVerificationResult result) {
                    if (result == null) {
                        freContext.dispatchStatusEventAsync(
                                "adjust_verifyAndTrackPlayStorePurchase",
                                "ADJ__NULL");
                        return;
                    }

                    String response = "verificationStatus==" + result.getVerificationStatus() + "__"
                            + "message==" + result.getMessage() + "__"
                            + "code==" + result.getCode();
                    freContext.dispatchStatusEventAsync(
                            "adjust_verifyAndTrackPlayStorePurchase",
                            response);
                }
            });
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, "" + e.getMessage());
        }

        return null;
    }

    private FREObject GetGoogleAdId(FREContext freContext, FREObject[] freObjects) {
        Adjust.getGoogleAdId(
                freContext.getActivity(),
                new OnGoogleAdIdReadListener() {
            @Override
            public void onGoogleAdIdRead(String googleAdId) {
                freContext.dispatchStatusEventAsync(
                        "adjust_getGoogleAdId",
                        googleAdId != null ? googleAdId : "ADJ__NULL");
            }
        });

        return null;
    }

    private FREObject GetAmazonAdId(FREContext freContext, FREObject[] freObjects) {
        Adjust.getAmazonAdId(
                freContext.getActivity(),
                new OnAmazonAdIdReadListener() {
            @Override
            public void onAmazonAdIdRead(String amazonAdId) {
                freContext.dispatchStatusEventAsync(
                        "adjust_getAmazonAdId",
                        amazonAdId != null ? amazonAdId : "ADJ__NULL");
            }
        });

        return null;
    }

    // ios only

    private FREObject TrackAppStoreSubscription() {
        return null;
    }

    private FREObject VerifyAppStorePurchase(FREContext freContext) {
        freContext.dispatchStatusEventAsync("adjust_verifyAppStorePurchase", "ADJ__NULL");
        return null;
    }

    private FREObject VerifyAndTrackAppStorePurchase(FREContext freContext) {
        freContext.dispatchStatusEventAsync("adjust_verifyAndTrackAppStorePurchase", "ADJ__NULL");
        return null;
    }

    private FREObject GetIdfa(FREContext freContext) {
        freContext.dispatchStatusEventAsync("adjust_getIdfa", "ADJ__NULL");
        return null;
    }

    private FREObject GetIdfv(FREContext freContext) {
        freContext.dispatchStatusEventAsync("adjust_getIdfv", "ADJ__NULL");
        return null;
    }

    private FREObject GetAppTrackingStatus(FREContext freContext) {
        freContext.dispatchStatusEventAsync("adjust_getAppTrackingStatus", "ADJ__NULL");
        return null;
    }

    private FREObject RequestAppTrackingAuthorization(FREContext freContext) {
        freContext.dispatchStatusEventAsync("adjust_requestAppTrackingAuthorization", "ADJ__NULL");
        return null;
    }

    private FREObject UpdateSkanConversionValue(FREContext freContext) {
        freContext.dispatchStatusEventAsync("adjust_updateSkanConversionValue", "ADJ__NULL");
        return null;
    }

    // test only

    private FREObject OnResume() {
        try {
            Adjust.onResume();
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, "" + e.getMessage());
        }

        return null;
    }

    private FREObject OnPause() {
        try {
            Adjust.onPause();
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, "" + e.getMessage());
        }

        return null;
    }

    private FREObject SetTestOptions(FREContext freContext, FREObject[] freObjects) {
        try {
            final AdjustTestOptions testOptions = new AdjustTestOptions();

            // delete state [11]
            if (freObjects[11] != null) {
                boolean deleteState = freObjects[11].getAsBool();
                if (deleteState) {
                    testOptions.context = freContext.getActivity();
                }
            }

            // URL overwrite [0]
            if (freObjects[0] != null) {
                String urlOverwrite = freObjects[0].getAsString();
                testOptions.baseUrl = urlOverwrite;
                testOptions.gdprUrl = urlOverwrite;
                testOptions.subscriptionUrl = urlOverwrite;
                testOptions.purchaseVerificationUrl = urlOverwrite;
            }

            // extra path [1]
            if (freObjects[1] != null) {
                String extraPath = freObjects[1].getAsString();
                testOptions.basePath = extraPath;
                testOptions.gdprPath = extraPath;
                testOptions.subscriptionPath = extraPath;
                testOptions.purchaseVerificationPath = extraPath;
            }

            // timer interval [2]
            if (freObjects[2] != null) {
                String strTimerInterval = freObjects[2].getAsString();
                testOptions.timerIntervalInMilliseconds = Long.parseLong(strTimerInterval);
            }

            // timer start [3]
            if (freObjects[3] != null) {
                String strTimerStart = freObjects[3].getAsString();
                testOptions.timerStartInMilliseconds = Long.parseLong(strTimerStart);
            }

            // session interval [4]
            if (freObjects[4] != null) {
                String strSessionInterval = freObjects[4].getAsString();
                testOptions.sessionIntervalInMilliseconds = Long.parseLong(strSessionInterval);
            }

            // subsession interval [5]
            if (freObjects[5] != null) {
                String strSubsessionInterval = freObjects[5].getAsString();
                testOptions.subsessionIntervalInMilliseconds = Long.parseLong(strSubsessionInterval);
            }

            // teardown [10]
            if (freObjects[10] != null) {
                testOptions.teardown = freObjects[10].getAsBool();
            }

            // no backoff wait [8]
            if (freObjects[8] != null) {
                testOptions.noBackoffWait = freObjects[8].getAsBool();
            }

            // ignore system lifecycle bootstrap [12]
            if (freObjects[12] != null) {
                testOptions.ignoreSystemLifecycleBootstrap = freObjects[12].getAsBool();
            }

            // not used anymore
            // if (freObjects[X] != null) {
            //     boolean value = freObjects[X].getAsBool();
            //     testOptions.useTestConnectionOptions = value;
            // }

            Adjust.setTestOptions(testOptions);
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, "" + e.getMessage());
        }

       return null;
    }

    private FREObject Teardown() {
        return null;
    }

    // native callbacks

    @Override
    public void onAttributionChanged(AdjustAttribution attribution) {
        if (attribution == null) {
            AdjustExtension.context.dispatchStatusEventAsync("adjust_attributionCallback", "ADJ__NULL");
            return;
        }

        String response = "trackerToken==" + attribution.trackerToken + "__"
                + "trackerName==" + attribution.trackerName + "__"
                + "campaign==" + attribution.campaign + "__"
                + "network==" + attribution.network + "__"
                + "creative==" + attribution.creative + "__"
                + "adgroup==" + attribution.adgroup + "__"
                + "clickLabel==" + attribution.clickLabel + "__"
                + "costType==" + attribution.costType + "__"
                + "costAmount==" + (attribution.costAmount.isNaN() ? "" : attribution.costAmount.toString()) + "__"
                + "costCurrency==" + attribution.costCurrency  + "__"
                + "fbInstallReferrer==" + attribution.fbInstallReferrer;
        AdjustExtension.context.dispatchStatusEventAsync("adjust_attributionCallback", response);
    }

    @Override
    public void onEventTrackingSucceeded(AdjustEventSuccess event) {
        if (event == null) {
            AdjustExtension.context.dispatchStatusEventAsync(
                    "adjust_eventSuccessCallback",
                    "ADJ__NULL");
            return;
        }

        StringBuilder response = new StringBuilder();
        response.append("message==" + event.message + "__"
                + "timestamp==" + event.timestamp + "__"
                + "adid==" + event.adid + "__"
                + "eventToken==" + event.eventToken + "__"
                + "callbackId==" + event.callbackId + "__");
        if (event.jsonResponse != null) {
            response.append("jsonResponse==" + event.jsonResponse.toString());
        }
        AdjustExtension.context.dispatchStatusEventAsync("adjust_eventSuccessCallback", response.toString());
    }

    @Override
    public void onEventTrackingFailed(AdjustEventFailure event) {
        if (event == null) {
            AdjustExtension.context.dispatchStatusEventAsync(
                    "adjust_eventFailureCallback",
                    "ADJ__NULL");
            return;
        }

        StringBuilder response = new StringBuilder();
        response.append("message==" + event.message + "__"
                + "timestamp==" + event.timestamp + "__"
                + "adid==" + event.adid + "__"
                + "eventToken==" + event.eventToken + "__"
                + "callbackId==" + event.callbackId + "__"
                + "willRetry==" + event.willRetry + "__");
        if (event.jsonResponse != null) {
            response.append("jsonResponse==" + event.jsonResponse.toString());
        }
        AdjustExtension.context.dispatchStatusEventAsync(
                "adjust_eventFailureCallback",
                response.toString());
    }

    @Override
    public void onSessionTrackingSucceeded(AdjustSessionSuccess event) {
        if (event == null) {
            AdjustExtension.context.dispatchStatusEventAsync(
                    "adjust_sessionSuccessCallback",
                    "ADJ__NULL");
            return;
        }

        StringBuilder response = new StringBuilder();
        response.append("message==" + event.message + "__"
                + "timestamp==" + event.timestamp + "__"
                + "adid==" + event.adid + "__");
        if (event.jsonResponse != null) {
            response.append("jsonResponse==" + event.jsonResponse.toString());
        }
        AdjustExtension.context.dispatchStatusEventAsync(
                "adjust_sessionSuccessCallback",
                response.toString());
    }

    @Override
    public void onSessionTrackingFailed(AdjustSessionFailure event) {
        if (event == null) {
            AdjustExtension.context.dispatchStatusEventAsync(
                    "adjust_sessionFailureCallback",
                    "ADJ__NULL");
            return;
        }

        StringBuilder response = new StringBuilder();
        response.append("message==" + event.message + "__"
                + "timestamp==" + event.timestamp + "__"
                + "adid==" + event.adid + "__"
                + "willRetry==" + event.willRetry + "__");
        if (event.jsonResponse != null) {
            response.append("jsonResponse==" + event.jsonResponse.toString());
        }
        AdjustExtension.context.dispatchStatusEventAsync(
                "adjust_sessionFailureCallback",
                response.toString());
    }

    @Override
    public boolean launchReceivedDeeplink(Uri deeplink) {
        if (deeplink == null) {
            AdjustExtension.context.dispatchStatusEventAsync(
                    "adjust_deferredDeeplinkCallback",
                    "ADJ__NULL");
        } else {
            String response = deeplink.toString();
            AdjustExtension.context.dispatchStatusEventAsync(
                    "adjust_deferredDeeplinkCallback",
                    response);
        }
        return shouldLaunchDeeplink;
    }
}
