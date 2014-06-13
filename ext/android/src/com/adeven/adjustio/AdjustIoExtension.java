/**
 * AdjustIoExtension.as
 * AdjustIoExtension
 *
 * Created by Andrew Slotin on 2013-11-12.
 * Copyright (c) 2012-2014 adjust GmbH.  All rights reserved.
 * See the file MIT-LICENSE for copying permission.
 */

package com.adeven.adjustio;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class AdjustIoExtension implements FREExtension {
    private static FREContext context;

    @Override
    public FREContext createContext(String contextType) {
        context = new AdjustIoExtensionContext();

        return context;
    }

    @Override
    public void dispose() {
        context = null;
    }

    @Override
    public void initialize() {}
}
