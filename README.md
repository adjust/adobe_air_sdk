## Summary

This is the Adobe AIR SDK of Adjust™. You can read more about Adjust™ at [adjust.com](https://adjust.com).

## Table of contents

* [Example app](#example-app)
* [Integration guide](#integration-guide)
   * [Get the SDK](#sdk-get)
   * [Add the SDK to your project](#sdk-add)
   * [Integrate the SDK into your app](#sdk-integrate)
   * [Adjust logging](#sdk-logging)
   * [Android permissions](#android-permissions)
   * [Google Play Services](#google-play-services)
   * [Install referrer](#install-referrer)
   * [SDK signature](#sdk-signature)
* [Additional features](#additional-features)
   * [Event tracking](#event-tracking)
      * [Event revenue](#event-revenue)
      * [Event deduplication](#event-deduplication)
      * [Event callback identifier](#event-callback-id)
      * [Event callback parameters](#event-callback-params)
      * [Event partner parameters](#event-partner-params)
   * [User attribution](#user-attribution)
      * [Attribution callback](#attribution-callback)
      * [Get user attribution](#attribution-getter)
   * [Preinstalled apps](#preinstalled-apps)
      * [Deafult link token](#preinstall-default-link)
   * [Global parameters](#global-params)
      * [Global callback parameters](#global-callback-params)
      * [Global partner parameters](#global-partner-params)
   * [Privacy features](#privacy-features)
      * [GDPR right to be forgotten](#gdpr-forget-me)
      * [Third party sharing](#third-party-sharing)
      * [Disable third-party sharing for specific users](#disable-third-party-sharing)
      * [Enable or re-enable third-party sharing for specific users](#enable-third-party-sharing)
      * [Send granular options](#send-granular-options)
      * [Manage Facebook Limited Data Use](#facebook-limited-data-use)
      * [Provide consent data to Google (Digital Markets Act compliance)](#digital-markets-act)
      * [Update partner sharing settings](#partner-sharing-settings)
      * [Consent measurement for specific users](#measurement-consent)
      * [COPPA compliance](#coppa-compliance)
      * [Play Store kids apps](#play-store-kids-apps)
      * [URL strategies](#url-strategies)
   * [Deep linking](#deeplinking)
      * [Standard deep linking scenario](#deeplinking-standard)
      * [Deferred deep linking scenario](#deeplinking-deferred)
      * [Deep linking setup for Android](#deeplinking-android)
      * [Deep linking setup for iOS](#deeplinking-ios)
      * [Reattribution via deep links](#deeplinking-reattribution)
      * [Resolve Adjust short links](#short-links-resolution)
      * [Get last processed deep link](#last-deeplink-getter)
   * [App Tracking Transparency](#app-tracking-transparency)
      * [ATT authorization wrapper](#att-wrapper)
      * [Get current authorization status](#att-status-getter)
      * [ATT prompt waiting interval](#att-waiting-interval)
   * [SKAdNetwork and conversion values](#skan-framework)
      * [Disable SKAdNetwork communication](#skan-disable)
      * [Listen for changes to conversion values](#skan-update-callback)
      * [Set up direct install postbacks](#skan-postbacks)
   * [Ad revenue tracking](#adrevenue-tracking)
      * [Ad revenue amount](#adrevenue-amount)
      * [Ad revenue network](#adrevenue-network)
      * [Ad revenue unit](#adrevenue-unit)
      * [Ad revenue placement](#adrevenue-placement)
      * [Ad impressions count](#adrevenue-impressions)
      * [Ad revenue callback parameters](#adrevenue-callback-params)
      * [Ad revenue partner parameters](#adrevenue-partner-params)
   * [Purchase verification](#purchase-verification)
      * [Verify purchase and record event](#verify-and-track)
      * [Verify purchase only](#verify-only)
   * [Send subscription information](#subscription-sending)
      * [Subscription purchase date](#subscription-purchase-date)
      * [Subscription region](#subscription-region)
      * [Subscription callback parameters](#subscription-callback-params)
      * [Subscription partner parameters](#subscription-partner-params)
   * [Device IDs](#device-ids)
      * [iOS advertising identifier](#idfa)
      * [iOS identifier for vendors](#idfv)
      * [Google Play Services advertising identifier](#gps-adid)
      * [Amazon advertising identifier](#fire-adid)
      * [Adjust device identifier](#adid)
   * [Session and event callbacks](#session-event-callbacks)
   * [Disable tracking](#disable-tracking)
   * [Offline mode](#offline-mode)
   * [Background tracking](#background-tracking)
   * [External device ID](#external-device-id)
   * [Push token](#push-token)
* [License](#license)

## <a id="example-app"></a>Example app

An example app is included in the [`example` directory](./example). You can use the example app to see how the Adjust SDK can be integrated.

## <a id="integration-guide"></a>Integration guide

The Adjust Adobe AIR SDK enables you to record attribution, events, and more in your Adobe AIR app. Follow the steps in this guide to set up your app to work with the Adjust SDK.

> Before you begin: The Adjust SDK supports iOS 12 or later and Android API level 21 (Lollipop) or later.

### <a id="sdk-get"></a>Get the SDK

Download the latest version from our [releases page](https://github.com/adjust/adjust_air_sdk/releases).

### <a id="sdk-add"></a>Add the SDK to your project

Add the downloaded Adjust SDK ANE file to your app. After this, add the Adjust SDK extension to your app's descriptor file:

```xml
<extensions>
    <!-- ... -->
    <extensionID>com.adjust.sdk</extensionID>
    <!-- ... -->
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

### <a id="sdk-signature"></a>SDK signature

If you want to use the SDK signature library to secure communications between the Adjust SDK and Adjust's servers, follow the instructions in the [SDK signature guide on the Adjust Help Center](https://help.adjust.com/en/article/sdk-signature).

## <a id="additional-features"></a>Additional features

You can take advantage of the following features once the Adjust SDK is integrated into your project.

### <a id="event-tracking"></a>Event tracking

You can tell Adjust about every event you want to track. Let's say that event token is `abc123`. You can add the following line in your button’s click handler method to track the click:

```actionscript
var adjustEvent:AdjustEvent = new AdjustEvent("abc123");
Adjust.trackEvent(adjustEvent);
```

### <a id="event-revenue-tracking"></a>Event revenue

If your users can generate revenue by tapping on advertisements or making in-app purchases, then you can track those revenues with events. Let's say a tap is worth €1.50. You could track the revenue event like this:

```actionscript
var adjustEvent:AdjustEvent = new AdjustEvent("abc123");
adjustEvent.setRevenue(1.50, "EUR");
Adjust.trackEvent(adjustEvent);
```

### <a id="event-deduplication"></a>Event deduplication

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

### <a id="event-callback-id"></a>Event callback identifier

You can also add custom string identifier to each event you want to track. This identifier will later be reported in event success and/or event failure callbacks to enable you to keep track on which event was successfully tracked or not. You can set this identifier by calling the `setCallbackId` method on your `AdjustEvent` instance:

```actionscript
var adjustEvent:AdjustEvent = new AdjustEvent("abc123");
adjustEvent.setCallbackId("Your-Custom-Id");
Adjust.trackEvent(adjustEvent);
```

### <a id="event-callback-params"></a>Event callback parameters

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

### <a id="event-partner-params"></a>Event partner parameters

You can also add parameters for integrations that have been activated in your Adjust dashboard that can be transmitted to network partners.

This works similarly to the callback parameters mentioned above, but can be added by calling the `addPartnerParameter` method on your `AdjustEvent` instance.

```actionscript
var adjustEvent:AdjustEvent = new AdjustEvent("abc123");
adjustEvent.addPartnerParameter("key", "value");
adjustEvent.addPartnerParameter("foo", "bar");
Adjust.trackEvent(adjustEvent);
```

### <a id="user-attribution"></a>User attribution

Each recorded install is getting certain attribution assigned and also, during the app lifetime, the attribution can change.

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

### <a id="attribution-getter"></a>Get user attribution

If you want to access information about a user's current attribution whenever you need it, you can make a call to the `getAttribution` method of the `Adjust` class:

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

### <a id="preinstalled-apps"></a>Preinstalled apps

You can use the Adjust SDK to record activity from apps that came preinstalled on a user’s device. This enables you to attribute these users to a custom defined campaign link instead to an organic one.

### <a id="preinstall-default-link"></a>Default link token

Configuring a default link token enables you to attribute all preinstalls to a predefined Adjust link. Adjust records all information against this token until the attribution source changes. To set this up, first you need to [create a new campaign link in Campaign Lab](https://help.adjust.com/en/article/links). After doing this, you need to invoke `setDefaultTracker` method of your `AdjustConfig` instance and pass a token you got generated for your campign link:

```actionscript
var adjustConfig:AdjustConfig = new AdjustConfig("{YourAppToken}", AdjustEnvironment.SANDBOX);
adjustConfig.setDefaultTracker("{CampaignLinkToken}");
Adjust.initSdk(adjustConfig);
```

In case this approach is not applicable to your preinstall use case, please reach out to support@adjust.com to explore other ways of how the attribution for preinstalled apps can be handled.

### <a id="global-params"></a>Global parameters

Some parameters are saved to be sent in every session, event, ad revenue and subscription request of the Adjust SDK. Once you have added any of these parameters, you don't need to add them every time, since they will be saved locally. If you add the same parameter twice, there will be no effect. These global parameters can be set before the Adjust SDK is launched to make sure they are sent even on install.

### <a id="global-callback-params"></a>Global callback parameters

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

### <a id="global-partner-params"></a>Global partner parameters

In the same way that there are [global callback parameters](#session-callback-params) that are sent for every event or session of the Adjust SDK, there are also global partner parameters.

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

### <a id="privacy-features"></a>Privacy features

The Adjust SDK contains features that you can use to handle user privacy in your app.

### <a id="gdpr-forget-me"></a>GDPR right to be forgotten

In accordance with article 17 of the EU's General Data Protection Regulation (GDPR), you can notify Adjust when a user has exercised their right to be forgotten. Calling the following method will instruct the Adjust SDK to communicate the user's choice to be forgotten to the Adjust backend:

```actionscript
Adjust.gdprForgetMe();
```

Upon receiving this information, Adjust will erase the user's data and the Adjust SDK will stop tracking the user. No requests from this device will be sent to Adjust in the future.

### <a id="third-party-sharing"></a>Third-party sharing for specific users

You can notify Adjust when a user disables, enables, and re-enables data sharing with third-party partners.

### <a id="disable-third-party-sharing"></a>Disable third-party sharing for specific users

Call the following method to instruct the Adjust SDK to communicate the user's choice to disable data sharing to the Adjust backend:

```actionscript
var adjustThirdPartySharing:AdjustThirdPartySharing = new AdjustThirdPartySharing("false");
Adjust.trackThirdPartySharing(adjustThirdPartySharing);
```

Upon receiving this information, Adjust will block the sharing of that specific user's data to partners and the Adjust SDK will continue to work as usual.

### <a id="enable-third-party-sharing">Enable or re-enable third-party sharing for specific users</a>

Call the following method to instruct the Adjust SDK to communicate the user's choice to share data or change data sharing, to the Adjust backend:

```actionscript
var adjustThirdPartySharing:AdjustThirdPartySharing = new AdjustThirdPartySharing("true");
Adjust.trackThirdPartySharing(adjustThirdPartySharing);
```

Upon receiving this information, Adjust changes sharing the specific user's data to partners. The Adjust SDK will continue to work as expected.

### <a id="send-granular-options">Send granular options</a>

You can attach granular information when a user updates their third-party sharing preferences. Use this information to communicate more detail about a user’s decision. To do this, call the `addGranularOption` method like this:

```actionscript
var adjustThirdPartySharing:AdjustThirdPartySharing = new AdjustThirdPartySharing(null);
adjustThirdPartySharing.addGranularOption("partnerName", "key", "value");
Adjust.trackThirdPartySharing(adjustThirdPartySharing);
```

The following partners are available:

| Partner name              | String value                  |
|---------------------------|-------------------------------|
| AppleAds                  | apple_ads                     |
| Facebook                  | facebook                      |
| GoogleAds                 | adwords                       |
| GoogleMarketingPlatform   | google_marketing_platform     |
| Snapchat                  | snapchat                      |
| Tencent                   | tencent                       |
| TikTokSan                 | tiktok_san                    |
| X (formerly Twitter)      | twitter                       |
| YahooGemini               | yahoo_gemini                  |
| YahooJapanSearch          | yahoo_japan_search            |

### <a id="facebook-limited-data-use">Manage Facebook Limited Data Use</a>

Facebook provides a feature called Limited Data Use (LDU) to comply with the California Consumer Privacy Act (CCPA). This feature enables you to notify Facebook when a California-based user is opted out of the sale of data. You can also use it if you want to opt all users out by default.

You can update the Facebook LDU status by passing arguments to the `addGranularOption` method.

| Parameter                        | Description                                                                 |
|----------------------------------|-----------------------------------------------------------------------------|
| `partner_name`                   | Use `facebook` to toggle LDU.                                              |
| `data_processing_options_country`| The country in which the user is located.                                  |
|                                  | - `0`: Request that Facebook use geolocation.                              |
|                                  | - `1`: United States of America.                                           |
| `data_processing_options_state`  | Notifies Facebook in which state the user is located.                      |
|                                  | - `0`: Request that Facebook use geolocation.                              |
|                                  | - `1000`: California.                                                      |
|                                  | - `1001`: Colorado.                                                        |
|                                  | - `1002`: Connecticut.                                                     |

> Note: If you call this method with a 0 value for **either** `data_processing_options_country` or `data_processing_options_state`, the Adjust SDK passes **both** fields back as 0.

```actionscript
var adjustThirdPartySharing:AdjustThirdPartySharing = new AdjustThirdPartySharing(null);
adjustThirdPartySharing.addGranularOption("facebook", "data_processing_options_country", "1");
adjustThirdPartySharing.addGranularOption("facebook", "data_processing_options_state", "1000");
Adjust.trackThirdPartySharing(adjustThirdPartySharing);
```

### <a id="digital-markets-act">Provide consent data to Google (Digital Markets Act compliance)</a>

> Important: Passing these options is required if you use Google Ads or Google Marketing Platform and have users located in the European Economic Area (EEA).

To comply with the EU’s Digital Markets Act (DMA), Google Ads and the Google Marketing Platform require explicit consent to receive Adjust’s attribution requests to their APIs. To communicate this consent, you need to add the following granular options to your third party sharing instance for the partner `google_dma`.

| Key                 | Value               | Description                                                                                                      |
|---------------------|---------------------|------------------------------------------------------------------------------------------------------------------|
| `eea`               | `1` (positive) \| `0` (negative) | Informs Adjust whether users installing the app are within the European Economic Area. Includes EU member states, Switzerland, Norway, Iceland, and Slovenia. |
| `ad_personalization`| `1` (positive) \| `0` (negative) | Informs Adjust whether users consented with being served personalized ads via Google Ads and/or Google Marketing Platform. This parameter also informs the `npa` parameter reserved for Google Marketing Platform. |
| `ad_user_data`      | `1` (positive) \| `0` (negative) | Informs Adjust whether users consented with their advertiser ID being leveraged for attribution purposes.         |

```actionscript
var adjustThirdPartySharing:AdjustThirdPartySharing = new AdjustThirdPartySharing(null);
adjustThirdPartySharing.addGranularOption("google_dma", "eea", "1");
adjustThirdPartySharing.addGranularOption("google_dma", "ad_personalization", "1");
adjustThirdPartySharing.addGranularOption("google_dma", "ad_user_data", "1");
Adjust.trackThirdPartySharing(adjustThirdPartySharing);
```

### <a id="partner-sharing-settings">Update partner sharing settings</a>

By default, Adjust shares all metrics with any partners you’ve configured in your app settings. You can use the Adjust SDK to update your third party sharing settings on a per-partner basis. To do this, call the `addPartnerSharingSetting` method with the following arguments:

| Argument     | Data type | Description                                                |
|--------------|-----------|------------------------------------------------------------|
| `partnerName`| String    | The name of the partner. [Download the full list of available partners](https://assets.ctfassets.net/5s247im0esyq/5WvsJ7J7fGFUlfsFeGdalj/643651619adc3256acac7885ec60624d/modules.csv). |
| `key`        | String    | The metric to share with the partner.                      |
| `value`      | Boolean   | The user’s decision.                                       |

You can use the `key` to specify which metrics you want to disable or re-enable. If you want to enable/disable sharing all metrics, you can use the `all` key. The full list of available metrics is available below:

- `ad_revenue`
- `all`
- `attribution`
- `update`
- `att_update`
- `cost_update`
- `event`
- `install`
- `reattribution`
- `reattribution_reinstall`
- `reinstall`
- `rejected_install`
- `rejected_reattribution`
- `sdk_click`
- `sdk_info`
- `session`
- `subscription`
- `uninstall`

When you set a `false` value against a metric for a partner, Adjust stops sharing the metric with the partner.

> Tip: If you only want to share a few metrics with a partner, you can pass the `all` key with a `false` value to disable all sharing and then pass individual metrics with a `true` value to limit what you share.

Examples:

If you want to stop sharing all metrics with a specific partner, pass the `all` key with a `false` value.

```actionscript
var adjustThirdPartySharing:AdjustThirdPartySharing = new AdjustThirdPartySharing(null);
adjustThirdPartySharing.addPartnerSharingSetting("PartnerA", "all", false);
Adjust.trackThirdPartySharing(adjustThirdPartySharing);
```

To re-enable sharing, pass the `all` key with a `true` value.

```actionscript
var adjustThirdPartySharing:AdjustThirdPartySharing = new AdjustThirdPartySharing(null);
adjustThirdPartySharing.addPartnerSharingSetting("PartnerA", "all", true);
Adjust.trackThirdPartySharing(adjustThirdPartySharing);
```

You can stop or start sharing specific metrics by calling the `addPartnerSharingSetting` method multiple times with different keys. For example, if you only want to share event information with a partner, you can pass:

- `all` with a `false` value to disable sharing all information
- `event` with a `true` value to enable event sharing

> Note: Specific keys always take priority over `all`. If you pass `all` with other keys, the individual key values override the `all` setting.

```actionscript
var adjustThirdPartySharing:AdjustThirdPartySharing = new AdjustThirdPartySharing(null);
adjustThirdPartySharing.addPartnerSharingSetting("PartnerA", "all", false);
adjustThirdPartySharing.addPartnerSharingSetting("PartnerA", "event", true);
Adjust.trackThirdPartySharing(adjustThirdPartySharing);
```

### <a id="measurement-consent"></a>Consent measurement for specific users

If you’re using [Data Privacy settings](https://help.adjust.com/en/article/manage-data-collection-and-retention) in your Adjust dashboard, you need to set up the Adjust SDK to work with them. This includes settings such as consent expiry period and user data retention period.

To toggle this feature, call the `trackMeasurementConsent` method with the following argument:

- `measurementConsent` (`Boolean`): Whether consent measurement is enabled (`true`) or not (`false`).

When enabled, the SDK communicates the data privacy settings to Adjust’s servers. Adjust’s servers then applies your data privacy rules to the user. The Adjust SDK continues to work as expected.

```actionscript
Adjust.trackMeasurementConsent(true);
```

### <a id="coppa-compliance"></a>COPPA compliance

f you need your app to be compliant with the Children’s Online Privacy Protection Act (COPPA), call the `enableCoppaCompliance` method on your `AdjustConfig` instance before initializing the SDK. This performs the following actions:

1. Disables third-party sharing **before** the user launches their first `session`.
2. Prevents the SDK from reading device and advertising IDs (for example: `gps_adid`, `idfa`, and `android_id`).

```actionscript
var adjustConfig:AdjustConfig = new AdjustConfig("{YourAppToken}", AdjustEnvironment.SANDBOX);

adjustConfig.enableCoppaCompliance();

Adjust.initSdk(adjustConfig);
```

### <a id="play-store-kids-apps"></a>Play Store kids apps

If your app targets users under the age of 13, and the install region **isn’t** the USA, you need to mark it as a Kids App. This prevents the SDK from reading device and advertising IDs (for example: `idfa`, `gps_adid` and `android_id`).

To mark your app as a Play Store Kids App, call the `enablePlayStoreKidsCompliance` method on your `AdjustConfig` instance before initializing the SDK.

```actionscript
var adjustConfig:AdjustConfig = new AdjustConfig("{YourAppToken}", AdjustEnvironment.SANDBOX);

adjustConfig.enablePlayStoreKidsCompliance();

Adjust.initSdk(adjustConfig);
```

### <a id="url-strategies"></a>URL strategies

The URL strategy feature allows you to set either:

- The country in which Adjust stores your data (data residency).
- The endpoint to which the Adjust SDK sends traffic (URL strategy).

This is useful if you’re operating in a country with strict privacy requirements. When you set your URL strategy, Adjust stores data in the selected data residency region or sends traffic to the chosen domain.

To set your country of data residency, call the `setUrlStrategy` method on your `AdjustConfig` instance with the following parameters:

- `urlStrategyDomains` (`List`): The country or countries of data residence, or the endpoints to which you want to send SDK traffic.
- `shouldUseSubdomains` (`Boolean`): Whether the source should prefix a subdomain.
- `isDataResidency` (`Boolean`): Whether the domain should be used for data residency.

| URL strategy                | Main and fallback domain                           | Use sub domains | Is Data Residency |
|-----------------------------|----------------------------------------------------|-----------------|-------------------|
| EU data residency           | `["eu.adjust.com"]`                                  | `true`          | `true`            |
| Turkish data residency      | `"[tr.adjust.com"]`                                  | `true`          | `true`            |
| US data residency           | `"[us.adjust.com"]`                                  | `true`          | `true`            |
| China global URL strategy   | `["adjust.world"`, `"adjust.com"]`                   | `true`          | `false`           |
| China only URL strategy     | `["adjust.cn"]`                                      | `true`          | `false`           |
| India URL strategy          | `["adjust.net.in"`, `"adjust.com"]`                  | `true`          | `false`           |

Examples:

```actionscript
// India URL strategy
adjustConfig.setUrlStrategy(["adjust.net.in", "adjust.com"], true, false);
```

```actionscript
// China global URL strategy
adjustConfig.setUrlStrategy(["adjust.world", "adjust.com"], true, false);
```

```actionscript
// China only URL strategy
adjustConfig.setUrlStrategy(["adjust.cn"], true, false);
```

```actionscript
// EU data residency
adjustConfig.setUrlStrategy(["eu.adjust.com"], true, true);
```

```actionscript
// US data residency
adjustConfig.setUrlStrategy(["us.adjust.com"], true, true);
```

```actionscript
// Turkey data residency
adjustConfig.setUrlStrategy(["tr.adjust.com"], true, true);
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

Once you have received deep link content information in your app, add a call to the `processDeeplink` method. By making this call, the Adjust SDK will try to find if there is any new attribution information inside of the deep link. If there is any, it will be sent to the Adjust backend. If your user should be reattributed due to a click on the adjust tracker URL with deep link content, you will see the [attribution callback](#attribution-callback) in your app being triggered with new attribution info for this user.

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

### <a id="short-links-resolution"></a>Resolve Adjust short links

To resolve an Adjust shortened deep link, instantiate an `AdjustDeeplink` object with your shortened deep link and pass it to the `processAndResolveDeeplink` method with a callback function. The callback function receives the resolved deep link as a `String`.

```actionscript
var adjustDeeplink:AdjustDeeplink = new AdjustDeeplink("shortened-deeplink");
Adjust.processAndResolveDeeplink(adjustDeeplink, function (resolvedLink:String):void {
    trace("Resolved link: " + resolvedLink);
});
```

> Note: If the link passed to the `processAndResolveDeeplink` method was shortened, the callback function receives the extended original link. Otherwise, the callback function receives the link you passed.

### <a id="last-deeplink-getter"></a>Get last processed deep link

You can get the last deep link URL processed by the `processDeeplink` or `processAndResolveDeepLink` method by calling the `getLastDeeplink` method. This method returns the last processed deep link as a string.

```actionscript
Adjust.getLastDeeplink(function (lastDeeplink:String): void {
    trace("Last deep link = " + lastDeeplink);
});
```

### <a id="app-tracking-transparency"></a>App Tracking Transparency

> Note: This feature exists only in iOS platform.

If you want to record the device’s ID for Advertisers (IDFA), you must display a prompt to get your user’s authorization. To do this, you need to include Apple’s App Tracking Transparency (ATT) framework in your app. The Adjust SDK stores the user’s authorization status and sends it to Adjust’s servers with each request.

Below, you can find the list of possible ATT status values:

| Status                                    | Code | Description                                                          |
|-------------------------------------------|------|----------------------------------------------------------------------|
| `ATTrackingManagerAuthorizationStatusNotDetermined` | `0`  | The user hasn’t responded to the access prompt yet                   |
| `ATTrackingManagerAuthorizationStatusRestricted`   | `1`  | Access to app-related data is blocked at the device level            |
| `ATTrackingManagerAuthorizationStatusDenied`       | `2`  | The user has denied access to app-related data for device measurement |
| `ATTrackingManagerAuthorizationStatusAuthorized`   | `3`  | The user has approved access to app-related data for device measurement |

> Note: You might receive a status code of -1 if the SDK is unable to retrieve the ATT (App Tracking Transparency) status.

### <a id="att-wrapper"></a>ATT authorization wrapper

**Note**: This feature exists only in iOS platform.

The Adjust SDK contains a wrapper around [Apple’s requestTrackingAuthorizationWithCompletionHandler: method](https://developer.apple.com/documentation/apptrackingtransparency/attrackingmanager/3547037-requesttrackingauthorizationwith). You can use this wrapper if you don’t want to use the ATT prompt.

The callback method triggers when your user responds to the consent dialog. This method sends the user’s consent status code to Adjust’s servers. You can define responses to each status code within the callback function.

You must specify text content for the ATT. To do this, add your text to the `NSUserTrackingUsageDescription` key in your `Info.plist` file. This can be done by adding this entry to your app's descriptor file:

```xml
<iPhone>
  <InfoAdditions>
    <![CDATA[
    <key>NSUserTrackingUsageDescription</key>
    <string>Your custom message explaning why is access to IDFA necessary.</string>
    ]]>
  </InfoAdditions>
</iPhone>
```

You can trigger ATT prompt via Adjust SDK wrapper method like this:

```actionscript
Adjust.requestAppTrackingAuthorization(function (status:int): void {
    switch (status) {
        case 0:
            // ATTrackingManagerAuthorizationStatusNotDetermined case
            break;
        case 1:
            // ATTrackingManagerAuthorizationStatusRestricted case
            break;
        case 2:
            // ATTrackingManagerAuthorizationStatusDenied case
            break;
        case 3:
            // ATTrackingManagerAuthorizationStatusAuthorized case
            break;
        case -1:
            // error case
            break;
    }
});
```

### <a id="att-status-getter"></a>Get current authorization status

You can retrieve a user’s current authorization status at any time. Call the `getAppTrackingAuthorizationStatus` method to return the authorization status code as an `int`.

```actionscript
Adjust.getAppTrackingAuthorizationStatus(function (status:int): void {
    trace("Authorization status = " + status.toString());
});
```

### <a id="att-waiting-interval"></a>ATT prompt waiting interval

If your app includes an onboarding process or a tutorial, you may want to delay sending your user’s ATT consent status until after the user has completed this process. To do this, you can call the `setAttConsentWaitingInterval` method of your `AdjustConfig` instance to delay the sending of data for up to **360 seconds** to give the user time to complete the initial onboarding. After the timeout ends or the user sets their consent status, the SDK sends all information it has recorded during the delay to Adjust’s servers along with the user’s consent status.

```actionscript
var adjustConfig:AdjustConfig = new AdjustConfig("{YourAppToken}", AdjustEnvironment.SANDBOX);
adjustConfig.setAttConsentWaitingInterval(30);
Adjust.initSdk(adjustConfig);
```

* [SKAdNetwork and conversion values](#skan-framework)
      * [Disable SKAdNetwork communication](#skan-disable)
      * [Listen for changes to conversion values](#skan-update-callback)
      * [Set up direct install postbacks](#skan-postbacks)

### <a id="skan-framework"></a>SKAdNetwork and conversion values

> Important: This feature is only available on devices running iOS 14 and above.

SKAdNetwork is Apple’s attribution framework for app install and reinstall attribution. The SKAdNetwork workflow goes like this:

1. Apple gathers attribution information and notifies the relevant ad network.
2. The network sends a postback with this information to Adjust.
3. Adjust displays SKAdNetwork data in [Datascape](https://help.adjust.com/en/suite/article/datascape).

### <a id="skan-disable"></a>Disable SKAdNetwork communication

The Adjust SDK communicates with SKAdNetwork by default. The SDK registers for `SKAdNetwork attribution upon initialization.

You can control this behavior by calling `disableSkanAttribution` method of your `AdjustConfig` instance.

```actionscript
var adjustConfig:AdjustConfig = new AdjustConfig("{YourAppToken}", AdjustEnvironment.SANDBOX);
adjustConfig.disableSkanAttribution();
Adjust.initSdk(adjustConfig);
```

### <a id="skan-update-callback"></a>Listen for changes to conversion values

If you use Adjust to manage conversion values, the Adjust’s servers send conversion value updates to the SDK. You can set up a delegate function to listen for these changes assigning a callback method for this on your `AdjustConfig` instance.

```actionscript
var adjustConfig:AdjustConfig = new AdjustConfig("{YourAppToken}", AdjustEnvironment.SANDBOX);
adjustConfig.setSkanUpdatedCallback(function (skanUpdatedData:Dictionary):void {
    trace("SKAN values updated");
    trace("Conversion value = " + skanUpdatedData["conversionValue"].toString());
    trace("Coarse value = " + skanUpdatedData["coarseValue"]);
    trace("Lock window = " + skanUpdatedData["lockWindow"].toString());
    trace("Error = " + skanUpdatedData["error"]);
});
Adjust.initSdk(adjustConfig);
```

The callback function receives a postback from SKAdNetwork with the following properties:

| Arguments      | Description                                                                                                                       |
|----------------|-----------------------------------------------------------------------------------------------------------------------------------|
| `fine_value`   | The conversion value sent by Adjust’s servers                                                                                    |
| `coarse_value` | The coarse conversion value. This value is used if your app doesn’t have sufficient installs to reach the privacy threshold.      |
|                | - `none`                                                                                                                         |
|                | - `low`                                                                                                                          |
|                | - `medium`                                                                                                                       |
|                | - `high`                                                                                                                         |
|                | Apple sends `none` whenever none of the conditions that are set for `low`, `medium`, and `high` were met.                        |
| `lock_window`  | Whether to send the postback before the conversion window ends. `1` indicates the postback will be sent before the window ends.   |
|                | Defaults to `0` in SKAdNetwork 4.0 postbacks and `nil` in older SKAdNetwork versions.                                             |
| `error`        | Contains the error message if an error occurred.                                                                                 |

### <a id="skan-postbacks"></a>Set up direct install postbacks

> Note: Direct install postbacks contain only SKAdNetwork information. Information such as campaign data isn’t included in these postbacks.

You can configure your app to send a copy of winning SKAdNetwork callbacks to Adjust. This enables you to use SKAdNetwork information in your analytics.

To set up direct install postbacks, you need to add the Adjust callback URL to your `Info.plist` file:

```xml
<iPhone>
  <InfoAdditions>
    <![CDATA[
    <key>NSAdvertisingAttributionReportEndpoint</key>
    <string>https://adjust-skadnetwork.com</string>
    ]]>
  </InfoAdditions>
</iPhone>
```

> See also: See Apple’s guide on [Configuring an Advertised App](https://developer.apple.com/documentation/storekit/skadnetwork/configuring_an_advertised_app) for more information.

### <a id="adrevenue-tracking"></a>Ad revenue tracking

You can record ad revenue for [supported network partners](https://help.adjust.com/en/article/ad-revenue) using the Adjust SDK.

> Important: You need to perform some extra setup steps in your Adjust dashboard to measure ad revenue. Contact your Technical Account Manager or support@adjust.com to get started.

To send ad revenue information with the Adjust SDK, you need to instantiate an `AdjustAdRevenue` object. This object contains variables that are sent to Adjust when ad revenue is recorded in your app.

To instantiate an ad revenue object, create a new `AdjustAdRevenue` instance and pass the following parameters:

- source (`String`): The source of the ad revenue. See the table below for available sources.

| Argument                     | Ad revenue Source        |
|------------------------------|--------------------------|
| `"applovin_max_sdk"`         | AppLovin MAX            |
| `"admob_sdk"`                | AdMob                   |
| `"ironsource_sdk"`           | ironSource              |
| `"admost_sdk"`               | AdMost                  |
| `"unity_sdk"`                | Unity                   |
| `"helium_chartboost_sdk"`    | Helium Chartboost       |
| `"adx_sdk"`                  | Ad(X)                   |
| `"tradplus_sdk"`             | TradPlus                |
| `"topon_sdk"`                | TopOn                   |
| `"publisher_sdk"`            | Generic source          |

### <a id="adrevenue-amount"></a>Ad revenue amount

To send the ad revenue amount, call the `setRevenue` method of your `AdjustAdRevenue` instance and pass the following arguments:

- revenue (`Number`): The amount of revenue
- currency (`String`): The 3 character [ISO 4217 code](https://www.iban.com/currency-codes) of your reporting currency

> See also: Check the [guide to recording purchases in different currencies](https://help.adjust.com/en/article/currency-conversion) for more information.

```actionscript
var adjustAdRevenue:AdjustAdRevenue = new AdjustAdRevenue("applovin_max_sdk");
adjustAdRevenue.setRevenue(1.0, "EUR");
Adjust.trackAdRevenue(adjustAdRevenue);
```

### <a id="adrevenue-network"></a>Ad revenue network

To record the network associated with the ad revenue, call `setAdRevenueNetwork` method of your `AdjustAdRevenue` instance with the network name.

```actionscript
var adjustAdRevenue:AdjustAdRevenue = new AdjustAdRevenue("applovin_max_sdk");
adjustAdRevenue.setAdRevenueNetwork("network1");
Adjust.trackAdRevenue(adjustAdRevenue);
```

### <a id="adrevenue-unit"></a>Ad revenue unit

To send the ad revenue unit, call `setAdRevenueUnit` method of your `AdjustAdRevenue` instance with the unit value.

```actionscript
var adjustAdRevenue:AdjustAdRevenue = new AdjustAdRevenue("applovin_max_sdk");
adjustAdRevenue.setAdRevenueUnit("unit1");
Adjust.trackAdRevenue(adjustAdRevenue);
```

### <a id="adrevenue-placement"></a>Ad revenue placement

To send the ad revenue placement, call `setAdRevenuePlacement` method of your `AdjustAdRevenue` instance with the placement value.

```actionscript
var adjustAdRevenue:AdjustAdRevenue = new AdjustAdRevenue("applovin_max_sdk");
adjustAdRevenue.setAdRevenuePlacement("banner");
Adjust.trackAdRevenue(adjustAdRevenue);
```

### <a id="adrevenue-impressions"></a>Ad impressions count

To send the number of recorded ad impressions, call `setAdImpressionsCount` method of your `AdjustAdRevenue` instance with the number of ad impressions.

```actionscript
var adjustAdRevenue:AdjustAdRevenue = new AdjustAdRevenue("applovin_max_sdk");
adjustAdRevenue.setAdImpressionsCount(6);
Adjust.trackAdRevenue(adjustAdRevenue);
```

### <a id="adrevenue-callback-params"></a>Ad revenue callback parameters

Similar to how one can set [event callback parameters](#event-callback-params), the same can be done for ad revenue:

```actionscript
var adjustAdRevenue:AdjustAdRevenue = new AdjustAdRevenue("applovin_max_sdk");
adjustAdRevenue.setRevenue(1.0, "EUR");
adjustAdRevenue.setCalbackParameter("key", "value");
adjustAdRevenue.setCalbackParameter("foo", "bar");
Adjust.trackAdRevenue(adjustAdRevenue);
```

### <a id="adrevenue-partner-params"></a>Ad revenue partner parameters

Similar to how one can set [event partner parameters](#event-partner-params), the same can be done for ad revenue:

```actionscript
var adjustAdRevenue:AdjustAdRevenue = new AdjustAdRevenue("applovin_max_sdk");
adjustAdRevenue.setRevenue(1.0, "EUR");
adjustAdRevenue.addPartnerParameter("key", "value");
adjustAdRevenue.addPartnerParameter("foo", "bar");
Adjust.trackAdRevenue(adjustAdRevenue);
```

### <a id="purchase-verification"></a>Purchase verification

If you’ve enabled [purchase verification](https://help.adjust.com/en/article/purchase-verification), you can use the Adjust SDK to request App Store or Google Play Store purchase verification. There are two ways to verify purchases with the Adjust SDK.

### <a id="verify-and-track"></a>Verify purchase and record event

With this approach, you will be performing verification of your purchase and having an event tracked for that verification. This will give you an overview later in the dashboard on the events (and assigned revenue) based on whether verification was successful or not.

In order to do this, you need to complete your in-app purchase and then pass parameters that Adjust SDK needs out of that purchase in order to be able to try to verify the purchase. Once you have obtained the verification parameters the SDK needs, you can perform verification and tracking of an event by calling `verifyAndTrackAppStorePurchase` or `verifyAndTrackPlayStorePurchase` methods.

Next to revenue and currency of the purchase, you need to obtain the following parameters as well:

- Product ID (for both, App Store and Play Store purchases)
- Transaction ID (for App Store purchases)
- Purchase token (for Play Store purchases)

```actionscript
// perform App Store in-app purchase

// create an event with purchase parameters attached
var adjustEvent:AdjustEvent = new AdjustEvent("abc123");
adjustEvent.setRevenue(1.50, "EUR");
adjustEvent.setProductId("product-id");
adjustEvent.setTransactionId("transaction-id");

// call verifyAndTrackAppStorePurchase method
Adjust.verifyAndTrackAppStorePurchase(adjustEvent,
    function (verificationResult:AdjustPurchaseVerificationResult):void {
    trace("Verification status" + verificationResult.getVerificationStatus());
    trace("Message" + verificationResult.getMessage());
    trace("Code" + verificationResult.getCode().toString());
});
```

```actionscript
// perform Play Store in-app purchase

// create an event with purchase parameters attached
var adjustEvent:AdjustEvent = new AdjustEvent("abc123");
adjustEvent.setRevenue(1.50, "EUR");
adjustEvent.setProductId("product-id");
adjustEvent.setPurchaseToken("purchase-token");

// call verifyAndTrackPlayStorePurchase method
Adjust.verifyAndTrackPlayStorePurchase(adjustEvent,
    function (verificationResult:AdjustPurchaseVerificationResult):void {
    trace("Verification status" + verificationResult.getVerificationStatus());
    trace("Message" + verificationResult.getMessage());
    trace("Code" + verificationResult.getCode().toString());
});
```

### <a id="verify-only"></a>Verify purchase only

In case you don't want to see revenue events being automatically tracked once you verify the purchase, but you are instead interested in just getting the information on the validity of the purchase, you can also perform only the verification of the purchase. For this, you need to create instances of `AdjustAppStorePurchase` (for App Store purchases) and `AdjustPlayStorePurchase` (for Play Store purchases) classes and invoke `verifyAppStorePurchase` and `verifyPlayStorePurchase` methods.

```actionscript
// perform App Store in-app purchase

// create an instance of AdjustAppStorePurchase
var appStorePurchase:AdjustAppStorePurchase = new AdjustAppStorePurchase("product-id", "transaction-id");

// call verifyAppStorePurchase
Adjust.verifyAppStorePurchase(appStorePurchase,
    function (verificationResult:AdjustPurchaseVerificationResult):void {
    trace("Verification status" + verificationResult.getVerificationStatus());
    trace("Message" + verificationResult.getMessage());
    trace("Code" + verificationResult.getCode().toString());
});
```

```actionscript
// perform Play Store in-app purchase

// create an instance of AdjustPlayStorePurchase
var playStorePurchase:AdjustPlayStorePurchase = new AdjustPlayStorePurchase("product-id", "purchase-token");

// call verifyPlayStorePurchase
Adjust.verifyPlayStorePurchase(playStorePurchase,
    function (verificationResult:AdjustPurchaseVerificationResult):void {
    trace("Verification status" + verificationResult.getVerificationStatus());
    trace("Message" + verificationResult.getMessage());
    trace("Code" + verificationResult.getCode().toString());
});
```

* [Send subscription information](#subscription-sending)
      * [Subscription purchase date](#subscription-purchase-date)
      * [Subscription region](#subscription-region)
      * [Subscription callback parameters](#subscription-callback-params)
      * [Subscription partner parameters](#subscription-partner-params)

### <a id="subscription-sending"></a>Send subscription information

> Important: The following steps only set up subscription measurement within the Adjust SDK. To enable the feature, follow the steps at [Set up subscriptions for your app](https://help.adjust.com/en/article/set-up-subscriptions-for-your-app).

You can record App Store and Play Store subscriptions and verify their validity with the Adjust SDK. After the user purchases a subscription, create an `AdjustAppStoreSubscription` or `AdjustPlayStoreSubscription` instance containing the details.

```actionscript
// App Store subscription
var appStoreSubscription:AdjustAppStoreSubscription = new AdjustAppStoreSubscription(
    "price",
    "currency",
    "transactionId");
Adjust.trackAppStoreSubscription(appStoreSubscription);
```

```actionscript
// Play Store subscription
var playStoreSubscription:AdjustPlayStoreSubscription = new AdjustPlayStoreSubscription(
    "price",
    "currency",
    "sku",
    "orderId",
    "signature",
    "purchaseToken");
Adjust.trackPlayStoreSubscription(playStoreSubscription);
```

Subscription tracking parameters for App Store subscription:

- [price](https://developer.apple.com/documentation/storekit/product/price)
- currency (you need to pass [currencyCode](https://developer.apple.com/documentation/foundation/nslocale/1642836-currencycode?language=objc))
- [transactionId](https://developer.apple.com/documentation/storekit/skpaymenttransaction/1411288-transactionidentifier?language=objc)
- [transactionDate](https://developer.apple.com/documentation/storekit/skpaymenttransaction/1411273-transactiondate?language=objc)
- salesRegion (you need to pass [countryCode](https://developer.apple.com/documentation/foundation/nslocale/1643060-countrycode?language=objc) of the [priceLocale](https://developer.apple.com/documentation/storekit/skproduct/1506145-pricelocale?language=objc) object)

Subscription tracking parameters for Play Store subscription:

- [price](https://developer.android.com/reference/com/android/billingclient/api/SkuDetails#getpriceamountmicros)
- [currency](https://developer.android.com/reference/com/android/billingclient/api/SkuDetails#getpricecurrencycode)
- [sku](https://developer.android.com/reference/com/android/billingclient/api/Purchase#getsku)
- [orderId](https://developer.android.com/reference/com/android/billingclient/api/Purchase#getorderid)
- [signature](https://developer.android.com/reference/com/android/billingclient/api/Purchase#getsignature)
- [purchaseToken](https://developer.android.com/reference/com/android/billingclient/api/Purchase#getpurchasetoken)
- [purchaseTime](https://developer.android.com/reference/com/android/billingclient/api/Purchase#getpurchasetime)

> Note: All the links behind the parameters are pointing to fields one needs to obtain from native iOS and Android in-app purchases API. In-app purchases on Adobe AIR platform are being done with usage of some plugins which are wrapping the native API and can therefore have these fields exposed under different names or, in bad case scenario, not provide some of these fields at all. In case you are having issues in understanding how to properly pass these fields based on what your Adobe AIR plugin is sending you back, feel free contact us about it.

### <a id="subscription-purchase-date"></a>Subscription purchase date

You can record the date on which the user purchased a subscription. The SDK returns this data for you to report on.

```actionscript
// App Store subscription
var appStoreSubscription:AdjustAppStoreSubscription = new AdjustAppStoreSubscription(
    "price",
    "currency",
    "transactionId");
appStoreSubscription.setTransactionDate("transactionDate");
Adjust.trackAppStoreSubscription(appStoreSubscription);
```

```actionscript
// Play Store subscription
var playStoreSubscription:AdjustPlayStoreSubscription = new AdjustPlayStoreSubscription(
    "price",
    "currency",
    "sku",
    "orderId",
    "signature",
    "purchaseToken");
playStoreSubscription.setPurchaseDate("purchaseDate");
Adjust.trackPlayStoreSubscription(playStoreSubscription);
```

### <a id="subscription-region"></a>Subscription region

> Note: This is feature is iOS only.

You can record the region in which the user purchased a subscription. To do this, call the `setSalesRegion` method of your `AdjustAppStoreSubscription` instance to the country code as a string. This needs to be formatted as the [countryCode](https://developer.apple.com/documentation/storekit/storefront/3792000-countrycode) of the [Storefront](https://developer.apple.com/documentation/storekit/storefront) object.

```actionscript
// App Store subscription
var appStoreSubscription:AdjustAppStoreSubscription = new AdjustAppStoreSubscription(
    "price",
    "currency",
    "transactionId");
appStoreSubscription.setSalesRegion("salesRegion");
Adjust.trackAppStoreSubscription(appStoreSubscription);
```

### <a id="subscription-callback-params"></a>Subscription callback parameters

Similar to how one can set [event callback parameters](#event-callback-params), the same can be done for subscriptions:

```actionscript
// App Store subscription
var appStoreSubscription:AdjustAppStoreSubscription = new AdjustAppStoreSubscription(
    "price",
    "currency",
    "transactionId");
appStoreSubscription.setCalbackParameter("key", "value");
appStoreSubscription.setCalbackParameter("foo", "bar");
Adjust.trackAppStoreSubscription(appStoreSubscription);
```

### <a id="subscription-partner-params"></a>Subscription partner parameters

Similar to how one can set [event partner parameters](#event-partner-params), the same can be done for subscriptions:

```actionscript
// Play Store subscription
var playStoreSubscription:AdjustPlayStoreSubscription = new AdjustPlayStoreSubscription(
    "price",
    "currency",
    "sku",
    "orderId",
    "signature",
    "purchaseToken");
playStoreSubscription.setCalbackParameter("key", "value");
playStoreSubscription.setCalbackParameter("foo", "bar");
Adjust.trackPlayStoreSubscription(playStoreSubscription);
```

### <a id="device-ids"></a>Device IDs

The Adjust SDK contains helper methods that return device information. Use these methods to add details to your callbacks and improve your reporting.

### <a id="idfa"></a>IDFA

To obtain the IDFA, call the function `getIdfa` of the `Adjust` class:

```as
Adjust.getIdfa(function (idfa:String): void {
    trace("IDFA = " + idfa);
});
```

### <a id="idfv"></a>IDFV

To obtain the IDFV, call the function `getIdfv` of the `Adjust` class:

```as
Adjust.getIdfv(function (idfv:String): void {
    trace("IDFV = " + idfv);
});
```

### <a id="gps-adid"></a>Google advertising identifier

To obtain Google advertising ID, call the function `getGoogleAdId` of the `Adjust` class:

```actionscript
Adjust.getGoogleAdId(function (googleAdId:String): void {
    trace("Google Ad ID = " + googleAdId);
});
```

### <a id="fire-adid"></a>Amazon advertising identifier

If you need to obtain the Amazon advertising ID, you can call the `getAmazonAdId` method of the `Adjust` class:

```actionscript
Adjust.getAmazonAdId(function (amazonAdId:String): void {
    trace("Amazon Ad ID = " + amazonAdId);
});
```

### <a id="adid"></a>Adjust device identifier

For every device with your app installed on it, the Adjust backend generates a unique **Adjust device identifier** (**adid**). In order to obtain this identifier, you can make a call to `getAdid` method of the `Adjust` class:

```actionscript
Adjust.getAdid(function (adid:String): void {
    trace("Adjust device ID = " + adid);
});
```

**Note**: Information about the **adid** is available after app installation has been tracked by the Adjust backend. From that moment on, the Adjust SDK has information about the device **adid** and you can access it with this method. So, **it is not possible** to access the **adid** value before the SDK has been initialised and installation of your app has been successfully tracked.

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

### <a id="background-tracking"></a>Background tracking

The default behaviour of the Adjust SDK is to **pause sending HTTP requests while the app is in the background**. You can change this in your `AdjustConfig` instance by calling the `enableSendingInBackground` method:

```actionscript
var adjustConfig:AdjustConfig = new AdjustConfig("{YourAppToken}", AdjustEnvironment.SANDBOX);

adjustConfig.enableSendingInBackground();

Adjust.initSdk(adjustConfig);
```

If nothing is set, sending in background is **disabled by default**.

### <a id="external-device-id"></a>Set external device ID

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

If you want to use the external device ID in your business analytics, you can pass it as a session callback parameter. See the section on [session callback parameters](#session-callback-params) for more information.

You can import existing external device IDs into Adjust. This ensures that the backend matches future data to your existing device records. If you want to do this, please contact your Adjust representative.

### <a id="push-token"></a>Push token

To send us the push notification token, add the following call to Adjust **whenever you get your token in the app or when it gets updated**:

```actionscript
Adjust.setPushToken("YourPushNotificationToken");
```

Push tokens are used for Audience Builder and client callbacks, and they are required for the uninstall tracking feature.

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
