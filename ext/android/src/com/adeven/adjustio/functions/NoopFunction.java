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

import java.util.Map;

public class NoopFunction implements FREFunction {
    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        return null;
    }

    protected double getAmountInCentsFromArg(FREObject arg) {
        try {
            return arg.getAsDouble();
        } catch (FRETypeMismatchException e) {
            Logger.error("Revenue amount in cents type mismatch.");
        } catch (FREInvalidObjectException e) {
            Logger.error(e.getMessage());
        } catch (FREWrongThreadException e) {
            Logger.error(e.getMessage());
        }

        return 0.0;
    }

    protected String getEventTokenFromArg(FREObject arg) {
        try {
            return arg.getAsString();
        } catch (FRETypeMismatchException e) {
            Logger.error("Event token type mismatch.");
        } catch (FREInvalidObjectException e) {
            Logger.error(e.getMessage());
        } catch (FREWrongThreadException e) {
            Logger.error(e.getMessage());
        }

        return null;
    }

    protected Map<String, String> getParametersFromArg(FREObject arg) {
        return null;
    }
}
