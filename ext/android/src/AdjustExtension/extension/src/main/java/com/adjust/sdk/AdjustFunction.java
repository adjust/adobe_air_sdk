//
//  AdjustFunction.java
//  Adjust SDK
//
//  Created by Pedro Silva (@nonelse) on 31st July 2014.
//  Copyright (c) 2014-2018 Adjust GmbH. All rights reserved.
//

package com.adjust.sdk;

import java.lang.*;
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
       OnDeeplinkResponseListener {
    private String functionName;
    private Boolean shouldLaunchDeeplink;

    public AdjustFunction(String functionName) {
        this.functionName = functionName;
    }

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        AdjustExtension.context = (AdjustContext) freContext;

        if (functionName.equals(AdjustContext.OnCreate)) {
            return OnCreate(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.TrackEvent)) {
            return TrackEvent(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.SetEnabled)) {
            return SetEnabled(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.IsEnabled)) {
            return IsEnabled(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.OnResume)) {
            return OnResume(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.OnPause)) {
            return OnPause(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.AppWillOpenUrl)) {
            return AppWillOpenUrl(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.SetOfflineMode)) {
            return SetOfflineMode(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.SetReferrer)) {
            return SetReferrer(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.GetGoogleAdId)) {
            return GetGoogleAdId(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.GetAmazonAdId)) {
            return GetAmazonAdId(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.AddSessionCallbackParameter)) {
            return AddSessionCallbackParameter(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.RemoveSessionCallbackParameter)) {
            return RemoveSessionCallbackParameter(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.ResetSessionCallbackParameters)) {
            return ResetSessionCallbackParameters(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.AddSessionPartnerParameter)) {
            return AddSessionPartnerParameter(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.RemoveSessionPartnerParameter)) {
            return RemoveSessionPartnerParameter(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.ResetSessionPartnerParameters)) {
            return ResetSessionPartnerParameters(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.SetDeviceToken)) {
            return SetDeviceToken(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.SendFirstPackages)) {
            return SendFirstPackages(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.TrackAdRevenue)) {
            return TrackAdRevenue(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.GetAdid)) {
            return GetAdid(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.GetAttribution)) {
            return GetAttribution(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.GetSdkVersion)) {
            return GetSdkVersion(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.GdprForgetMe)) {
            return GdprForgetMe(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.DisableThirdPartySharing)) {
            return DisableThirdPartySharing(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.GetIdfa)) {
            return GetIdfa(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.RequestTrackingAuthorizationWithCompletionHandler)) {
            return RequestTrackingAuthorizationWithCompletionHandler(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.SetTestOptions)) {
            return SetTestOptions(freContext, freObjects);
        }
        if (functionName.equals(AdjustContext.Teardown)) {
            return Teardown(freContext, freObjects);
        }

        return null;
    }

    private FREObject OnCreate(FREContext freContext, FREObject[] freObjects) {
        try {
            String appToken = null;
            String environment = null;
            String logLevel = null;
            String secretId = null;
            String info1 = null;
            String info2 = null;
            String info3 = null;
            String info4 = null;
            boolean allowSuppressLogLevel = false;

            // App token.
            if (freObjects[0] != null) {
                appToken = freObjects[0].getAsString();
            }

            // Environment.
            if (freObjects[1] != null) {
                environment = freObjects[1].getAsString();
            }

            // Log level.
            if (freObjects[2] != null) {
                logLevel = freObjects[2].getAsString();
            }

            // Check if suppress log level is selected.
            if (logLevel != null && logLevel.equals("suppress")) {
                allowSuppressLogLevel = true;
            }

            AdjustConfig adjustConfig = new AdjustConfig(freContext.getActivity(), appToken, environment, allowSuppressLogLevel);
            if (!adjustConfig.isValid()) {
                return null;
            }

            // Log level.
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
                        adjustConfig.setLogLevel(LogLevel.SUPRESS);
                        break;
                    default:
                        adjustConfig.setLogLevel(LogLevel.INFO);
                        break;
                }
            }

            // Event buffering.
            if (freObjects[3] != null) {
                Boolean eventBuffering = freObjects[3].getAsBool();
                adjustConfig.setEventBufferingEnabled(eventBuffering);
            }

            // Attribution callback.
            if (freObjects[4] != null) {
                Boolean isAttributionCallbackSet = freObjects[4].getAsBool();
                if (isAttributionCallbackSet) {
                    adjustConfig.setOnAttributionChangedListener(this);
                }
            }

            // Event tracking success callback.
            if (freObjects[5] != null) {
                Boolean isCallbackSet = freObjects[5].getAsBool();
                if (isCallbackSet) {
                    adjustConfig.setOnEventTrackingSucceededListener(this);
                }
            }

            // Event tracking failure callback.
            if (freObjects[6] != null) {
                Boolean isCallbackSet = freObjects[6].getAsBool();
                if (isCallbackSet) {
                    adjustConfig.setOnEventTrackingFailedListener(this);
                }
            }

            // Session tracking success callback.
            if (freObjects[7] != null) {
                Boolean isCallbackSet = freObjects[7].getAsBool();
                if (isCallbackSet) {
                    adjustConfig.setOnSessionTrackingSucceededListener(this);
                }
            }

            // Session tracking failure callback.
            if (freObjects[8] != null) {
                Boolean isCallbackSet = freObjects[8].getAsBool();
                if (isCallbackSet) {
                    adjustConfig.setOnSessionTrackingFailedListener(this);
                }
            }

            // Deferred deep link callback.
            if (freObjects[9] != null) {
                Boolean isCallbackSet = freObjects[9].getAsBool();
                if (isCallbackSet) {
                    adjustConfig.setOnDeeplinkResponseListener(this);
                }
            }

            // Default tracker.
            if (freObjects[10] != null) {
                String defaultTracker = freObjects[10].getAsString();
                if (defaultTracker != null) {
                    adjustConfig.setDefaultTracker(defaultTracker);
                }
            }

            // SDK prefix.
            if (freObjects[11] != null) {
                String sdkPrefix = freObjects[11].getAsString();
                if (sdkPrefix != null) {
                    adjustConfig.setSdkPrefix(sdkPrefix);
                }
            }

            // Should deferred deep link be launched.
            if (freObjects[12] != null) {
                shouldLaunchDeeplink = freObjects[12].getAsBool();
            }

            // Process name.
            if (freObjects[13] != null) {
                String processName = freObjects[13].getAsString();
                adjustConfig.setProcessName(processName);
            }

            // Delay start.
            if (freObjects[14] != null) {
                double delayStart = freObjects[14].getAsDouble();
                adjustConfig.setDelayStart(delayStart);
            }

            // User agent.
            if (freObjects[15] != null) {
                String userAgent = freObjects[15].getAsString();
                adjustConfig.setUserAgent(userAgent);
            }

            // Send in background.
            if (freObjects[16] != null) {
                boolean sendInBackground = freObjects[16].getAsBool();
                adjustConfig.setSendInBackground(sendInBackground);
            }

            // App secret.
            if (freObjects[17] != null) {
                secretId = freObjects[17].getAsString();
            }

            if (freObjects[18] != null) {
                info1 = freObjects[18].getAsString();
            }

            if (freObjects[19] != null) {
                info2 = freObjects[19].getAsString();
            }

            if (freObjects[20] != null) {
                info3 = freObjects[20].getAsString();
            }

            if (freObjects[21] != null) {
                info4 = freObjects[21].getAsString();
            }

            if (secretId != null && info1 != null && info2 != null && info3 != null && info4 != null) {
                try {
                    long lSecretId = Long.parseLong(secretId, 10);
                    long lInfo1 = Long.parseLong(info1, 10);
                    long lInfo2 = Long.parseLong(info2, 10);
                    long lInfo3 = Long.parseLong(info3, 10);
                    long lInfo4 = Long.parseLong(info4, 10);
                    if (lSecretId > 0 && lInfo1 > 0 && lInfo2 > 0 && lInfo3 > 0 && lInfo4 > 0) {
                        adjustConfig.setAppSecret(lSecretId, lInfo1, lInfo2, lInfo3, lInfo4);
                    }
                } catch (NumberFormatException ignored) {}
            }

            // Is device known.
            if (freObjects[22] != null) {
                boolean isDeviceKnown = freObjects[22].getAsBool();
                adjustConfig.setDeviceKnown(isDeviceKnown);
            }

            // Read IMEI.
            if (freObjects[23] != null) {
                boolean readMobileEquipmentIdentity = freObjects[23].getAsBool();
                adjustConfig.setReadMobileEquipmentIdentity(readMobileEquipmentIdentity);
            }

            // External device ID.
            if (freObjects[24] != null) {
                String externalDeviceId = freObjects[24].getAsString();
                if (externalDeviceId != null) {
                    adjustConfig.setExternalDeviceId(externalDeviceId);
                }
            }

            // URL strategy.
            if (freObjects[27] != null) {
                String urlStrategy = freObjects[27].getAsString();
                if (urlStrategy.equalsIgnoreCase("china")) {
                    adjustConfig.setUrlStrategy(AdjustConfig.URL_STRATEGY_CHINA);
                } else if (urlStrategy.equalsIgnoreCase("india")) {
                    adjustConfig.setUrlStrategy(AdjustConfig.URL_STRATEGY_INDIA);
                }
            }

            // Cost data in attribution callback.
            if (freObjects[28] != null) {
                boolean needsCost = freObjects[28].getAsBool();
                if (needsCost == true) {
                   adjustConfig.setNeedsCost(true);
                }
            }

            // Preinstall tracking.
            if (freObjects[30] != null) {
                boolean preinstallTrackingEnabled = freObjects[30].getAsBool();
                if (preinstallTrackingEnabled == true) {
                    adjustConfig.setPreinstallTrackingEnabled(true);
                }
            }

            Adjust.onCreate(adjustConfig);
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        return null;
    }

    private FREObject TrackEvent(FREContext freContext, FREObject[] freObjects) {
        try {
            String eventToken = null;
            String currency = null;
            String orderId = null;
            String callbackId = null;
            double revenue = 0;

            // Event token.
            if (freObjects[0] != null) {
                eventToken = freObjects[0].getAsString();
            }

            AdjustEvent adjustEvent = new AdjustEvent(eventToken);

            // Revenue and currency.
            if (freObjects[1] != null) {
                currency = freObjects[1].getAsString();
                if (freObjects[2] != null) {
                    revenue = freObjects[2].getAsDouble();
                }
                adjustEvent.setRevenue(revenue, currency);
            }

            // Callback parameters.
            if (freObjects[3] != null) {
                for (int i = 0; i < ((FREArray) freObjects[3]).getLength(); i += 2) {
                    adjustEvent.addCallbackParameter(((FREArray) freObjects[3]).getObjectAt(i).getAsString(),
                            ((FREArray) freObjects[3]).getObjectAt(i + 1).getAsString());
                }
            }

            // Partner parameters.
            if (freObjects[4] != null) {
                for (int i = 0; i < ((FREArray) freObjects[4]).getLength(); i += 2) {
                    adjustEvent.addPartnerParameter(((FREArray) freObjects[4]).getObjectAt(i).getAsString(),
                            ((FREArray) freObjects[4]).getObjectAt(i + 1).getAsString());
                }
            }

            // Callback ID.
            if (freObjects[5] != null) {
                callbackId = freObjects[5].getAsString();
                adjustEvent.setCallbackId(callbackId);
            }

            // Transaction ID.
            if (freObjects[6] != null) {
                orderId = freObjects[6].getAsString();
                adjustEvent.setOrderId(orderId);
            }

            Adjust.trackEvent(adjustEvent);
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

       return null;
    }

    private FREObject SetEnabled(FREContext freContext, FREObject[] freObjects) {
        try {
            Boolean enabled = freObjects[0].getAsBool();
            Adjust.setEnabled(enabled);
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        return null;
    }

    private FREObject IsEnabled(FREContext freContext, FREObject[] freObjects) {
        try {
            return FREObject.newObject(Adjust.isEnabled());
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        return null;
    }

    private FREObject OnResume(FREContext freContext, FREObject[] freObjects) {
        try {
            Adjust.onResume();
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        return null;
    }

    private FREObject OnPause(FREContext freContext, FREObject[] freObjects) {
        try {
            Adjust.onPause();
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        return null;
    }

    private FREObject AppWillOpenUrl(FREContext freContext, FREObject[] freObjects) {
        try {
            String url = freObjects[0].getAsString();
            Uri uri = Uri.parse(url);
            Adjust.appWillOpenUrl(uri, freContext.getActivity());
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        return null;
    }

    private FREObject SendFirstPackages(FREContext freContext, FREObject[] freObjects) {
        try {
            Adjust.sendFirstPackages();
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        return null;
    }

    private FREObject TrackAdRevenue(FREContext freContext, FREObject[] freObjects) {
        try {
            String source = freObjects[0].getAsString();
            String payload = freObjects[1].getAsString();
            JSONObject jsonPayload = new JSONObject(payload);
            Adjust.trackAdRevenue(source, jsonPayload);
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        return null;
    }

    private FREObject SetOfflineMode(FREContext freContext, FREObject[] freObjects) {
        try {
            Boolean isOffline = freObjects[0].getAsBool();
            Adjust.setOfflineMode(isOffline);
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        return null;
    }

    private FREObject SetReferrer(FREContext freContext, FREObject[] freObjects) {
        try {
            String referrer = freObjects[0].getAsString();
            Adjust.setReferrer(referrer, freContext.getActivity());
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        return null;
    }

    private FREObject SetDeviceToken(FREContext freContext, FREObject[] freObjects) {
        try {
            String token = freObjects[0].getAsString();
            Adjust.setPushToken(token, freContext.getActivity());
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        return null;
    }

    private FREObject GetGoogleAdId(final FREContext freContext, FREObject[] freObjects) {
        Adjust.getGoogleAdId(freContext.getActivity(), new OnDeviceIdsRead() {
            @Override
            public void onGoogleAdIdRead(String playAdId) {
                if (playAdId != null) {
                    freContext.dispatchStatusEventAsync("adjust_googleAdId", playAdId);
                } else {
                    freContext.dispatchStatusEventAsync("adjust_googleAdId", "");
                }
            }
        });

        return null;
    }

    private FREObject GetAmazonAdId(final FREContext freContext, FREObject[] freObjects) {
        String amazonAdId = Adjust.getAmazonAdId(freContext.getActivity().getApplicationContext());

        if (amazonAdId != null) {
            freContext.dispatchStatusEventAsync("adjust_amazonAdId", amazonAdId);
        } else {
            freContext.dispatchStatusEventAsync("adjust_amazonAdId", "");
        }

        return null;
    }

    private FREObject GetAdid(final FREContext freContext, FREObject[] freObjects) {
        try {
            String adid = Adjust.getAdid();
            return FREObject.newObject(adid);
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        return null;
    }

    private FREObject GetAttribution(final FREContext freContext, FREObject[] freObjects) {
        try {
            AdjustAttribution attribution = Adjust.getAttribution();
            if (attribution == null) {
                return null;
            }

            String response = "trackerToken==" + attribution.trackerToken + "__"
                    + "trackerName==" + attribution.trackerName + "__"
                    + "campaign==" + attribution.campaign + "__"
                    + "network==" + attribution.network + "__"
                    + "creative==" + attribution.creative + "__"
                    + "adgroup==" + attribution.adgroup + "__"
                    + "clickLabel==" + attribution.clickLabel + "__"
                    + "adid==" + attribution.adid + "__"
                    + "costType==" + attribution.costType + "__"
                    + "costAmount==" + (attribution.costAmount.isNaN() ? "" : attribution.costAmount.toString()) + "__"
                    + "costCurrency==" + attribution.costCurrency;
            return FREObject.newObject(response);
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        return null;
    }

    private FREObject GetSdkVersion(final FREContext freContext, FREObject[] freObjects) {
        try {
            String sdkVersion = Adjust.getSdkVersion();
            return FREObject.newObject(sdkVersion);
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        return null;
    }

    private FREObject AddSessionCallbackParameter(FREContext freContext, FREObject[] freObjects) {
        try {
            String key = freObjects[0].getAsString();
            String value = freObjects[1].getAsString();
            Adjust.addSessionCallbackParameter(key, value);
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        return null;
    }

    private FREObject RemoveSessionCallbackParameter(FREContext freContext, FREObject[] freObjects) {
        try {
            String key = freObjects[0].getAsString();
            Adjust.removeSessionCallbackParameter(key);
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        return null;
    }

    private FREObject ResetSessionCallbackParameters(FREContext freContext, FREObject[] freObjects) {
        try {
            Adjust.resetSessionCallbackParameters();
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        return null;
    }

    private FREObject AddSessionPartnerParameter(FREContext freContext, FREObject[] freObjects) {
        try {
            String key = freObjects[0].getAsString();
            String value = freObjects[1].getAsString();
            Adjust.addSessionPartnerParameter(key, value);
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        return null;
    }

    private FREObject RemoveSessionPartnerParameter(FREContext freContext, FREObject[] freObjects) {
        try {
            String key = freObjects[0].getAsString();
            Adjust.removeSessionPartnerParameter(key);
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        return null;
    }

    private FREObject ResetSessionPartnerParameters(FREContext freContext, FREObject[] freObjects) {
        try {
            Adjust.resetSessionPartnerParameters();
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        return null;
    }

    private FREObject GdprForgetMe(FREContext freContext, FREObject[] freObjects) {
        try {
            Adjust.gdprForgetMe(freContext.getActivity());
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        return null;
    }

    private FREObject DisableThirdPartySharing(FREContext freContext, FREObject[] freObjects) {
        try {
            Adjust.disableThirdPartySharing(freContext.getActivity());
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        return null;
    }

    private FREObject GetIdfa(FREContext freContext, FREObject[] freObjects) { return null; }

    private FREObject RequestTrackingAuthorizationWithCompletionHandler(FREContext freContext, FREObject[] freObjects) { return null; }

    private FREObject SetTestOptions(FREContext freContext, FREObject[] freObjects) {
        try {
            final AdjustTestOptions testOptions = new AdjustTestOptions();

            if (freObjects[0] != null) {
                boolean value = freObjects[0].getAsBool();
                if (value) {
                    testOptions.context = freContext.getActivity();
                }
            }
            if (freObjects[1] != null) {
                String value = freObjects[1].getAsString();
                testOptions.baseUrl = value;
            }
            if (freObjects[2] != null) {
                String value = freObjects[2].getAsString();
                testOptions.basePath = value;
            }
            if (freObjects[3] != null) {
                String value = freObjects[3].getAsString();
                testOptions.gdprUrl = value;
            }
            if (freObjects[4] != null) {
                String value = freObjects[4].getAsString();
                testOptions.gdprPath = value;
            }
            // if (freObjects[5] != null) {
            //     boolean value = freObjects[5].getAsBool();
            //     testOptions.useTestConnectionOptions = value;
            // }
            if (freObjects[6] != null) {
                String str = freObjects[6].getAsString();
                long value = Long.parseLong(str);
                testOptions.timerIntervalInMilliseconds = value;
            }
            if (freObjects[7] != null) {
                String str = freObjects[7].getAsString();
                long value = Long.parseLong(str);
                testOptions.timerStartInMilliseconds = value;
            }
            if (freObjects[8] != null) {
                String str = freObjects[8].getAsString();
                long value = Long.parseLong(str);
                testOptions.sessionIntervalInMilliseconds = value;
            }
            if (freObjects[9] != null) {
                String str = freObjects[9].getAsString();
                long value = Long.parseLong(str);
                testOptions.subsessionIntervalInMilliseconds = value;
            }
            if (freObjects[10] != null) {
                boolean value = freObjects[10].getAsBool();
                testOptions.teardown = value;
            }
            if (freObjects[11] != null) {
                boolean value = freObjects[11].getAsBool();
                testOptions.tryInstallReferrer = value;
            }
            if (freObjects[12] != null) {
                boolean value = freObjects[12].getAsBool();
                testOptions.noBackoffWait = value;
            }
            Adjust.setTestOptions(testOptions);
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

       return null;
    }

    private FREObject Teardown(FREContext freContext, FREObject[] freObjects) {
        return null;
    }

    @Override
    public void onAttributionChanged(AdjustAttribution attribution) {
        if (attribution == null) {
            return;
        }

        String response = "trackerToken==" + attribution.trackerToken + "__"
                + "trackerName==" + attribution.trackerName + "__"
                + "campaign==" + attribution.campaign + "__"
                + "network==" + attribution.network + "__"
                + "creative==" + attribution.creative + "__"
                + "adgroup==" + attribution.adgroup + "__"
                + "clickLabel==" + attribution.clickLabel + "__"
                + "adid==" + attribution.adid + "__"
                + "costType==" + attribution.costType + "__"
                + "costAmount==" + (attribution.costAmount.isNaN() ? "" : attribution.costAmount.toString()) + "__"
                + "costCurrency==" + attribution.costCurrency;
        AdjustExtension.context.dispatchStatusEventAsync("adjust_attributionData", response);
    }

    @Override
    public void onFinishedEventTrackingSucceeded(AdjustEventSuccess event) {
        if (event == null) {
            return;
        }

        StringBuilder response = new StringBuilder();
        response.append("message==" + event.message + "__"
                + "timeStamp==" + event.timestamp + "__"
                + "adid==" + event.adid + "__"
                + "eventToken==" + event.eventToken + "__"
                + "callbackId==" + event.callbackId + "__");
        if (event.jsonResponse != null) {
            response.append("jsonResponse==" + event.jsonResponse.toString());
        }
        AdjustExtension.context.dispatchStatusEventAsync("adjust_eventTrackingSucceeded", response.toString());
    }

    @Override
    public void onFinishedEventTrackingFailed(AdjustEventFailure event) {
        if (event == null) {
            return;
        }

        StringBuilder response = new StringBuilder();
        response.append("message==" + event.message + "__"
                + "timeStamp==" + event.timestamp + "__"
                + "adid==" + event.adid + "__"
                + "eventToken==" + event.eventToken + "__"
                + "callbackId==" + event.callbackId + "__"
                + "willRetry==" + event.willRetry + "__");
        if (event.jsonResponse != null) {
            response.append("jsonResponse==" + event.jsonResponse.toString());
        }
        AdjustExtension.context.dispatchStatusEventAsync("adjust_eventTrackingFailed", response.toString());
    }

    @Override
    public void onFinishedSessionTrackingSucceeded(AdjustSessionSuccess event) {
        if (event == null) {
            return;
        }

        StringBuilder response = new StringBuilder();
        response.append("message==" + event.message + "__"
                + "timeStamp==" + event.timestamp + "__"
                + "adid==" + event.adid + "__");
        if (event.jsonResponse != null) {
            response.append("jsonResponse==" + event.jsonResponse.toString());
        }
        AdjustExtension.context.dispatchStatusEventAsync("adjust_sessionTrackingSucceeded", response.toString());
    }

    @Override
    public void onFinishedSessionTrackingFailed(AdjustSessionFailure event) {
        if (event == null) {
            return;
        }

        StringBuilder response = new StringBuilder();
        response.append("message==" + event.message + "__"
                + "timeStamp==" + event.timestamp + "__"
                + "adid==" + event.adid + "__"
                + "willRetry==" + event.willRetry + "__");
        if (event.jsonResponse != null) {
            response.append("jsonResponse==" + event.jsonResponse.toString());
        }
        AdjustExtension.context.dispatchStatusEventAsync("adjust_sessionTrackingFailed", response.toString());
    }

    @Override
    public boolean launchReceivedDeeplink(Uri deeplink) {
        String response = deeplink.toString();
        AdjustExtension.context.dispatchStatusEventAsync("adjust_deferredDeeplink", response);
        return shouldLaunchDeeplink;
    }
}
