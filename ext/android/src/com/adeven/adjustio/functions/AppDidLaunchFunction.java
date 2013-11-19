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
import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;

public class AppDidLaunchFunction extends NoopFunction {
    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        AdjustIo.onResume(context.getActivity());

        return AdjustFREUtils.getFRETrue();
    }
}
