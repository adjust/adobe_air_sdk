## Summary

This is the AIR SDK of adjust™. You can read more about adjust™ at [adjust.com].

## Basic Installation

### 1. Get the SDK

Download the latest version from our [releases page][releases]. Extract the
archive in a folder of your choice.

### 2. Add it to your project

We assume that you are using IntelliJ IDEA as your IDE. If you are using Flash Builder follow the instructions [here][flash-builder].

In IDEA's Project Structure pick your Module from the Project Settings. Choose the Dependencies tab
and click the plus button to add a dependency to your module. Pick the `New Library...` option.

![][idea-new-library]

Locate the `Adjust-x.y.z.ane` you just downloaded and click `OK`.

![][idea-locate]

### 3. Integrate adjust into your app

To start tracking with adjust you need to initialize the SDK. Add the following code to your main Sprite.

```actionscript
import com.adjust.sdk.Adjust;
import com.adjust.sdk.Environment;
import com.adjust.sdk.LogLevel;

public class Example extends Sprite
{
    public function Example()
    {
        var appToken = "{YourAppToken}";
        var environment = Environment.SANDBOX;
        var logLevel = LogLevel.INFO;
        var enableEventBuffering = false;
        
        Adjust.appDidLaunch(appToken,environment, logLevel, enableEventBuffering);
    }
}
```

Replace `{YourAppToken}` with your App Token. You can find in your [dashboard].

You can increase or decrease the amount of logs you see by changing the variable
`logLevel` to one of the following, by importing the class `com.adjust.sdk.LogLevel`:

- `LogLevel.VERBOSE` - enable all logging
- `LogLevel.DEBUFG` - enable more logging
- `LogLevel.INFO` - the default
- `LogLevel.WARN` - disable info logging
- `LogLevel.ERROR` - disable warnings as well
- `LogLevel.ASSERT` - disable errors as well

Depending on whether or not you build your app for testing or for production
you must change the variable `environment` with one of these values, by importing the class `com.adjust.sdk.Environment`:

```
Environment.SANDBOX
Environment.PRODUCTION
```

**Important:** This value should be set to `Sandbox` if and only if you or
someone else is testing your app. Make sure to set the environment to
`Production` just before you publish the app. Set it back to `Sandbox` when you
start testing it again.

We use this environment to distinguish between real traffic and artificial
traffic from test devices. It is very important that you keep this value
meaningful at all times! Especially if you are tracking revenue.

If your app makes heavy use of event tracking, you might want to delay some
HTTP requests in order to send them in one batch every minute. You can enable
event buffering by changing the variable `enableEventBuffering` to `true`.

### 4. Adjust Android manifest

To use your AIR app for Android with our SDK it's necessary edit the Android mainfest file.
To edit the Android manifest of your AIR apps:

1. Open the application descriptor file, usually located at `src/{YourProjectName}-app.xml`.
2. Search for the `<android>` tag
3. Edit between the `<manifest>`tag.

You can find the needed [permissions][android-permissions] and how to add [broadcast receiver][brodcast-android] in our Android guide.

![][android-manifest]

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

Once you integrated the adjust SDK into your project, you can take advantage
of the following features.

### 5. Add tracking of custom events.

You can tell adjust about every event you want. Suppose you want to track
every tap on a button. You would have to create a new Event Token in your
[dashboard]. Let's say that Event Token is `abc123`. In your button's
click handler method you could then add the following line to track the click:

```actionscript
Adjust.trackEvent("abc123");
```

You can also register a callback URL for that event in your [dashboard] and we
will send a GET request to that URL whenever the event gets tracked. In that
case you can also put some key-value-pairs in an object and pass it to the
`trackEvent` method. We will then append these named parameters to your
callback URL.

For example, suppose you have registered the URL
`http://www.adjust.com/callback` for your event with Event Token `abc123` and
execute the following lines:

```actionscript
var parameters: Object = { key: "value", bar: "foo" };

Adjust.trackEvent("abc123", parameters);
```

In that case we would track the event and send a request to:

    http://www.adjust.com/callback?key=value&foo=bar

It should be mentioned that we support a variety of placeholders like `{idfa}`
that can be used as parameter values. In the resulting callback this
placeholder would be replaced with the ID for Advertisers of the current
device. Also note that we don't store any of your custom parameters, but only
append them to your callbacks. If you haven't registered a callback for an
event, these parameters won't even be read.

### 6. Add tracking of revenue

If your users can generate revenue by clicking on advertisements or making
in-app purchases you can track those revenues. If, for example, a click is
worth one cent, you could make the following call to track that revenue:

```actionscript
Adjust.trackRevenue(1.0);
```

The parameter is supposed to be in cents and will get rounded to one decimal
point. If you want to differentiate between different kinds of revenue you can
get different Event Tokens for each kind. Again, you need to create those Event
Tokens in your [dashboard]. In that case you would make a call like this:

```actionscript
Adjust.trackRevenue(1.0, "abc123");
```

Again, you can register a callback and provide a dictionary of named
parameters, just like it worked with normal events.

```actionscript
var parameters: Object = { key: "value", bar: "foo" };

AdjustIo.instance.trackRevenue(1.0, "abc123", parameters);
```

### 7. Receive delegate callbacks

Every time your app tries to track a session, an event or some revenue, you can
be notified about the success of that operation and receive additional information 
about the current install. Pass a function object to `Adjust.setResponseDelegate`.
This function object should accept an object and have no return. 
An example of a delegate that traces all the keys: 

```actionscript
import com.adjust.sdk.Adjust;

public class Example extends Sprite
{
    public function Example()
    {
    	// ...
    	
    	Adjust.setResponseDelegate(ResponseDelegate);
    }
    
    private function ResponseDelegate(responseData: Object): void {
        for (var key:String in responseData) {
            trace(key + ": " + responseData[key]);
        }
    }
}
```

The delegate method will get called every time any activity was tracked or failed to track. 
Within the delegate method you have access to the responseData parameter. Here is a quick summary of its attributes:

- `String activityKind` indicates what kind of activity was tracked. It has
one of these values:

	```
	ActivityKind.SESSION
	ActivityKind.EVENT
	ActivityKind.REVENUE
	ActivityKind.REATTRIBUTION
	```

- `Boolean success` indicates whether or not the tracking attempt was
  successful.
- `Boolean willRetry` is true when the request failed, but will be retried.
- `string error` an error message when the activity failed to track or
  the response could not be parsed. Is `null` otherwise.
- `String trackerToken` the tracker token of the current install. Is `null` if
  request failed or response could not be parsed.
- `String trackerName` the tracker name of the current install. Is `null` if
  request failed or response could not be parsed.
- `String network` the network grouping level of the current install. Is `null` if
  request failed, unavailable or response could not be parsed.
- `String campaign` the campaign grouping level of the current install. Is `null` if
  request failed, unavailable or response could not be parsed.
- `String adgroup` the ad group grouping level of the current install. Is `null` if
  request failed, unavailable or response could not be parsed.
- `String creative` the creative grouping level of the current install. Is `null` if
  request failed, unavailable or response could not be parsed.

Please make sure to consider [applicable attribution data policies.][attribution-data]

### 8. Disable tracking

You can disable the adjust SDK from tracking by invoking the method setEnabled with the enabled parameter as false. This setting is remembered between sessions, but it can only be activated after the first session.

```actionscript
Adjust.setEnabled(false);
```

You can verify if the adjust SDK is currently active with the method isEnabled. It is always possible to activate the adjust SDK by invoking setEnabled with the enabled parameter as true.

[adjust]: http://adjust.com
[dashboard]: http://adjust.com
[releases]: https://github.com/adjust/adjust_air_sdk/releases
[permissions]: https://raw.github.com/adjust/adjust_sdk/master/Resources/air/permissions.png
[xcode-logs]: https://raw.github.com/adjust/adjust_sdk/master/Resources/air/v4/xcode_logs.png

[android-permissions]: https://github.com/adjust/android_sdk#4-add-permissions
[brodcast-android]: https://github.com/adjust/android_sdk#6-add-broadcast-receiver
[attribution-data]: https://github.com/adjust/sdks/blob/master/doc/attribution-data.md
[android-manifest]: https://raw.github.com/adjust/adjust_sdk/master/Resources/air/v4/android_manifest.png
[flash-builder]: https://github.com/adjust/adobe_air_sdk/blob/master/doc/flash_builder.md
[idea-locate]: https://raw.github.com/adjust/adjust_sdk/master/Resources/air/v4/idea_locate.png
[idea-new-library]: https://raw.github.com/adjust/adjust_sdk/master/Resources/air/v4/idea_new_library.png

## License

The adjust-sdk is licensed under the MIT License.

Copyright (c) 2012-2014 adjust GmbH,
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
