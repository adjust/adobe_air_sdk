/**
 * AdjustIoExtensionContext.as
 * AdjustIoExtensionContext
 * <p/>
 * Created by Andrew Slotin on 2013-11-12.
 * Copyright (c) 2012-2014 adjust GmbH.  All rights reserved.
 * See the file MIT-LICENSE for copying permission.
 */

package com.adeven.adjustio;

import com.adeven.adjustio.functions.*;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

import java.util.HashMap;
import java.util.Map;

public class AdjustIoExtensionContext extends FREContext {
    @Override
    public void dispose() {}

    @Override
    public Map<String, FREFunction> getFunctions() {
        Map<String, FREFunction> functions = new HashMap<String, FREFunction>();

        functions.put("onPause", new OnPauseFunction());
        functions.put("onResume", new OnResumeFunction());
        functions.put("trackEvent", new TrackEventFunction());
        functions.put("trackRevenue", new TrackRevenueFunction());
        functions.put("appDidLaunch", new AppDidLaunchFunction());

        return functions;
    }
}
