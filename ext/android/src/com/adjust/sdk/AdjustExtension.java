package com.adjust.sdk;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;
/**
 * Created by pfms on 31/07/14.
 */
public class AdjustExtension implements FREExtension{
    private static FREContext context;
    public static String LogTag = "Adjust.air";
    @Override
    public void initialize() { }

    @Override
    public FREContext createContext(String s) {
        if (context == null) {
            context = new AdjustContext();
        }

        return context;
    }

    @Override
    public void dispose() { }
}