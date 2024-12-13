# Adobe AIR SDK v5 migration guide

The [Adjust Adobe AIR SDK](https://github.com/adjust/adobe_air_sdk) has been updated to v5. Follow this guide to migrate from v4 to the latest version.

## Before you begin

The minimum supported iOS and Android versions have been updated. If your app targets a lower version, update it first.

- iOS: **12.0**
- Android: **API 21**

### Update the initialization method

In Adobe AIR SDK v5, the initialization method has changed from `Adjust.start` to `Adjust.initSdk`.

```actionscript
Adjust.initSdk(adjustConfig);
```

### Environment

In Adobe AIR SDK v5, the environment class has been renamed from `Environment` to `AdjustEnvironment`.

```actionscript
var environment:String = AdjustEnvironment.SANDBOX;
var environment:String = AdjustEnvironment.PRODUCTION;
```

### Log level

In Adobe AIR SDK v5, the log level class has been renamed from `LogLevel` to `AdjustLogLevel`.

```actionscript
adjustConfig.setLogLevel(AdjustLogLevel.VERBOSE);
```

### Android permissions

In Adobe AIR SDK v4, you needed to declare several permissions to allow your Adobe AIR app for Android to access device information via the Adjust SDK for Android.

```xml
<android>
  <manifestAdditions>
    <![CDATA[
      <manifest android:installLocation="auto">
        <uses-permission android:name="android.permission.INTERNET"/>
        <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
        <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
        <uses-permission android:name="com.google.android.finsky.permission.BIND_GET_INSTALL_REFERRER_SERVICE" />
      </manifest>
    ]]>
  </manifestAdditions>
</android>
```

In Adobe AIR SDK v5, you can delete some or all from your XML configuration file, depending on your setup.

- `android.permission.INTERNET` is bundled in the Adjust SDK for Android.
- `android.permission.ACCESS_WIFI_STATE` is no longer required.
- `android.permission.ACCESS_NETWORK_STATE` is optional. This allows the SDK to access information about the network a device is connected to, and send this information as part of the callbacks parameters.
- `com.google.android.gms.permission.AD_ID` is bundled in the Adjust SDK for Android. You can remove it with the following snippet:

```xml
<android>
  <manifestAdditions>
    <![CDATA[
      <manifest android:installLocation="auto">
        <uses-permission android:name="com.google.android.gms.permission.AD_ID" tools:node="remove"/>
      </manifest>
    ]]>
  </manifestAdditions>
</android>
```

Learn more about [Adjust's COPPA compliance](https://help.adjust.com/en/article/coppa-compliance).

## Changes and removals

Below is the complete list of changed, renamed, and removed APIs in Adobe AIR SDK v5.

Each section includes a reference to the previous and current API implementations, as well as a minimal code snippet that illustrates how to use the latest version.

## Changed APIs

The following APIs have changed in Adobe AIR SDK v5.

### Disable and enable the SDK

The `setEnabled` method has been renamed. Adobe AIR SDK v5 introduces two separate methods, for clarity:

- Call `Adjust.disable` to disable the SDK.
- Call `Adjust.enable` to enable the SDK.

```actionscript
Adjust.disable(); // disable SDK
Adjust.enable(); // enable SDK
```

### Offline mode

The `setOfflineMode` method has been renamed. Adobe AIR SDK v5 introduces two separate methods, for clarity:

- Call `Adjust.switchToOfflineMode` to set the SDK to offline mode.
- Call `Adjust.switchBackToOnlineMode` to set the SDK back to online mode.

### Send from background

The `setSendInBackground` method has been renamed to `enableSendingInBackground`.

To enable the Adobe AIR SDK v5 to send information to Adjust while your app is running in the background, call the `enableSendingInBackground` method on your `AjustConfig` instance. This feature is disabled by default.

```actionscript
adjustConfig.enableSendingInBackground();
```

### Attribution callback

In Adobe AIR SDK v5, the `setAttributionCallbackDelegate` method has been renamed to `setAttributionCallback`.

The properties of the `attribution` parameter have also changed:

- The `var adid:String` is no longer part of the attribution.
- The `getAdGroup()` getter method has been renamed to `getAdgroup()`.

The following properties have been added to the `attribution` parameter:

- `var costType:String`
- `var costAmount:Number`
- `var costCurrency:String`
- `var fbInstallReferrer:String`

Below is a sample snippet that implements these changes:

```actionscript
adjustConfig.setAttributionCallback(function (attribution:AdjustAttribution):void {
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

### Event deduplication

In Adobe AIR SDK v5, event deduplication is decoupled from the event `transactionId`. To prevent measuring duplicated events, use the `deduplicationId` ID field.

```actionscript
adjustEvent.setDeduplicationId("deduplicationId");
```

### Push tokens

In Adobe AIR SDK v5, the `setDeviceToken` method has been renamed to `setPushToken`.

```actionscript
Adjust.setPushToken("push-token");
```

### Session callback parameters

In Adobe AIR SDK v5, the session callback parameters have been renamed to global callback parameters together with corresponding methods.

```actionscript
Adjust.addGlobalCallbackParameter("user_id", "855");
Adjust.removeGlobalCallbackParameter("user_id");
Adjust.removeGlobalCallbackParameters();
```

### Session partner parameters

In Adobe AIR SDK v5, the session partner parameters have been renamed to global partner parameters together with corresponding methods.

```actionscript
Adjust.addGlobalPartnerParameter("user_id", "855");
Adjust.removeGlobalPartnerParameter("user_id");
Adjust.removeGlobalPartnerParameters();
```

## Session and event callbacks

### Session success callback

In Adobe AIR SDK v5, the `setSessionTrackingSucceededDelegate` method has been renamed to `setSessionSuccessCallback`.

The `getTimeStamp()` method has been renamed to `getTimestamp()`.

```actionscript
adjustConfig.setSessionSuccessCallback(function (sessionSuccess:AdjustSessionSuccess):void {
    // All session success properties.
    trace("Session tracking succeeded");
    trace("Message = " + sessionSuccess.getMessage());
    trace("Timestamp = " + sessionSuccess.getTimestamp());
    trace("Adid = " + sessionSuccess.getAdid());
    trace("Json Response = " + sessionSuccess.getJsonResponse());
});
```

### Session failure callback

In Adobe AIR SDK v5, the `setSessionTrackingFailedDelegate` method has been renamed to `setSessionFailureCallback`.

The `getTimeStamp()` method has been renamed to `getTimestamp()`.

```actionscript
adjustConfig.setSessionFailureCallback(function (sessionFailure:AdjustSessionFailure):void {
    // All session failure properties.
    trace("Session tracking failed");
    trace("Message = " + sessionFailure.getMessage());
    trace("Timestamp = " + sessionFailure.getTimestamp());
    trace("Adid = " + sessionFailure.getAdid());
    trace("Will Retry = " + sessionFailure.getWillRetry().toString());
    trace("Json Response = " + sessionFailure.getJsonResponse());
});
```

### Event success callback

In Adobe AIR SDK v5, the `setEventTrackingSucceededDelegate` method has been renamed to `setEventSuccessCallback`.

The `getTimeStamp()` method has been renamed to `getTimestamp()`.

```actionscript
adjustConfig.setEventSuccessCallback(function (eventSuccess:AdjustEventSuccess):void {
    // All event success properties.
    trace("Event tracking succeeded");
    trace("Message = " + eventSuccess.getMessage());
    trace("Timestamp = " + eventSuccess.getTimestamp());
    trace("Adid = " + eventSuccess.getAdid());
    trace("Event Token = " + eventSuccess.getEventToken());
    trace("Callback Id = " + eventSuccess.getCallbackId());
    trace("Json Response = " + eventSuccess.getJsonResponse());
});
```

### Event failure callback

In Adobe AIR SDK v5, the `setEventTrackingFailedDelegate` method has been renamed to `setEventFailureCallback`.

The `getTimeStamp()` method has been renamed to `getTimestamp()`.

```actionscript
adjustConfig.setEventFailureCallback(function (eventFailure:AdjustEventFailure):void {
    // All event failure properties.
    trace("Event tracking failed");
    trace("Message = " + eventFailure.getMessage());
    trace("Timestamp = " + eventFailure.getTimestamp());
    trace("Adid = " + eventFailure.getAdid());
    trace("Event Token = " + eventFailure.getEventToken());
    trace("Callback Id = " + eventFailure.getCallbackId());
    trace("Will Retry = " + eventFailure.getWillRetry().toString());
    trace("Json Response = " + eventFailure.getJsonResponse());
});
```

## Deep linking

### Reattribution via deep links

In Adobe AIR SDK v5, the `appWillOpenUrl` method has been renamed to `processDeeplink`.

To process a direct deep link, create a new `AdjustDeeplink` instance with the deep link URL, and pass it to the `Adjust.processDeeplink` method.

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

### Disable opening deferred deep links

In Adobe AIR SDK v5, the `setShouldLaunchDeeplink` method has been renamed to `disableDeferredDeeplinkOpening`. Opening deferred deep links is enabled by default.

To disable opening deferred deep links, call the renamed method:

```actionscript
adjustConfig.disableDeferredDeeplinkOpening();
```

### Deferred deep link callback

In Adobe AIR SDK v5, the `setDeferredDeeplinkDelegate` method has been renamed to `setDeferredDeeplinkCallback`.

To set a deferred deep link callback, call the `setDeferredDeeplinkCallback` method on your `AdjustConfig` instance:

```actionscript
adjustConfig.setDeferredDeeplinkCallback(function (deeplink:String):void {
    trace("Received deferred deep link");
    trace("Deep link = " + deeplink);
});
```

## iOS only API

### SKAdNetwork handling

In Adobe AIR SDK v5, the `deactivateSKAdNetworkHandling` method has been renamed to `disableSkanAttribution`. The `SKAdNetwork` API is enabled by default.

To disable the `SKAdNetwork` communication, call the `disableSkanAttribution` method on your `AdjustConfig` instance.

```actionscript
adjustConfig.disableSkanAttribution();
```

### App Tracking Transparency authorization wrapper 

In Adobe AIR SDK v5, the `requestTrackingAuthorizationWithCompletionHandler` method has been renamed to `requestAppTrackingAuthorization` for clarity.

The renamed method is invoked like so:

```actionscript
Adjust.requestAppTrackingAuthorization(function (status:String):void {
    trace("Status = " + status);
});
```

## Get device information

In Adobe AIR SDK v4, all device information getter methods run synchronously.

In SDK v5, the following methods have been changed to run asynchronously.

### Adjust ID

```actionscript
Adjust.getAdid(function (adid:String):void {
    trace("Adjust ID = " + adid);
});
```

### Amazon Advertising ID

```actionscript
Adjust.getAmazonAdId(function (amazonAdId:String):void {
    trace("Amazon Advertising ID = " + amazonAdId);
});
```

### IDFA

```actionscript
Adjust.getIdfa(function (idfa:String):void {
    trace("IDFA = " + idfa);
});
```

### Get attribution information

```actionscript
Adjust.getAttribution(function (attribution:AdjustAttribution):void {
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

## Removed APIs

The following APIs have been removed from Adobe AIR SDK v5.

- The `setDelayStart` method has been removed.
- The `sendFirstPackages` method has been removed.
- The `setEventBufferingEnabled` method has been removed.
- The `setReadMobileEquipmentIdentity` method has been removed. (non-Google Play Store Android apps only)

### Disable third party sharing globally

The `disableThirdPartySharing` method has been removed.

To disable all third-party sharing in Adobe AIR SDK v5, use the trackThirdPartySharing method.

```actionscript
var adjustThirdPartySharing:AdjustThirdPartySharing = new AdjustThirdPartySharing("false");
Adjust.trackThirdPartySharing(adjustThirdPartySharing);
```

### Set an app secret

The `setAppSecret` method has been removed.

The SDK signature library is bundled in Adjust SDKs v5 and enabled by default. To configure the anti-spoofing solution in the Adjust Dashboard, follow the integration guide for your platform.

### Huawei referrer API

This feature has been removed. If your Adobe AIR app uses the Huawei referrer API, contact your Adjust representative or email support@adjust.com before you upgrade.
