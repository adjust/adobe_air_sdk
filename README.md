## Summary

This is the AIR SDK of adjust™. You can read more about adjust™ at [adjust.com].

## Basic Installation

### 1. Get the SDK

Download the latest version from our [releases page][releases]. Extract the archive in a folder of your choice.

### 2. Add it to your project

We assume that you are using IntelliJ IDEA as your IDE. If you are using Flash Builder, then follow the instructions [here][flash-builder].

Pick your Module from the Project Settings in IDEA's Project Structure. Choose the Dependencies tab and click the
plus button to add a dependency to your module. Pick the `New Library...` option.

![][idea-new-library]

Locate the `Adjust-x.y.z.ane` you just downloaded and click `OK`.

![][idea-locate]

After this, add adjust SDK extension to app descriptor file:

```xml
<extensions>
    <!-- ... --->
    <extensionID>com.adjust.sdk</extensionID>
    <!-- ... --->
</extensions>
```

### 3. Integrate adjust into your app

To start tracking with adjust, you first need to initialize the SDK. Add the following code to your main Sprite.

```actionscript
import com.adjust.sdk.Adjust;
import com.adjust.sdk.AdjustConfig;
import com.adjust.sdk.Environment;
import com.adjust.sdk.LogLevel;

public class Example extends Sprite {
    public function Example() {
    	var appToken:String = "{YourAppToken}";
    	var environment:String = Environment.SANDBOX;
    	
        var adjustConfig:AdjustConfig = new AdjustConfig(appToken, environment);
        adjustConfig.setLogLevel(LogLevel.VERBOSE);

        Adjust.start(adjustConfig);
    }
}
```

Replace `{YourAppToken}` with your app token. You can find this in your [dashboard].

Depending on whether you build your app for testing or for production, you must set `environment` with one of these
values:

```actionscript
var environment:String = Environment.SANDBOX;
var environment:String = Environment.PRODUCTION;
```

**Important:** This value should be set to `Environment.SANDBOX` if and only if you or someone else is testing your
app. Make sure to set the environment to `Environment.PRODUCTION` just before you publish the app. Set it back to
`Environment.SANDBOX` when you start developing and testing it again.

We use this environment to distinguish between real traffic and test traffic from test devices. It is very important
that you keep this value meaningful at all times! This is especially important if you are tracking revenue.

#### Adjust Logging

You can increase or decrease the amount of logs you see in tests by calling `setLogLevel` on your `AdjustConfig`
instance with one of the following parameters:

```actionscript
adjustConfig.setLogLevel(LogLevel.VERBOSE); // enable all logging
adjustConfig.setLogLevel(LogLevel.DEBUG);   // enable more logging
adjustConfig.setLogLevel(LogLevel.INFO);    // the default
adjustConfig.setLogLevel(LogLevel.WARN);    // disable info logging
adjustConfig.setLogLevel(LogLevel.ERROR);   // disable warnings as well
adjustConfig.setLogLevel(LogLevel.ASSERT);  // disable errors as well
```

### 4. Adjust Android manifest

In order to use your AIR app for Android with our SDK, you must edit the Android manifest file. To edit the Android
manifest of your AIR apps:

1. Open the application descriptor file, which is typically located at `src/{YourProjectName}-app.xml`.
2. Search for the `<android>` tag
3. Edit between the `<manifest>`tag.

You can find the needed [permissions][android-permissions] and how to add [broadcast receiver][brodcast-android] in our Android guide.

![][android-manifest]

### 5. Add Google Play Services

Since 1st August 2014, all apps in the Google Play Store must use the [Google Advertising ID][google_ad_id] 
to uniquely identify devices. To allow the adjust SDK to use the Google Advertising ID, you must integrate the
[Google Play Services][google_play_services].

In case you don't already have Google Play Services added to your app (as part of some other ANE or in some other
way) you can use `Google Play Services ANE`, which is provided by adjust and is built to fit needs of our SDK. You can find our Google Play Services ANE as part of release on our [releases page][releases].

You should just import downloaded ANE to your app and Google Play Services needed by our SDK will be successfully
added.

![][idea-new-library-gps]

After this, add Google Play Services extension to app descriptor file:

```xml
<extensions>
    <!-- ... --->
    <extensionID>com.adjust.gps</extensionID>
    <!-- ... --->
</extensions>
```

After integrating Google Play Services into your app, add the following lines to your app's Android manifest file
as part of the `<manifest>` tag body:

```xml
<meta-data
    android:name="com.google.android.gms.version"
    android:value="@integer/google_play_services_version"/>
```

## Debugging on device

### Android device

Use ```logcat``` tool that comes with Android SDK:

```
<path-to-android-sdk>/platform-tools/adb logcat -s "Adjust"
```

### iOS device

Check the Console at XCode's Device Organizer to access AdjustIo logs:

![][xcode-logs]


## Additional features

You can take advantage of the following features once the adjust SDK is integrated into your project.

### 6. Add tracking of custom events

You can tell adjust about every event you want. Suppose you want to track every tap on a button. Simply
create a new Event Token in your [dashboard]. Let's say that Event Token is `abc123`. You can add the following line in your button’s click handler method to track the click:


```actionscript
var adjustEvent:AdjustEvent = new AdjustEvent("abc123");
Adjust.trackEvent(adjustEvent);
```

### 7. Add tracking of revenue

If your users can generate revenue by tapping on advertisements or making in-app purchases, then you can track those revenues with events. Lets say a tap is worth €0.01. You could track the revenue event like this:

```actionscript
var adjustEvent:AdjustEvent = new AdjustEvent("abc123");
adjustEvent.setRevenue(0.01, "EUR");
Adjust.trackEvent(adjustEvent);
```

#### iOS

##### <a id="deduplication"></a> Revenue deduplication

You can also add an optional transaction ID to avoid tracking duplicate revenues. The last ten transaction 
IDs are remembered, and revenue events with duplicate transaction IDs are skipped. This is especially useful for 
in-app purchase tracking. See an example below.

If you want to track in-app purchases, please make sure to call `trackEvent` only if the transaction is finished
and item is purchased. That way you can avoid tracking revenue that is not actually being generated.

```actionscript
var adjustEvent:AdjustEvent = new AdjustEvent("abc123");

adjustEvent.setRevenue(0.01, "EUR");
adjustEvent.setTransactionId("transactionId");

Adjust.trackEvent(adjustEvent);
```

##### Receipt verification

If you track in-app purchases, you can also attach the receipt to the tracked event. Our servers 
will verify that receipt with Apple and discard the event if verification fails. To make this work, you will
also need to send us the transaction ID of the purchase. The transaction ID will additionally be used for SDK side 
deduplication as explained [above](#deduplication):

```actionscript
var adjustEvent:AdjustEvent = new AdjustEvent("abc123");

adjustEvent.setRevenue(0.01, "EUR");
adjustEvent.setReceiptForTransactionId("receipt", "transactionId");

Adjust.trackEvent(adjustEvent);
```

### 8. Add callback parameters

You can also register a callback URL for that event in your [dashboard] and we will send a GET request to that URL
whenever the event gets tracked. In that case you can also put some key-value-pairs in an object and pass it to the
`trackEvent` method. We will then append these named parameters to your callback URL.

For example, suppose you have registered the URL `http://www.adjust.com/callback` for your event with Event Token
`abc123` and execute the following lines:

```actionscript
var adjustEvent:AdjustEvent = new AdjustEvent("abc123");

adjustEvent.addCallbackParameter("key", "value");
adjustEvent.addCallbackParameter("foo", "bar");

Adjust.trackEvent(adjustEvent);
```

In this case we would track the event and send a request to:

```
http://www.adjust.com/callback?key=value&foo=bar
```

It should be mentioned that we support a variety of placeholders like `{idfa}` for iOS or `{android_id}` for Android
that can be used as parameter values.  In the resulting callback the `{idfa}` placeholder would be replaced with the
ID for Advertisers of the current device for iOS and the `{android_id}` would be replaced with the AndroidID of the
current device for Android. Also note that we don't store any of your custom parameters, but only append them to
your callbacks.  If you haven't registered a callback for an event, these parameters won't even be read.

### 9. Partner parameters

You can also add parameters for integrations that have been activated in
your adjust dashboard that are transmittable to network partners.

This works similarly to the callback parameters mentioned above, but can be added by calling the 
`addPartnerParameter` method on your `AdjustEvent` instance.

```actionscript
var adjustEvent:AdjustEvent = new AdjustEvent("abc123");

adjustEvent.addPartnerParameter("key", "value");
adjustEvent.addPartnerParameter("foo", "bar");

Adjust.trackEvent(adjustEvent);
```

You can read more about special partners and these integrations in our [guide to special partners.][special-partners]

### 10. Receive attribution change callback

You can register a callback to be notified of tracker attribution changes. Due to the different sources considered
for attribution, this information can not by provided synchronously. Follow these steps to implement the optional 
callback in your application:

1. Create void method which receives parameter of type `AdjustAttribution`.

2. After creating instance of `AdjustConfig` object, call the `adjustConfig.setAttributionCallbackDelegate`
with the previously created method.

The callback function will get called when the SDK receives final attribution data. Within the callback function you
have access to the `attribution` parameter. Here is a quick summary of its properties:

- `var trackerToken:String` the tracker token of the current install.
- `var trackerName:String` the tracker name of the current install.
- `var network:String` the network grouping level of the current install.
- `var campaign:String` the campaign grouping level of the current install.
- `var adgroup:String` the ad group grouping level of the current install.
- `var creative:String` the creative grouping level of the current install.
- `var clickLabel:String` the click label of the current install.

```actionscript
import com.adjust.sdk.Adjust;
import com.adjust.sdk.AdjustConfig;
import com.adjust.sdk.Environment;
import com.adjust.sdk.LogLevel;
import com.adjust.sdk.AdjustAttribution;

public class Example extends Sprite {
    public function Example() {
    	var appToken:String = "{YourAppToken}";
    	var environment:String = Environment.SANDBOX;
    	
        var adjustConfig:AdjustConfig = new AdjustConfig(appToken, environment);
        adjustConfig.setLogLevel(LogLevel.VERBOSE);
        adjustConfig.setAttributionCallbackDelegate(attributionCallbackDelegate);

        Adjust.start(adjustConfig);
    }
    
    // ...
    
    private static function attributionCallbackDelegate(attribution:AdjustAttribution):void {
        trace("Tracker token = " + attribution.getTrackerToken());
        trace("Tracker name = " + attribution.getTrackerName());
        trace("Campaign = " + attribution.getCampaign());
        trace("Network = " + attribution.getNetwork());
        trace("Creative = " + attribution.getCreative());
        trace("Adgroup = " + attribution.getAdGroup());
        trace("Click label = " + attribution.getClickLabel());
    }
}
```

Please make sure to consider [applicable attribution data policies.][attribution-data]

### 11. Set up deep link reattributions

You can set up the adjust SDK to handle deep links that are used to open your app. We will only read certain, adjust-specific parameters. This is essential if you are planning to run retargeting or re-engagement campaigns with deep
links. The only thing you need to do is to properly set your app schema name in app descriptor file, which is usually located at
`src/{YourProjectName}-app.xml`. By using this scheme name later for deep linking, our SDK will handle deep linking
automatically without need to set anything in your app source code.

#### iOS

In order to set scheme name for your iOS app, you should add the following key-value pair into the `<InfoAdditions>` section
of the app descriptor's `<iPhone>` section:

```xml
<iPhone>
    <!-- ... --->
    <InfoAdditions><![CDATA[
        <key>CFBundleURLTypes</key>
        <array>
            <dict>
              <key>CFBundleURLName</key>
              <string>com.adjust.example</string>
              <key>CFBundleURLSchemes</key>
              <array>
                <string>desired-scheme-name</string>
              </array>
            </dict>
        </array>
    ]]></InfoAdditions>
    <!-- ... -->
</iPhone>
```

#### Android

To set a scheme name for your Android app, you should add the following `<intent-filter>` to the activity you want to
launch after deep linking:

```xml
<!-- ... -->
    <activity>
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
            <intent-filter>
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="desired-scheme-name" />
        </intent-filter>
    </activity>
<!-- ... -->
```

### 12. Event buffering

If your app makes heavy use of event tracking, you might want to delay some HTTP requests in order to send them in
a single batch every minute. You can enable event buffering by calling the `adjustConfig.setEventBufferingEnabled` method
with parameter `true`.

```actionscript
adjustConfig.setEventBufferingEnabled(true);
```

### 13. Disable tracking

You can disable the adjust SDK from tracking by invoking the method `setEnabled` with the enabled parameter as
`false`. This setting is remembered between sessions, but it can only be activated after the first session.

```actionscript
Adjust.setEnabled(false);
```

You can verify if the adjust SDK is currently active with the method `isEnabled`. It is always possible
to activate the adjust SDK by invoking `setEnabled` with the `enabled` parameter set to `true`.

### 14. Offline mode

You can put the adjust SDK in offline mode to suspend transmission to our servers, while still retaining tracked data to
be sent later. While in offline mode, all information is saved in a file, so be careful not to trigger too many
events while in offline mode.

You can activate offline mode by calling `setOfflineMode` with the parameter `true`.

```actionscript
Adjust.setOfflineMode(true);
```

Conversely, you can deactivate offline mode by calling `setOfflineMode` with `false`. When the adjust SDK is put
back in online mode, all saved information is sent to our servers with the correct timstamps.

Unlike disabling tracking, this setting is *not remembered* between sessions. This means that the SDK is in online
mode whenever it is started, even if the app was terminated in offline mode.

### 15. Device IDs

Certain services (such as [Google Analytics][google-analytics]) require you to coordinate device IDs in order 
to prevent duplicate reporting.

You can call the following methods to retrieve the device IDs collected by the adjust SDK.

#### Android

If you need to obtain the Google Advertising ID, there is a restriction that only allows it to 
be read in a background thread.  If you call the function `getGoogleAdId` by passing a function which 
gets `String` variable as parameter to it, it will work in any situation:

```as
Adjust.getGoogleAdId(getGoogleAdIdCallback);

// ...

private static function getGoogleAdIdCallback(googleAdId:String):void {
    trace("Google Ad Id = " + googleAdId);
}
```

Inside the custom defined method `getGoogleAdIdCallback`, you will have access to the Google Advertising ID 
as the variable `googleAdId`.

#### iOS

To obtain the IDFA, call the function `getIdfa`:

```as
Adjust.getIdfa()
```

[adjust.com]: http://adjust.com
[dashboard]: http://adjust.com
[releases]: https://github.com/adjust/adjust_air_sdk/releases
[permissions]: https://raw.github.com/adjust/adjust_sdk/master/Resources/air/permissions.png
[xcode-logs]: https://raw.github.com/adjust/adjust_sdk/master/Resources/air/v4/xcode_logs.png
[google_play_services]: http://developer.android.com/google/play-services/setup.html
[google_ad_id]: https://developer.android.com/google/play-services/id.html
[attribution_data]: https://github.com/adjust/sdks/blob/master/doc/attribution-data.md
[special-partners]: https://docs.adjust.com/en/special-partners

[android-permissions]: https://github.com/adjust/android_sdk#5-add-permissions
[brodcast-android]: https://github.com/adjust/android_sdk#6-add-broadcast-receiver
[attribution-data]: https://github.com/adjust/sdks/blob/master/doc/attribution-data.md
[android-manifest]: https://raw.github.com/adjust/adjust_sdk/master/Resources/air/v4/android_manifest.png
[flash-builder]: https://github.com/adjust/adobe_air_sdk/blob/master/doc/flash_builder.md
[idea-locate]: https://raw.github.com/adjust/adjust_sdk/master/Resources/air/v4/idea_locate.png
[idea-new-library]: https://raw.github.com/adjust/adjust_sdk/master/Resources/air/v4/idea_new_library.png
[idea-new-library-gps]: https://raw.github.com/adjust/adjust_sdk/master/Resources/air/v4/idea_new_library_gps.png
[google-analytics]: https://docs.adjust.com/en/special-partners/google-analytics

## License

The adjust SDK is licensed under the MIT License.

Copyright (c) 2012-2016 adjust GmbH,
http://www.adjust.com

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
