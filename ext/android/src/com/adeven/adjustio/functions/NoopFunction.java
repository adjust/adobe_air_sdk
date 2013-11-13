/**
 * NoopFunction.java
 * NoopFunction
 *
 * Created by Andrew Slotin on 2013-11-12.
 * Copyright (c) 2012-2013 adeven. All rights reserved.
 * See the file MIT-LICENSE for copying permission.
 */

package com.adeven.adjustio.functions;

import com.adeven.adjustio.Logger;
import com.adobe.fre.*;

import java.util.HashMap;
import java.util.Map;

public class NoopFunction implements FREFunction {
    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        return null;
    }

    protected double getAmountInCentsFromArg(FREObject arg) throws FREInvalidObjectException, FREWrongThreadException {
        try {
            return arg.getAsDouble();
        } catch (FRETypeMismatchException e) {
            Logger.error("Revenue amount in cents type mismatch.");
        }

        return 0.0;
    }

    protected String getEventTokenFromArg(FREObject arg) throws FREInvalidObjectException, FREWrongThreadException {
        try {
            return arg.getAsString();
        } catch (FRETypeMismatchException e) {
            Logger.error("Event token type mismatch.");
        }

        return null;
    }

    protected Map<String, String> getParametersFromArg(FREObject arg) throws FREInvalidObjectException, FREWrongThreadException {
        Map<String, String> params = new HashMap<String, String>();
        FREObject[] noArgs = new FREObject[0];
        FREArray keys;

        try {
            keys = (FREArray)arg.callMethod("keys", noArgs);

            for (long i = 0; i < keys.getLength(); i++) {
                FREObject key   = keys.getObjectAt(i);
                FREObject value = arg.callMethod("getValue", new FREObject[]{ key });

                params.put(key.getAsString(), value.getAsString());
            }
        } catch (FRETypeMismatchException e) {
            Logger.error(e.getMessage());
        } catch (FREASErrorException e) {
            Logger.error(e.getMessage());
        } catch (FRENoSuchNameException e) {
            Logger.error(e.getMessage());
        }

        return params;
    }
}
