package com.adjust.test;

import java.util.concurrent.atomic.AtomicInteger;

import android.util.Log;
import org.json.JSONObject;
import org.json.JSONException;

public class CommandListener implements ICommandRawJsonListener {
    private static String TAG = "CommandListener";
    private AtomicInteger orderCounter = null;

    public CommandListener() {
        orderCounter = new AtomicInteger(0);
    }

    @Override
    public void executeCommand(String jsonStr) {
        try {
            JSONObject jsonObj = new JSONObject(jsonStr);

            // Order of packages sent through PluginResult is not reliable, this is solved
            // through a scheduling mechanism in command_executor.js#scheduleCommand() side.
            // The 'order' entry is used to schedule commands
            jsonObj.put("order", orderCounter.getAndIncrement());

            AdjustTestExtension.context.dispatchStatusEventAsync("adjust_test_command", jsonObj.toString());
        } catch(JSONException ex) {
            ex.printStackTrace();
        }
    }
}
