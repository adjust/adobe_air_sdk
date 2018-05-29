package com.adjust.testlibrary;

import android.util.Log;
import java.util.ArrayList;
import java.util.List;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREInvalidObjectException; 
import com.adobe.fre.FRETypeMismatchException; 
import com.adobe.fre.FREWrongThreadException; 

/**
 * Created by pfms on 31/07/14.
 */
public class AdjustFunction implements FREFunction {
    private static final String TAG = "AdjustFunction";
    private String functionName;
    private static TestLibrary testLibrary;
    private static List<String> selectedTests = new ArrayList<String>();
    private static List<String> selectedTestDirs = new ArrayList<String>();

    public AdjustFunction(String functionName) {
        this.functionName = functionName;
    }

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        AdjustExtension.context = (AdjustContext) freContext;

        if (functionName == AdjustContext.StartTestSession) {
            return StartTestSession(freContext, freObjects);
        }

        if (functionName == AdjustContext.AddInfoToSend) {
            return AddInfoToSend(freContext, freObjects);
        }

        if (functionName == AdjustContext.SendInfoToServer) {
            return SendInfoToServer(freContext, freObjects);
        }

        if (functionName == AdjustContext.AddTest) {
            return AddTest(freContext, freObjects);
        }

        if (functionName == AdjustContext.AddTestDirectory) {
            return AddTestDirectory(freContext, freObjects);
        }

        return null;
    }

    private FREObject StartTestSession(FREContext freContext, FREObject[] freObjects) {
        try {
            String baseUrl = freObjects[0].getAsString();
            Log.d(TAG, "startTestSession() with baseUrl[" + baseUrl + "]");

            testLibrary = new TestLibrary(baseUrl, new CommandListener());

            for(int i = 0; i < selectedTests.size(); i++) {
                testLibrary.addTest(selectedTests.get(i));
            }

            for(int i = 0; i < selectedTestDirs.size(); i++) {
                testLibrary.addTestDirectory(selectedTestDirs.get(i));
            }

            testLibrary.startTestSession("adobe_air4.13.0@android4.13.0");
        } catch (FRETypeMismatchException e) {
            Log.e(TAG, e.getMessage()); 
            e.printStackTrace();
        } catch (IllegalStateException e) { 
            Log.e(TAG, e.getMessage()); 
            e.printStackTrace(); 
        } catch (FREInvalidObjectException e) { 
            Log.e(TAG, e.getMessage()); 
            e.printStackTrace(); 
        } catch (FREWrongThreadException e) { 
            Log.e(TAG, e.getMessage()); 
            e.printStackTrace(); 
        } 

        return null;
    }

    private FREObject AddInfoToSend(FREContext freContext, FREObject[] freObjects) {
        try {
            String key = freObjects[0].getAsString();
            String value = freObjects[1].getAsString();
            Log.d(TAG, "AddInfoToSend() with key[" + key + "] and value[" + value + "]");

            if (null != testLibrary) {
                testLibrary.addInfoToSend(key, value);
            }
        } catch (FRETypeMismatchException e) {
            Log.e(TAG, e.getMessage()); 
            e.printStackTrace();
        } catch (IllegalStateException e) { 
            Log.e(TAG, e.getMessage()); 
            e.printStackTrace(); 
        } catch (FREInvalidObjectException e) { 
            Log.e(TAG, e.getMessage()); 
            e.printStackTrace(); 
        } catch (FREWrongThreadException e) { 
            Log.e(TAG, e.getMessage()); 
            e.printStackTrace(); 
        } 

        return null;
    }

    private FREObject SendInfoToServer(FREContext freContext, FREObject[] freObjects) {
        try {
            String basePath = freObjects[0].getAsString();
            Log.d(TAG, "sendInfoToServer(): " + basePath);

            if (null != testLibrary) {
                testLibrary.sendInfoToServer(basePath);
            }
        } catch (FRETypeMismatchException e) {
            Log.e(TAG, e.getMessage()); 
            e.printStackTrace();
        } catch (IllegalStateException e) { 
            Log.e(TAG, e.getMessage()); 
            e.printStackTrace(); 
        } catch (FREInvalidObjectException e) { 
            Log.e(TAG, e.getMessage()); 
            e.printStackTrace(); 
        } catch (FREWrongThreadException e) { 
            Log.e(TAG, e.getMessage()); 
            e.printStackTrace(); 
        } 

        return null;
    }

    private FREObject AddTest(FREContext freContext, FREObject[] freObjects) {
        try {
            this.selectedTests.add(freObjects[0].getAsString());
        } catch (FRETypeMismatchException e) {
            Log.e(TAG, e.getMessage()); 
            e.printStackTrace();
        } catch (IllegalStateException e) { 
            Log.e(TAG, e.getMessage()); 
            e.printStackTrace(); 
        } catch (FREInvalidObjectException e) { 
            Log.e(TAG, e.getMessage()); 
            e.printStackTrace(); 
        } catch (FREWrongThreadException e) { 
            Log.e(TAG, e.getMessage()); 
            e.printStackTrace(); 
        } 

        return null;
    }

    private FREObject AddTestDirectory(FREContext freContext, FREObject[] freObjects) {
        try {
            this.selectedTestDirs.add(freObjects[0].getAsString());
        } catch (FRETypeMismatchException e) {
            Log.e(TAG, e.getMessage()); 
            e.printStackTrace();
        } catch (IllegalStateException e) { 
            Log.e(TAG, e.getMessage()); 
            e.printStackTrace(); 
        } catch (FREInvalidObjectException e) { 
            Log.e(TAG, e.getMessage()); 
            e.printStackTrace(); 
        } catch (FREWrongThreadException e) { 
            Log.e(TAG, e.getMessage()); 
            e.printStackTrace(); 
        } 

        return null;
    }
}
