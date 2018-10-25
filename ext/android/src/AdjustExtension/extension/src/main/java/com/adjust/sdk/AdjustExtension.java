//
//  AdjustExtension.java
//  Adjust SDK
//
//  Created by Pedro Silva (@nonelse) on 31st July 2014.
//  Copyright (c) 2014-2018 Adjust GmbH. All rights reserved.
//

package com.adjust.sdk;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class AdjustExtension implements FREExtension {
    public static AdjustContext context;
    public static String LogTag = "Adjust.air";
  
    @Override
    public void initialize() {}

    @Override
    public FREContext createContext(String s) {
        return context = new AdjustContext();
    }

    @Override
    public void dispose() {
        context = null;
    }
}
