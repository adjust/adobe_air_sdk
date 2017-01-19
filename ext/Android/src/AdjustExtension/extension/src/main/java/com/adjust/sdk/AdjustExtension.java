package com.adjust.sdk;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;
/**
 * Created by pfms on 31/07/14.
 */
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
