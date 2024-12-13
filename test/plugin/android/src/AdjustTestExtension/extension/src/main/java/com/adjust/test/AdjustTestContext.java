package com.adjust.test;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

import java.util.HashMap;
import java.util.Map;

public class AdjustTestContext extends FREContext {
    public static String StartTestSession = "startTestSession";
    public static String AddInfoToSend = "addInfoToSend";
    public static String SendInfoToServer = "sendInfoToServer";
    public static String AddTest = "addTest";
    public static String AddTestDirectory = "addTestDirectory";
    public static String SetTestConnectionOptions = "setTestConnectionOptions";

    @Override
    public Map<String, FREFunction> getFunctions() {
        Map<String, FREFunction> functions = new HashMap<String, FREFunction>();
        functions.put(AdjustTestContext.StartTestSession, new AdjustTestFunction(AdjustTestContext.StartTestSession));
        functions.put(AdjustTestContext.AddInfoToSend, new AdjustTestFunction(AdjustTestContext.AddInfoToSend));
        functions.put(AdjustTestContext.SendInfoToServer, new AdjustTestFunction(AdjustTestContext.SendInfoToServer));
        functions.put(AdjustTestContext.AddTest, new AdjustTestFunction(AdjustTestContext.AddTest));
        functions.put(AdjustTestContext.AddTestDirectory, new AdjustTestFunction(AdjustTestContext.AddTestDirectory));
        functions.put(AdjustTestContext.SetTestConnectionOptions, new AdjustTestFunction(AdjustTestContext.SetTestConnectionOptions));
        return functions;
    }

    @Override
    public void dispose() {}
}
