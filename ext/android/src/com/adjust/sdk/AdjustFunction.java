package com.adjust.sdk;

import android.util.Log;
import com.adobe.fre.*;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by pfms on 31/07/14.
 */
public class AdjustFunction implements FREFunction, OnFinishedListener{
    private String functionName;
    private FREContext freContext;

    public AdjustFunction(String functionName) {
        this.functionName = functionName;
    }

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        if (functionName == AdjustContext.AppDidLaunch) {
            return AppDidLaunch(freContext, freObjects);
        }
        if (functionName == AdjustContext.TrackEvent ) {
            return TrackEvent(freContext, freObjects);
        }
        if (functionName == AdjustContext.TrackRevenue ) {
            return TrackRevenue(freContext, freObjects);
        }
        if (functionName == AdjustContext.SetEnable ) {
            return SetEnable(freContext, freObjects);
        }
        if (functionName == AdjustContext.IsEnabled ) {
            return IsEnabled(freContext, freObjects);
        }
        if (functionName == AdjustContext.OnResume ) {
            return OnResume(freContext, freObjects);
        }
        if (functionName == AdjustContext.OnPause) {
            return OnPause(freContext, freObjects);
        }
        if (functionName == AdjustContext.SetResponseDelegate) {
            return SetResponseDelegate(freContext, freObjects);
        }
        return null;
    }

    private FREObject AppDidLaunch(FREContext freContext, FREObject[] freObjects) {
        try {
            String appToken = freObjects[0].getAsString();
            String environment = freObjects[1].getAsString();
            String logLevel = freObjects[2].getAsString();
            Boolean eventBuffering = freObjects[3].getAsBool();
            Adjust.appDidLaunch(freContext.getActivity(), appToken, environment, logLevel, eventBuffering);

            String sdkPrefix = freObjects[4].getAsString();
            Adjust.setSdkPrefix(sdkPrefix);

            Adjust.onResume(freContext.getActivity());

        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }
        return null;
    }

    private FREObject TrackEvent(FREContext freContext, FREObject[] freObjects) {
        try {
            String eventToken = freObjects[0].getAsString();
            Map<String, String> parameters = getAsMap(freObjects[1]);

            Adjust.trackEvent(eventToken, parameters);
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }
        return null;
    }

    private FREObject TrackRevenue(FREContext freContext, FREObject[] freObjects) {
        try {
            Double amountInCents = freObjects[0].getAsDouble();

            String eventToken;
            if (freObjects[1] != null) {
                eventToken = freObjects[1].getAsString();
            } else {
                eventToken = null;
            }
            Map<String, String> parameters = getAsMap(freObjects[2]);

            Adjust.trackRevenue(amountInCents, eventToken, parameters);
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }
        return null;
    }

    private FREObject SetEnable(FREContext freContext, FREObject[] freObjects) {
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
            Adjust.onResume(freContext.getActivity());
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

    private FREObject SetResponseDelegate(FREContext freContext, FREObject[] freObjects) {
        try {
            this.freContext = freContext;
            Adjust.setOnFinishedListener(this);
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }
        return null;
    }

    private Map<String, String> getAsMap(FREObject freObject) throws Exception{
        if (freObject == null) {
            return null;
        }
        FREArray parameters = (FREArray) freObject.getProperty("adjust keys");

        if (parameters == null) {
            Log.e(AdjustExtension.LogTag, "getAsMap property 'adjust keys' is null");
            return null;
        }

        int i = 0;
        int length = (int)parameters.getLength();

        Map<String, String> map = new HashMap<String, String>(length);

        while (i < length) {
            String key = parameters.getObjectAt(i).getAsString();
            String value = freObject.getProperty(key).getAsString();
            map.put(key,value);

            i++;
        }

        return map;
    }

    @Override
    public void onFinishedTracking(ResponseData responseData) {
        Map<String, String> responseDataDic = responseData.toDic();
        JSONObject responseDataJson = new JSONObject(responseDataDic);
        String responseDataString = responseDataJson.toString();

        freContext.dispatchStatusEventAsync("adjust_responseData", responseDataString);
    }
}