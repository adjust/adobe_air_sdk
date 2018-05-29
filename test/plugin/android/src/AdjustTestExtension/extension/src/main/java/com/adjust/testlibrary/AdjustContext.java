package com.adjust.testlibrary;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by pfms on 31/07/14.
 */
public class AdjustContext extends FREContext {
    public static String StartTestSession = "startTestSession";
    public static String AddInfoToSend    = "addInfoToSend";
    public static String SendInfoToServer = "sendInfoToServer";
    public static String AddTest          = "addTest";
    public static String AddTestDirectory = "addTestDirectory";

    @Override
    public Map<String, FREFunction> getFunctions() {
        Map<String, FREFunction> functions = new HashMap<String, FREFunction>();

        functions.put(AdjustContext.StartTestSession, new AdjustFunction(AdjustContext.StartTestSession));
        functions.put(AdjustContext.AddInfoToSend, new AdjustFunction(AdjustContext.AddInfoToSend));
        functions.put(AdjustContext.SendInfoToServer, new AdjustFunction(AdjustContext.SendInfoToServer));
        functions.put(AdjustContext.AddTest, new AdjustFunction(AdjustContext.AddTest));
        functions.put(AdjustContext.AddTestDirectory, new AdjustFunction(AdjustContext.AddTestDirectory));

        return functions;
    }

    @Override
    public void dispose() {}
}
