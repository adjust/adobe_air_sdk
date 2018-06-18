package com.adjust.testlibrary;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class AdjustTestExtension implements FREExtension {
    public static AdjustTestContext context;
    public static String LogTag = "AdjustTest.air";
  
    @Override
    public void initialize() {}

    @Override
    public FREContext createContext(String s) {
        return context = new AdjustTestContext();
    }

    @Override
    public void dispose() {
        context = null;
    }
}
