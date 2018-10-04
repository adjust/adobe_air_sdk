package com.adjust.sdk;

import android.net.Uri;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

public class AdjustActivity extends Activity {
    public static String extraPrefix = "com.adjust.sdk.AdjustActivity";

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Intent intent = getIntent();
        String action = intent.getAction();
        Uri data = intent.getData();
    }

    @Override
    public void onStart() {
        super.onStart();
    }

    @Override
    public void onNewIntent(Intent intent) {
        this.setIntent(intent);
    }
}
