/**
 * OnResumeFunction.as
 * OnResumeFunction
 * <p/>
 * Created by Andrew Slotin on 2013-11-12.
 * Copyright (c) 2012-2013 adeven. All rights reserved.
 * See the file MIT-LICENSE for copying permission.
 */

package com.adeven.adjustio.functions;

import com.adeven.adjustio.AdjustIo;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class OnResumeFunction extends NoopFunction implements FREFunction {
    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        AdjustIo.onResume(null);

        return null;
    }
}
