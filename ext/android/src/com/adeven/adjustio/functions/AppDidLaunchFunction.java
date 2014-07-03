/**
 * AppDidLaunchFunction.java
 * AppDidLaunchFunction
 *
 * Created by Andrew Slotin on 2013-11-15.
 * Copyright (c) 2012-2014 adjust GmbH.  All rights reserved.
 * See the file MIT-LICENSE for copying permission.
 */

package com.adeven.adjustio.functions;

import com.adeven.adjustio.AdjustFREUtils;
import com.adeven.adjustio.AdjustIo;
import com.adeven.adjustio.AdjustIoSDKInitializer;
import com.adeven.adjustio.Logger;
import com.adobe.fre.*;

public class AppDidLaunchFunction extends SDKFunction {
    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        String appToken;
        String environment = null;
        Boolean eventBufferingEnabled = false;

        if (args.length == 0) {
            Logger.error("The app token is missing");

            return AdjustFREUtils.getFREFalse();
        }

        try {
            appToken = getAppTokenFromArg(args[0]);

            if (args.length > 1) {
                environment = getEnvironmentFromArg(args[1]);
            }
            if (args.length > 2) {
                Logger.setLogLevel(getLogLevelFromArg(args[2]));
            }
            if (args.length > 3) {
                eventBufferingEnabled = getEventBufferingEnabledFromArg(args[3]);
            }
        } catch (FREInvalidObjectException e) {
            Logger.error(e.getMessage());
            return AdjustFREUtils.getFREFalse();
        } catch (FREWrongThreadException e) {
            Logger.error(e.getMessage());
            return AdjustFREUtils.getFREFalse();
        }

        AdjustIoSDKInitializer.initialize(context.getActivity(), appToken, environment, eventBufferingEnabled);

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

    private String getAppTokenFromArg(FREObject arg) throws FREInvalidObjectException, FREWrongThreadException {
        try {
            return arg.getAsString();
        } catch (FRETypeMismatchException e) {
            Logger.error("App token type mismatch.");
        }

        return null;
    }

    private String getEnvironmentFromArg(FREObject arg) throws FREInvalidObjectException, FREWrongThreadException {
        try {
            return arg.getAsString();
        } catch (FRETypeMismatchException e) {
            Logger.error("Environment type mismatch.");
        }

        return null;
    }

    private Boolean getEventBufferingEnabledFromArg(FREObject arg) throws FREInvalidObjectException, FREWrongThreadException {
        try {
            return arg.getAsBool();
        } catch (FRETypeMismatchException e) {
            Logger.error("EventBufferingEnabled type mismatch.");
        }

        return null;
    }
}
