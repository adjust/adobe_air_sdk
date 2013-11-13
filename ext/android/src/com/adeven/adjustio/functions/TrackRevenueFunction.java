/**
 * TrackRevenueFunction.java
 * TrackRevenueFunction
 *
 * Created by Andrew Slotin on 2013-11-12.
 * Copyright (c) 2012-2013 adeven. All rights reserved.
 * See the file MIT-LICENSE for copying permission.
 */

package com.adeven.adjustio.functions;

import com.adeven.adjustio.AdjustIo;
import com.adeven.adjustio.Logger;
import com.adobe.fre.*;

import java.util.Map;

public class TrackRevenueFunction extends NoopFunction implements FREFunction {
    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        double amountInCents;
        String eventToken = null;
        Map<String, String> parameters = null;

        if (args.length == 0) {
            Logger.error("Missing revenue amount.");
            return null;
        }

        try {
            amountInCents = getAmountInCentsFromArg(args[0]);

            if (args.length > 1) {
                eventToken = getEventTokenFromArg(args[1]);
            }

            if (args.length > 2) {
                parameters = getParametersFromArg(args[2]);
            }

            AdjustIo.trackRevenue(amountInCents, eventToken, parameters);
        } catch (FREInvalidObjectException e) {
            Logger.error(e.getMessage());
        } catch (FREWrongThreadException e) {
            Logger.error(e.getMessage());
        }

        return null;
    }
}
