/**
 * AdjustIoExtension.as
 * AdjustIoExtension
 *
 * Created by Andrew Slotin on 2013-11-12.
 * Copyright (c) 2012-2013 adeven. All rights reserved.
 * See the file MIT-LICENSE for copying permission.
 */

package com.adeven.adjustio;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class AdjustIoExtension implements FREExtension {
    @Override
    public FREContext createContext(String contextType) {
        return new AdjustIoExtensionContext();
    }

    @Override
    public void dispose() {

    }

    @Override
    public void initialize() {

    }
}
