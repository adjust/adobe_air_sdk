package com.adjust.sdk;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by pfms on 31/07/14.
 */
public class AdjustContext extends FREContext {
    public static String AppDidLaunch = "appDidLaunch";
    public static String TrackEvent = "trackEvent";
    public static String TrackRevenue = "trackRevenue";
    public static String SetEnable = "setEnable";
    public static String IsEnabled = "isEnabled";
    public static String OnResume = "onResume";
    public static String OnPause = "onPause";
    public static String SetResponseDelegate = "setResponseDelegate";

    @Override
    public Map<String, FREFunction> getFunctions() {
        Map<String, FREFunction> functions = new HashMap<String, FREFunction>();

        functions.put(AdjustContext.AppDidLaunch, new AdjustFunction(AdjustContext.AppDidLaunch));
        functions.put(AdjustContext.TrackEvent, new AdjustFunction(AdjustContext.TrackEvent));
        functions.put(AdjustContext.TrackRevenue, new AdjustFunction(AdjustContext.TrackRevenue));
        functions.put(AdjustContext.SetEnable, new AdjustFunction(AdjustContext.SetEnable));
        functions.put(AdjustContext.IsEnabled, new AdjustFunction(AdjustContext.IsEnabled));
        functions.put(AdjustContext.OnResume, new AdjustFunction(AdjustContext.OnResume));
        functions.put(AdjustContext.OnPause, new AdjustFunction(AdjustContext.OnPause));
        functions.put(AdjustContext.SetResponseDelegate, new AdjustFunction(AdjustContext.SetResponseDelegate));

        return functions;
    }

    @Override
    public void dispose() {

    }
}