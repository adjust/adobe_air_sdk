/**
 * TrackEventFunction.java
 * TrackEventFunction
 *
 * Created by Andrew Slotin on 2013-11-12.
 * Copyright (c) 2012-2013 adeven. All rights reserved.
 * See the file MIT-LICENSE for copying permission.
 */

package com.adeven.adjustio.functions;

import com.adeven.adjustio.*;
import com.adobe.fre.*;

import java.util.Map;

public class TrackEventFunction extends NoopFunction implements FREFunction {
    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        String eventToken;
        Map<String, String> parameters = null;

        if (args.length == 0) {
            Logger.error("Missing event token.");
            return null;
        }

        try {
            eventToken = getEventTokenFromArg(args[0]);

            if (args.length > 1) {
                parameters = getParametersFromArg(args[1]);
            }

            AdjustIo.trackEvent(eventToken, parameters);
        } catch (FREInvalidObjectException e) {
            Logger.error(e.getMessage());
        } catch (FREWrongThreadException e) {
            Logger.error(e.getMessage());
        }

        return null;
    }
}
