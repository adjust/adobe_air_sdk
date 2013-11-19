/**
 * AppDidLaunchFunction.java
 * AppDidLaunchFunction
 *
 * Created by Andrew Slotin on 2013-11-15.
 * Copyright (c) 2012-2013 adeven. All rights reserved.
 * See the file MIT-LICENSE for copying permission.
 */

package com.adeven.adjustio.functions;

import com.adeven.adjustio.AdjustFREUtils;
import com.adeven.adjustio.AdjustIo;
import com.adeven.adjustio.Logger;
import com.adobe.fre.*;

public class AppDidLaunchFunction extends NoopFunction {
    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        AdjustIo.onResume(context.getActivity());

        if (args.length > 2) {
            Logger.setLogLevel(getLogLevelFromArg(args[2]));
        }

        return AdjustFREUtils.getFRETrue();
    }

    private Logger.LogLevel getLogLevelFromArg(FREObject arg) {
        try {
            Logger.LogLevel[] availableLevels = Logger.LogLevel.values();
            int logLevel = arg.getAsInt();

            if (logLevel < 0 || logLevel >= availableLevels.length) {
                Logger.warn(String.format("Invalid log level provided (%d), falling back to INFO.", logLevel));
            } else {
                return availableLevels[logLevel];
            }
        } catch (FRETypeMismatchException e) {
            Logger.warn(e.getMessage());
        } catch (FREInvalidObjectException e) {
            Logger.warn(e.getMessage());
        } catch (FREWrongThreadException e) {
            Logger.warn(e.getMessage());
        }

        return Logger.LogLevel.INFO;
    }
}
