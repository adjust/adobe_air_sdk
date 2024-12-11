## Summary

This is the Adobe AIR SDK of Adjust™. You can read more about Adjust™ at [adjust.com](https://adjust.com).

## Table of contents

* [Example app](#example-app)
* [Basic integration](#basic-integration)
   * [Get the SDK](#sdk-get)
   * [Add the SDK to your project](#sdk-add)
   * [Integrate the SDK into your app](#sdk-integrate)
   * [Adjust logging](#sdk-logging)
   * [Android permissions](#android-permissions)
   * [Google Play Services](#google-play-services)
   * [Install referrer](#install-referrer)
* [Additional features](#additional-features)
   * [AppTrackingTransparency framework](#ad-att-framework)
      * [App-tracking authorisation wrapper](#ad-ata-wrapper)
   * [SKAdNetwork framework](#ad-skadn-framework)
   * [Event tracking](#event-tracking)
      * [Revenue tracking](#revenue-tracking)
      * [Event deduplication](#event-deduplication)
      * [Callback parameters](#callback-parameters)
      * [Partner parameters](#partner-parameters)
      * [Callback identifier](#callback-id)
   * [Global parameters](#global-parameters)
      * [Global callback parameters](#global-callback-parameters)
      * [Global partner parameters](#global-partner-parameters)
   * [Attribution callback](#attribution-callback)
   * [Session and event callbacks](#session-event-callbacks)
   * [Disable tracking](#disable-tracking)
   * [Offline mode](#offline-mode)
   * [GDPR right to be forgotten](#gdpr-forget-me)
   * [Background tracking](#background-tracking)
   * [Device IDs](#device-ids)
      * [iOS advertising identifier](#di-idfa)
      * [Google Play Services advertising identifier](#di-gps-adid)
      * [Amazon advertising identifier](#di-fire-adid)
      * [Adjust device identifier](#di-adid)
   * [Set external device ID](#set-external-device-id)
   * [User attribution](#user-attribution)
   * [Push token](#push-token)
   * [Pre-installed trackers](#pre-installed-trackers)
   * [Deep linking](#deeplinking)
      * [Standard deep linking scenario](#deeplinking-standard)
      * [Deferred deep linking scenario](#deeplinking-deferred)
      * [Deep linking setup for Android](#deeplinking-android)
      * [Deep linking setup for iOS](#deeplinking-ios)
      * [Reattribution via deep links](#deeplinking-reattribution)
* [License](#license)

## <a id="example-app"></a>Example app

There is an example app inside the [`example` directory](./example). You can use the example app to see how the Adjust SDK can be integrated.

## <a id="basic-integration"></a>Basic integration

These are the minimal steps required to integrate the Adjust SDK into your Adobe AIR project.

### <a id="sdk-get"></a>Get the SDK

Download the latest version from our [releases page](https://github.com/adjust/adjust_air_sdk/releases).

### <a id="sdk-add"></a>Add the SDK to your project

Add the downloaded Adjust SDK ANE file to your app. After this, add the Adjust SDK extension to your app's descriptor file:

```xml
<extensions>
    <!-- ... --->
    <extensionID>com.adjust.sdk</extensionID>
    <!-- ... --->
</extensions>
```

### <a id="sdk-integrate"></a>Integrate the SDK into your app

To start tracking with Adjust, you first need to initialize the SDK:

```actionscript
import com.adjust.sdk.Adjust;
import com.adjust.sdk.AdjustConfig;
import com.adjust.sdk.AdjustEnvironment;
import com.adjust.sdk.AdjustLogLevel;

var adjustConfig:AdjustConfig = new AdjustConfig("{YourAppToken}", AdjustEnvironment.SANDBOX);
adjustConfig.setLogLevel(AdjustLogLevel.VERBOSE);

Adjust.initSdk(adjustConfig);
```

Replace `{YourAppToken}` with your app token. You can find this in your [dashboard](https://dash.adjust.com).

Depending on whether you build your app for testing or for production, you must set `environment` with one of these values:

```actionscript
var environment:String = AdjustEnvironment.SANDBOX;
var environment:String = AdjustEnvironment.PRODUCTION;
```

**Important:** This value should be set to `AdjustEnvironment.SANDBOX` if and only if you or someone else is testing your app. Make sure to set the environment to `AdjustEnvironment.PRODUCTION` just before you publish the app. Set it back to `AdjustEnvironment.SANDBOX` when you start developing and testing it again.

We use this environment to distinguish between real traffic and test traffic from test devices. It is very important that you keep this value meaningful at all times!

### <a id="sdk-logging"></a>Adjust logging

You can increase or decrease the amount of logs you see in tests by calling `setLogLevel` on your `AdjustConfig` instance with one of the following parameters:

```actionscript
adjustConfig.setLogLevel(AdjustLogLevel.VERBOSE);     // enable all logging
adjustConfig.setLogLevel(AdjustLogLevel.DEBUG);       // enable more logging
adjustConfig.setLogLevel(AdjustLogLevel.INFO);        // the default
adjustConfig.setLogLevel(AdjustLogLevel.WARN);        // disable info logging
adjustConfig.setLogLevel(AdjustLogLevel.ERROR);       // disable warnings as well
adjustConfig.setLogLevel(AdjustLogLevel.ASSERT);      // disable errors as well
adjustConfig.setLogLevel(AdjustLogLevel.SUPPRESS);    // disable all log output
```

### <a id="android-permissions"></a>Android permissions

The Adjust SDK includes the `com.google.android.gms.AD_ID` and `android.permission.INTERNET` permissions by default. You can remove the `com.google.android.gms.AD_ID` permission by adding a remove directive to your app's descriptor file if you need to make your app COPPA-compliant or if you don't target the Google Play Store.

```xml
<manifestAdditions>
    <![CDATA[
        <manifest>
            <uses-permission android:name="com.google.android.gms.AD_ID" tools:node="remove" />
        </manifest>
    ]]>
</manifestAdditions>
```

See Google's [AdvertisingIdClient.Info](https://developers.google.com/android/reference/com/google/android/gms/ads/identifier/AdvertisingIdClient.Info#public-string-getid) documentation for more information about this permission.

### <a id="google-play-services"></a>Google Play Services

To allow the Adjust SDK to use the Google Advertising ID, you must integrate the [Google Play Services](https://developers.google.com/android/guides/setup).

In case you don't already have Google Play Services added to your app (as part of some other ANE or in some other way) you can use `Google Play Services ANE`, which is provided by Adjust and is built to fit the needs of our SDK. You can find our Google Play Services ANE as part of release on our [releases page](https://github.com/adjust/adjust_air_sdk/releases).

You will need to import the downloaded ANE into your app, and the Google Play Services needed by our SDK will be added. After this, add the Google Play Services extension to app's descriptor file:

```xml
<extensions>
    <!-- ... --->
    <extensionID>com.adjust.gps</extensionID>
    <!-- ... --->
</extensions>
```

After integrating Google Play Services into your app, add the following lines to your app's Android manifest file as part of the `<manifest>` tag body:

```xml
<manifestAdditions>
    <![CDATA[
        <manifest>
            <application>
                <meta-data
                    android:name="com.google.android.gms.version"
                    android:value="@integer/google_play_services_version"/>
            </application>
        </manifest>
    ]]>
</manifestAdditions>
```

### <a id="install-referrer"></a>Install referrer

In order to correctly attribute an install of your Android app to its source, Adjust needs information about the **install referrer**.

In case you haven't added native install referrer dependency to your app (as part of some other ANE or in some other way), Adjust provides an install referrer ANE which is built to fit the needs of our SDK. You can find our Google install referrer ANE as part of the release on our [releases page](https://github.com/adjust/adjust_air_sdk/releases).

You will need to import the downloaded ANE into your app. After that, add the ANE extension to your app's descriptor file:

```xml
<extensions>
    <!-- ... --->
    <extensionID>com.adjust.installref</extensionID>
    <!-- ... --->
</extensions>
```

Also, make sure that you have added Android permission to allow the install referrer ANE to fetch install referrer data:

```xml
<android> 
    <manifestAdditions> 
        <![CDATA[ 
            <manifest>
                <uses-permission android:name="com.google.android.finsky.permission.BIND_GET_INSTALL_REFERRER_SERVICE" />
                <application>
                    <! -- ... -- >
                </application>
            </manifest>
        ]]> 
    </manifestAdditions> 
</android>
```

## <a id="additional-features"></a>Additional features

You can take advantage of the following features once the Adjust SDK is integrated into your project.

### <a id="ad-att-framework"></a>AppTrackingTransparency framework

**Note**: This feature exists only in iOS platform.

For each package sent, the Adjust backend receives one of the following four (4) states of consent for access to app-related data that can be used for tracking the user or the device:

- Authorized
- Denied
- Not Determined
- Restricted

After a device receives an authorization request to approve access to app-related data, which is used for user device tracking, the returned status will either be Authorized or Denied.

Before a device receives an authorization request for access to app-related data, which is used for tracking the user or device, the returned status will be Not Determined.

If authorization to use app tracking data is restricted, the returned status will be Restricted.

The SDK has a built-in mechanism to receive an updated status after a user responds to the pop-up dialog, in case you don't want to customize your displayed dialog pop-up. To conveniently and efficiently communicate the new state of consent to the backend, Adjust SDK offers a wrapper around the app tracking authorization method described in the following chapter, App-tracking authorization wrapper.

### <a id="ad-ata-wrapper"></a>App-tracking authorisation wrapper

**Note**: This feature exists only in iOS platform.

Adjust SDK offers the possibility to use it for requesting user authorization in accessing their app-related data. Adjust SDK has a wrapper built on top of the [requestTrackingAuthorizationWithCompletionHandler:](https://developer.apple.com/documentation/apptrackingtransparency/attrackingmanager/3547037-requesttrackingauthorizationwith?language=objc) method, where you can as well define the callback method to get information about a user's choice. Also, with the use of this wrapper, as soon as a user responds to the pop-up dialog, it's then communicated back using your callback method. The SDK will also inform the backend of the user's choice. The `int` value will be delivered via your callback method with the following meaning:

- 0: `ATTrackingManagerAuthorizationStatusNotDetermined`
- 1: `ATTrackingManagerAuthorizationStatusRestricted`
- 2: `ATTrackingManagerAuthorizationStatusDenied`
- 3: `ATTrackingManagerAuthorizationStatusAuthorized`

To use this wrapper, you can call it as such:

```actionscript
Adjust.requestAppTrackingAuthorization(function (status:int): void {
    trace("Authorization status = " + status.toString());
});
```

### <a id="ad-skadn-framework"></a>SKAdNetwork framework

**Note**: This feature exists only in iOS platform.

We automatically register for SKAdNetwork attribution when the SDK is initialized. If events are set up in the Adjust dashboard to receive conversion values, the Adjust backend sends the conversion value data to the SDK. The SDK then sets the conversion value. After Adjust receives the SKAdNetwork callback data, it is then displayed in the dashboard.

In case you don't want the Adjust SDK to automatically communicate with SKAdNetwork, you can disable that by calling the following method on configuration object:

```actionscript
adjustConfig.disableSkanAttribution();
```

### <a id="event-tracking"></a>Event tracking

You can tell Adjust about every event you want to track. Let's say that event token is `abc123`. You can add the following line in your button’s click handler method to track the click:

```actionscript
var adjustEvent:AdjustEvent = new AdjustEvent("abc123");
Adjust.trackEvent(adjustEvent);
```

### <a id="revenue-tracking"></a>Revenue tracking

If your users can generate revenue by tapping on advertisements or making in-app purchases, then you can track those revenues with events. Let's say a tap is worth €1.50. You could track the revenue event like this:

```actionscript
var adjustEvent:AdjustEvent = new AdjustEvent("abc123");
adjustEvent.setRevenue(1.50, "EUR");
Adjust.trackEvent(adjustEvent);
```

### <a id="revenue-deduplication"></a>Event deduplication

You can also add an optional deduplication ID to avoid tracking duplicate events. The last ten transaction IDs are remembered by default, and events with duplicate deduplication IDs are skipped. If you would like to make the Adjust SDK to remember more than last 10 transaction IDs, you can do that by passing the new limit to `setEventDeduplicationIdsMaxSize` method of the `AdjustConfig` instance:

```actionscript
var adjustConfig:AdjustConfig = new AdjustConfig("{YourAppToken}", AdjustEnvironment.SANDBOX);
adjustConfig.setLogLevel(AdjustLogLevel.VERBOSE);
adjustConfig.setEventDeduplicationIdsMaxSize(20);
Adjust.initSdk(adjustConfig);

// ...

var adjustEvent:AdjustEvent = new AdjustEvent("abc123");
adjustEvent.setDeduplicationId("deduplicationId");
Adjust.trackEvent(adjustEvent);
```

### <a id="callback-parameters"></a>Callback parameters

You can also register a callback URL for that event in your [dashboard](https://dash.adjust.com), and we will send a GET request to that URL whenever the event gets tracked. In that case, you can also put some key-value pairs in an object and pass it to the `trackEvent` method. We will then append these named parameters to your callback URL.

For example, suppose you have registered the URL `http://www.adjust.com/callback` for your event with event token `abc123` and execute the following lines:

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

It should be mentioned that we support a variety of placeholders like `{idfa}` for iOS or `{gps_adid}` for Android that can be used as parameter values. In the resulting callback, the `{idfa}` placeholder would be replaced with the ID for Advertisers of the current device for iOS and the `{gps_adid}` would be replaced with the Google Advertising ID of the current device for Android. Also note that we don't store any of your custom parameters, but only append them to your callbacks. If you haven't registered a callback for an event, these parameters won't even be read.

### <a id="partner-parameters"></a>Partner parameters

You can also add parameters for integrations that have been activated in your Adjust dashboard that can be transmitted to network partners.

This works similarly to the callback parameters mentioned above, but can be added by calling the `addPartnerParameter` method on your `AdjustEvent` instance.

```actionscript
var adjustEvent:AdjustEvent = new AdjustEvent("abc123");
adjustEvent.addPartnerParameter("key", "value");
adjustEvent.addPartnerParameter("foo", "bar");
Adjust.trackEvent(adjustEvent);
```

### <a id="callback-id"></a>Callback identifier

You can also add custom string identifier to each event you want to track. This identifier will later be reported in event success and/or event failure callbacks to enable you to keep track on which event was successfully tracked or not. You can set this identifier by calling the `setCallbackId` method on your `AdjustEvent` instance:

```actionscript
var adjustEvent:AdjustEvent = new AdjustEvent("abc123");
adjustEvent.setCallbackId("Your-Custom-Id");
Adjust.trackEvent(adjustEvent);
```

### <a id="global-parameters"></a>Global parameters

Some parameters are saved to be sent in every session, event, ad revenue and subscription request of the Adjust SDK. Once you have added any of these parameters, you don't need to add them every time, since they will be saved locally. If you add the same parameter twice, there will be no effect. These global parameters can be set before the Adjust SDK is launched to make sure they are sent even on install.

### <a id="global-callback-parameters"></a>Global callback parameters

The global callback parameters have a similar interface to the event callback parameters. Instead of adding the key and its value to an event, it's added through a call to method `addGlobalCallbackParameter` of the `Adjust` class:

```actionscript
Adjust.addGlobalCallbackParameter("foo", "bar");
```

The global callback parameters will be merged with the callback parameters added to an event / ad revenue / subscription. The callback parameters added to any of these packages take precedence over the global callback parameters. Meaning that, when adding a callback parameter to any of these packages with the same key to one added globaly, the value that prevails is the callback parameter added any of these particular packages.

It's possible to remove a specific global callback parameter by passing the desired key to the method `removeGlobalCallbackParameter` of the `Adjust` class.

```actionscript
Adjust.removeGlobalCallbackParameter("foo");
```

If you wish to remove all keys and values from the global callback parameters, you can reset it with the method `removeGlobalCallbackParameters` of the `Adjust` class.

```actionscript
Adjust.removeGlobalCallbackParameters();
```

### <a id="global-partner-parameters"></a>Global partner parameters

In the same way that there are [global callback parameters](#session-callback-parameters) that are sent for every event or session of the Adjust SDK, there are also global partner parameters.

These will be transmitted to network partners, for the integrations that have been activated in your Adjust [dashboard](https://dash.adjust.com).

The global partner parameters have a similar interface to the event / ad revenue / subscription partner parameters. Instead of adding the key and its value to an event, it's added through a call to method `addGlobalPartnerParameter` of the `Adjust` class:

```actionscript
Adjust.addGlobalPartnerParameter("foo", "bar");
```

The global partner parameters will be merged with the partner parameters added to an event / ad revenue / subscription. The partner parameters added to any of thes packages take precedence over the global partner parameters. Meaning that, when adding a partner parameter to any of these packages with the same key to one added globally, the value that prevails is the partner parameter added to any of these particular packages.

It's possible to remove a specific global partner parameter by passing the desired key to the method `removeGlobalPartnerParameter` of the `Adjust` class.

```actionscript
Adjust.removeGlobalPartnerParameter("foo");
```

If you wish to remove all keys and values from the global partner parameters, you can reset them with the method `removeGlobalPartnerParameters` of the `Adjust` class.

```actionscript
Adjust.removeGlobalPartnerParameters();
```

### <a id="attribution-callback"></a>Attribution callback

You can register a callback to be notified of attribution changes. Due to the different sources considered for attribution, this information can not be provided synchronously. You can implement attribution callback like this:

```actionscript
import com.adjust.sdk.Adjust;
import com.adjust.sdk.AdjustConfig;
import com.adjust.sdk.AdjustEnvironment;
import com.adjust.sdk.AdjustLogLevel;
import com.adjust.sdk.AdjustAttribution;

var adjustConfig:AdjustConfig = new AdjustConfig("{YourAppToken}", AdjustEnvironment.SANDBOX);
adjustConfig.setLogLevel(AdjustLogLevel.VERBOSE);

adjustConfig.setAttributionCallback(function (attribution:AdjustAttribution): void {
    trace("Tracker token = " + attribution.getTrackerToken());
    trace("Tracker name = " + attribution.getTrackerName());
    trace("Campaign = " + attribution.getCampaign());
    trace("Network = " + attribution.getNetwork());
    trace("Creative = " + attribution.getCreative());
    trace("Adgroup = " + attribution.getAdgroup());
    trace("Click label = " + attribution.getClickLabel());
    trace("Cost type = " + attribution.getCostType());
    trace("Cost amount = " + isNaN(attribution.getCostAmount()) ? "NaN" : attribution.getCostAmount().toString());
    trace("Cost currency = " + attribution.getCostCurrency());
    trace("FB install referrer = " + attribution.getFbInstallReferrer());
});

Adjust.initSdk(adjustConfig);
```

The callback function will get called when the SDK receives final attribution data. Within the callback function you have access to the `attribution` parameter. Here is a quick summary of its properties:

- `var trackerToken:String` the tracker token of the current attribution.
- `var trackerName:String` the tracker name of the current attribution.
- `var network:String` the network grouping level of the current attribution.
- `var campaign:String` the campaign grouping level of the current attribution.
- `var adgroup:String` the ad group grouping level of the current attribution.
- `var creative:String` the creative grouping level of the current attribution.
- `var clickLabel:String` the click label of the current attribution.
- `var costType:String` the cost type in case cost data is part of the attribution.
- `var costAmount:Number` the cost amount in case cost data is part of the attribution.
- `var costCurrency:String` the cost currency in case cost data is part of the attribution.
- `var fbInsallReferrer:String` the FB install referrer value in case install is attributed to it.

### <a id="session-event-callbacks"></a>Session and event callbacks

You can register a callback to be notified of successful and failed tracked events and/or sessions.

Follow the same steps to implement the callback for successfully tracked events:

```actionscript
import com.adjust.sdk.Adjust;
import com.adjust.sdk.AdjustConfig;
import com.adjust.sdk.AdjustEnvironment;
import com.adjust.sdk.AdjustLogLevel;
import com.adjust.sdk.AdjustAttribution;

var adjustConfig:AdjustConfig = new AdjustConfig("{YourAppToken}", AdjustEnvironment.SANDBOX);
adjustConfig.setLogLevel(AdjustLogLevel.VERBOSE);

adjustConfig.setEventSuccessCallback(function (eventSuccess:AdjustEventSuccess):void {
    trace("Event tracking success");
    trace("Message = " + eventSuccess.getMessage());
    trace("Timestamp = " + eventSuccess.getTimestamp());
    trace("Adid = " + eventSuccess.getAdid());
    trace("Event Token = " + eventSuccess.getEventToken());
    trace("Callback Id = " + eventSuccess.getCallbackId());
    trace("Json Response = " + eventSuccess.getJsonResponse());
}

Adjust.initSdk(adjustConfig);
```

The callback function for failed tracked events:

```actionscript
import com.adjust.sdk.Adjust;
import com.adjust.sdk.AdjustConfig;
import com.adjust.sdk.AdjustEnvironment;
import com.adjust.sdk.AdjustLogLevel;
import com.adjust.sdk.AdjustAttribution;

var adjustConfig:AdjustConfig = new AdjustConfig("{YourAppToken}", AdjustEnvironment.SANDBOX);
adjustConfig.setLogLevel(AdjustLogLevel.VERBOSE);

adjustConfig.setEventFailureCallback(function (eventFailure:AdjustEventFailure):void {
    trace("Event tracking failure");
    trace("Message = " + eventFailure.getMessage());
    trace("Timestamp = " + eventFailure.getTimestamp());
    trace("Adid = " + eventFailure.getAdid());
    trace("Event Token = " + eventFailure.getEventToken());
    trace("Callback Id = " + eventFailure.getCallbackId());
    trace("Will Retry = " + eventFailure.getWillRetry().toString());
    trace("Json Response = " + eventFailure.getJsonResponse());
}

Adjust.initSdk(adjustConfig);
```

For successfully tracked sessions:

```actionscript
import com.adjust.sdk.Adjust;
import com.adjust.sdk.AdjustConfig;
import com.adjust.sdk.AdjustEnvironment;
import com.adjust.sdk.AdjustLogLevel;
import com.adjust.sdk.AdjustAttribution;

var adjustConfig:AdjustConfig = new AdjustConfig("{YourAppToken}", AdjustEnvironment.SANDBOX);
adjustConfig.setLogLevel(AdjustLogLevel.VERBOSE);

adjustConfig.setSessionSuccessCallback(function (sessionSuccess:AdjustSessionSuccess): void {
    trace("Session tracking success");
    trace("Message = " + sessionSuccess.getMessage());
    trace("Timestamp = " + sessionSuccess.getTimestamp());
    trace("Adid = " + sessionSuccess.getAdid());
    trace("Json Response = " + sessionSuccess.getJsonResponse());
}

Adjust.initSdk(adjustConfig);
```

And for failed tracked sessions:

```actionscript
import com.adjust.sdk.Adjust;
import com.adjust.sdk.AdjustConfig;
import com.adjust.sdk.AdjustEnvironment;
import com.adjust.sdk.AdjustLogLevel;
import com.adjust.sdk.AdjustAttribution;

var adjustConfig:AdjustConfig = new AdjustConfig("{YourAppToken}", AdjustEnvironment.SANDBOX);
adjustConfig.setLogLevel(AdjustLogLevel.VERBOSE);

adjustConfig.setSessionFailureCallback(function (sessionFailure:AdjustSessionFailure):void {
    trace("Session tracking failure");
    trace("Message = " + sessionFailure.getMessage());
    trace("Timestamp = " + sessionFailure.getTimestamp());
    trace("Adid = " + sessionFailure.getAdid());
    trace("Will Retry = " + sessionFailure.getWillRetry().toString());
    trace("Json Response = " + sessionFailure.getJsonResponse());
}

Adjust.initSdk(adjustConfig);
```

The callback functions will be called after the SDK tries to send a package to the server. Within the callback, you have access to a response data object specifically for the callback. Here is a quick summary of the session response data properties:

- `var message:String` the message from the server or the error logged by the SDK.
- `var timestamp:String` timestamp from the server.
- `var adid:String` a unique device identifier provided by Adjust.
- `var jsonResponse:String` the JSON object with the response from the server.

Both event response data objects contain:

- `var eventToken:String` the event token, if the package tracked was an event.
- `var callbackId:String` the custom defined callback ID set on event object.

And both event and session failed objects also contain:

- `var willRetry:Boolean;` indicates there will be an attempt to resend the package at a later time.

### <a id="disable-tracking"></a>Disable tracking

You can disable the Adjust SDK from tracking by invoking the method `disable` of the `Adjust` class. This setting is **remembered between sessions**.

```actionscript
Adjust.disable();
```

You can verify if the Adjust SDK is currently active with the method `isEnabled` of the `Adjust` class. It is always possible to activate the Adjust SDK by invoking `enable` method of the `Adjust` class.

```actionscript
Adjust.enable();
```

### <a id="offline-mode"></a>Offline mode

You can put the Adjust SDK in offline mode to suspend transmission to our servers, while still retaining tracked data to be sent later. While in offline mode, all information is saved in a file, so be careful not to trigger too many events while in offline mode.

You can activate offline mode by calling the method `switchToOfflineMode` of the `Adjust` class.

```actionscript
Adjust.switchToOfflineMode();
```

Conversely, you can deactivate the offline mode by calling `switchBackToOnlineMode` method of the `Adjust` class. When the Adjust SDK is put back in online mode, all saved information is sent to our servers with the correct timstamps.

Unlike disabling tracking, this setting is **not remembered between sessions**. This means that the SDK is in online mode whenever it is started, even if the app was terminated in offline mode.

### <a id="gdpr-forget-me"></a>GDPR right to be forgotten

In accordance with article 17 of the EU's General Data Protection Regulation (GDPR), you can notify Adjust when a user has exercised their right to be forgotten. Calling the following method will instruct the Adjust SDK to communicate the user's choice to be forgotten to the Adjust backend:

```actionscript
Adjust.gdprForgetMe();
```

Upon receiving this information, Adjust will erase the user's data and the Adjust SDK will stop tracking the user. No requests from this device will be sent to Adjust in the future.

### <a id="background-tracking"></a>Background tracking

The default behaviour of the Adjust SDK is to **pause sending HTTP requests while the app is in the background**. You can change this in your `AdjustConfig` instance by calling the `enableSendingInBackground` method:

```actionscript
var adjustConfig:AdjustConfig = new AdjustConfig("{YourAppToken}", AdjustEnvironment.SANDBOX);

adjustConfig.enableSendingInBackground();

Adjust.initSdk(adjustConfig);
```

If nothing is set, sending in background is **disabled by default**.

### <a id="device-ids"></a>Device IDs

Certain services (such as Google Analytics) require you to coordinate Device and Client IDs in order to prevent duplicate reporting.

### <a id="di-idfa"></a>IDFA

To obtain the IDFA, call the function `getIdfa` of the `Adjust` class:

```as
Adjust.getIdfa(function (idfa:String): void {
    trace("IDFA = " + idfa);
});
```

### <a id="di-gps-adid"></a>Google advertising identifier

To obtain Google advertising ID, call the function `getGoogleAdId` of the `Adjust` class:

```actionscript
Adjust.getGoogleAdId(function (googleAdId:String): void {
    trace("Google Ad ID = " + googleAdId);
});
```

### <a id="di-fire-adid"></a>Amazon advertising identifier

If you need to obtain the Amazon advertising ID, you can call the `getAmazonAdId` method of the `Adjust` class:

```actionscript
Adjust.getAmazonAdId(function (amazonAdId:String): void {
    trace("Amazon Ad ID = " + amazonAdId);
});
```

### <a id="di-adid"></a>Adjust device identifier

For every device with your app installed on it, the Adjust backend generates a unique **Adjust device identifier** (**adid**). In order to obtain this identifier, you can make a call to `getAdid` method of the `Adjust` class:

```actionscript
Adjust.getAdid(function (adid:String): void {
    trace("Adjust device ID = " + adid);
});
```

**Note**: Information about the **adid** is available after app installation has been tracked by the Adjust backend. From that moment on, the Adjust SDK has information about the device **adid** and you can access it with this method. So, **it is not possible** to access the **adid** value before the SDK has been initialised and installation of your app has been successfully tracked.

### <a id="set-external-device-id"></a>Set external device ID

> **Note** If you want to use external device IDs, please contact your Adjust representative. They will talk you through the best approach for your use case.

An external device identifier is a custom value that you can assign to a device or user. They can help you to recognize users across sessions and platforms. They can also help you to deduplicate installs by user so that a user isn't counted as multiple new installs.

You can also use an external device ID as a custom identifier for a device. This can be useful if you use these identifiers elsewhere and want to keep continuity.

Check out our [external device identifiers article](https://help.adjust.com/en/article/external-device-identifiers) for more information.

To set an external device ID, assign the identifier to the `externalDeviceId` property of your `AdjustConfig` instance. Do this before you initialize the Adjust SDK.

```actionscript
adjustConfig.setExternalDeviceId("{Your-External-Device-Id}");

Adjust.initSdk(adjustConfig);
```

> **Important**: You need to make sure this ID is **unique to the user or device** depending on your use-case. Using the same ID across different users or devices could lead to duplicated data. Talk to your Adjust representative for more information.

If you want to use the external device ID in your business analytics, you can pass it as a session callback parameter. See the section on [session callback parameters](#session-callback-parameters) for more information.

You can import existing external device IDs into Adjust. This ensures that the backend matches future data to your existing device records. If you want to do this, please contact your Adjust representative.

### <a id="user-attribution"></a>User attribution

As described in the [attribution callback section](#attribution-callback), this callback is triggered, providing you with information about a new attribution whenever it changes. If you want to access information about a user's current attribution whenever you need it, you can make a call to the `getAttribution` method of the `Adjust` class:

```actionscript
Adjust.getAttribution(function (attribution:AdjustAttribution): void {
    trace("Tracker token = " + attribution.getTrackerToken());
    trace("Tracker name = " + attribution.getTrackerName());
    trace("Campaign = " + attribution.getCampaign());
    trace("Network = " + attribution.getNetwork());
    trace("Creative = " + attribution.getCreative());
    trace("Adgroup = " + attribution.getAdgroup());
    trace("Click label = " + attribution.getClickLabel());
    trace("Cost type = " + attribution.getCostType());
    trace("Cost amount = " + isNaN(attribution.getCostAmount()) ? "NaN" : attribution.getCostAmount().toString());
    trace("Cost currency = " + attribution.getCostCurrency());
    trace("FB install referrer = " + attribution.getFbInstallReferrer());
});
```

**Note**: Information about current attribution is available after app installation has been tracked by the Adjust backend and the attribution callback has been initially triggered. From that moment on, the Adjust SDK has information about a user's attribution and you can access it with this method. So, **it is not possible** to access a user's attribution value before the SDK has been initialised and an attribution callback has been triggered.

### <a id="push-token"></a>Push token

To send us the push notification token, add the following call to Adjust **whenever you get your token in the app or when it gets updated**:

```actionscript
Adjust.setPushToken("YourPushNotificationToken");
```

Push tokens are used for Audience Builder and client callbacks, and they are required for the uninstall tracking feature.

### <a id="pre-installed-trackers"></a>Pre-installed trackers

If you want to use the Adjust SDK to recognize users that found your app pre-installed on their device, follow these steps.

1. Create a new tracker in your [dashboard].
2. Open your app delegate and add set the default tracker of your `adjust_config` instance:

    ```actionscript
    var adjustConfig:AdjustConfig = new AdjustConfig("{YourAppToken}", AdjustEnvironment.SANDBOX);

    adjustConfig.setDefaultTracker("{TrackerToken}");
    
    Adjust.initSdk(adjustConfig);
    ```

  Replace `{TrackerToken}` with the tracker token you created in step 2. In your source code, you should specify only the six-character token and not the entire URL.

3. Build and run your app. You should see a line like the following in the app's log output:

    ```
    Default tracker: 'abc123'
    ```

### <a id="deeplinking"></a>Deep linking

If you are using the Adjust tracker URL with an option to deep link into your app from the URL, there is the possibility to get information about the deep link URL and its content. Hitting the URL can happen when the user has your app already installed (standard deep linking scenario) or if they don't have the app on their device (deferred deep linking scenario).

### <a id="deeplinking-standard"></a>Standard deep linking scenario

The standard deep linking scenario is a platform specific feature, and in order to support it, you need to add some additional settings to your app.

In order to get information about the URL content in a standard deep linking scenario, you should subscribe to the `InvokeEvent.INVOKE` event and set up a callback method which will be triggered once this event happens. Inside of that callback method, you can access the URL of the deep link which opened your app:

```actionscript
var app:NativeApplication = NativeApplication.nativeApplication;
app.addEventListener(InvokeEvent.INVOKE, onInvoke);

// ...

private static function onInvoke(event:InvokeEvent):void {
    if (event.arguments.length == 0) {
        return;
    }

    var deeplink:String = event.arguments[0];
    
    trace("Deeplink = " + deeplink);
}
```

### <a id="deeplinking-deferred"></a>Deferred deep linking scenario

While deferred deep linking is not supported out of the box on Android and iOS, our Adjust SDK makes it possible.

In order to get information about the URL content in a deferred deep linking scenario, you should set a callback method on the `AdjustConfig` object, which will receive one `String` parameter where the content of the URL will be delivered. You should set this method on the config object by calling the method `setDeferredDeeplinkCallback`:

```actionscript
var adjustConfig:AdjustConfig = new AdjustConfig("{YourAppToken}", AdjustEnvironment.SANDBOX);
adjustConfig.setDeferredDeeplinkCallback(function (deeplink:String):void {
    trace("Received Deferred Deeplink");
    trace("Deep link = " + deeplink);
));
Adjust.initSdk(adjustConfig);
```

In a deferred deep linking scenario, there is one additional setting which can be set on the `AdjustConfig` object. Once the Adjust SDK gets the deferred deep link information, you have the possibility to choose whether our SDK should open this URL or not. You can choose to set this option by calling the `disableDeferredDeeplinkOpening` method on the `AdjustConfig` instance:

```actionscript
var adjustConfig:AdjustConfig = new AdjustConfig("{YourAppToken}", AdjustEnvironment.SANDBOX);
adjustConfig.disableDeferredDeeplinkOpening();
adjustConfig.setDeferredDeeplinkCallback(function (deeplink:String):void {
    trace("Received Deferred Deeplink");
    trace("Deep link = " + deeplink);
));
Adjust.initSdk(adjustConfig);
```

If nothing is set, **the Adjust SDK will always try to launch the URL by default**.

To enable your app to support deep linking, you should do some additional set up for each supported platform.

### <a id="deeplinking-android"></a>Deep linking setup for Android

To set a scheme name for your Android app, you should add the following `<intent-filter>` to the activity you want to launch after deep linking:

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
        <data android:scheme="schemeName" />
    </intent-filter>
</activity>
<!-- ... -->
```

You should replace `schemeName` with your desired scheme name for Android app.

### <a id="deeplinking-ios"></a>Deep linking setup for iOS

In order to set a scheme name for your iOS app, you should add the following key-value pair into the `<InfoAdditions>` section of the app descriptor's `<iPhone>` section:

```xml
<iPhone>
    <!-- ... --->
    <InfoAdditions><![CDATA[
        <key>CFBundleURLTypes</key>
        <array>
            <dict>
              <key>CFBundleURLName</key>
              <string>com.your.bundle</string>
              <key>CFBundleURLSchemes</key>
              <array>
                <string>schemeName</string>
              </array>
            </dict>
        </array>
    ]]></InfoAdditions>
    <!-- ... -->
</iPhone>
```

You should replace `com.your.bundle` with your app's bundle ID and `schemeName` with your desired scheme name for iOS app.

**Important**: By using this approach for deep linking support in iOS, you will support deep link handling for devices running on **iOS 8 and lower**. Starting from **iOS 9**, Apple has introduced universal links for which, at this moment, there's no built in support inside the Adobe AIR platform. To support this, you would need to edit the natively generated iOS project in Xcode (if possible) and add support to handle universal links from there. If you are interested in finding out how to do that on the native side, please consult our [native iOS universal links guide][universal-links-guide].

### <a id="deeplinking-reattribution"></a>Reattribution via deep links

Adjust enables you to run re-engagement campaigns through deep links.

If you are using this feature, in order for your user to be properly reattributed, you need to make one additional call to the Adjust SDK in your app.

Once you have received deep link content information in your app, add a call to the `Adjust.processDeeplink` method. By making this call, the Adjust SDK will try to find if there is any new attribution information inside of the deep link. If there is any, it will be sent to the Adjust backend. If your user should be reattributed due to a click on the adjust tracker URL with deep link content, you will see the [attribution callback](#attribution-callback) in your app being triggered with new attribution info for this user.

```actionscript
var app:NativeApplication = NativeApplication.nativeApplication;
app.addEventListener(InvokeEvent.INVOKE, onInvoke);

// ...

private static function onInvoke(event:InvokeEvent):void {
    if (event.arguments.length == 0) {
        return;
    }

    var deeplink:String = event.arguments[0];
    trace("Deeplink = " + deeplink);
    var adjustDeeplink:AdjustDeeplink = new AdjustDeeplink(deeplink);
    Adjust.processDeeplink(adjustDeeplink);
}
```

## License

The Adjust SDK is licensed under the MIT License.

Copyright (c) 2012-Present Adjust GmbH, http://www.adjust.com

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
