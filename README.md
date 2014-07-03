## Summary

This is the AIR SDK of adjust™. You can read more about adjust™ at [adjust.com].

## Basic Installation

### <a id="step1"></a>1. Get the SDK

Download the latest version from our [releases page][releases]. Extract the
archive in a folder of your choice.

### <a id="step2"></a>2. Add it to your project

In Flash Builder's Project Settings pick "ActionScript Build Path" from the list
at left. Navigate to the "Native Extensions" tab and click "Add ANE…" button and
locate AdjustIo-x.y.z.ane downloaded in the previous step.

![][preferences]

Flash Builder will complain about missing support for your desktop platform, but
don't worry, we added a ```default``` target which will be used when running your
app e.g. in emulator. Instead of tracking events/sessions/revenue it will ```trace()```
them so you could easily check if everything works as expected.

![][added]

### <a id="step3"></a>3. Integrate adjust into your app

To start tracking with adjust you need to initialize the SDK with your App Token.
You can find it in your [dashboard].

```actionscript
import com.adeven.adjustio.AdjustIo;

public class Example extends Sprite
{
    private static const ADJUST_APP_TOKEN: String = "{YourAppToken}";

    public function Example()
    {
        super();

        AdjustIo.initialize(ADJUST_APP_TOKEN);

        // support autoOrients
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;
    }
}
```

Depending on whether or not you build your app for testing or for production
you can pass the environment to the initializer:

```actionscript
// import com.adeven.adjustio.Environment;

AdjustIo.initialize(ADJUST_APP_TOKEN, Environment.SANDBOX);
AdjustIo.initialize(ADJUST_APP_TOKEN, Environment.PRODUCTION);
```

You can increase or decrease the amount of logs you see by passing the log level:

```actionscript
// import com.adeven.adjustio.LogLevel;

AdjustIo.initialize(ADJUST_APP_TOKEN, Environment.SANDBOX, LogLevel.VERBOSE); // enable all logging
AdjustIo.initialize(ADJUST_APP_TOKEN, Environment.SANDBOX, LogLevel.DEBUG);   // enable more logging
AdjustIo.initialize(ADJUST_APP_TOKEN, Environment.SANDBOX, LogLevel.INFO);    // the default
AdjustIo.initialize(ADJUST_APP_TOKEN, Environment.SANDBOX, LogLevel.WARN);    // disable info logging
AdjustIo.initialize(ADJUST_APP_TOKEN, Environment.SANDBOX, LogLevel.ERROR);   // disable warnings as well
AdjustIo.initialize(ADJUST_APP_TOKEN, Environment.SANDBOX, LogLevel.ASSERT);  // disable errors as well
```

If your app makes heavy use of event tracking, you might want to delay some
HTTP requests in order to send them in one batch every minute. You can enable
event buffering by passing ```true``` as a fourth parameter:

```actionscript
AdjustIo.initialize(ADJUST_APP_TOKEN, Environment.SANDBOX, LogLevel.WARN, true);
```

### <a id="step4"></a>4. Adjust Android manifest

Before building your AIR app for Android you need to make some adjustments:

1. Open the Application Descriptor XML file (by default this is ```src/<YourProjectName>-app.xml```).
2. Scroll down to find ```<android>``` section.
3. Add or uncomment the ```<uses-permission>``` tags for ```INTERNET``` and ```ACCESS_WIFI_STATE``` if they aren't present already:

![][permissions]

4. Add broadcast receiver:

![][receiver]

## Debugging on device

### Android device

Use ```logcat``` tool that comes with Android SDK:

```
<path-to-android-sdk>/platform-tools/adb logcat AdjustIo:V *:S
```

### iOS device

Check the Console at XCode's Device Organizer to access AdjustIo logs:

![][xcode-logs]

## Additional features

Once you integrated the adjust SDK into your project, you can take advantage
of the following features.

### Add tracking of custom events.

You can tell adjust about every event you want. Suppose you want to track
every tap on a button. You would have to create a new Event Token in your
[dashboard]. Let's say that Event Token is `abc123`. In your button's
click handler method you could then add the following line to track the click:

```actionscript
AdjustIo.instance.trackEvent("abc123");
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

AdjustIo.instance.trackEvent("abc123", parameters);
```

In that case we would track the event and send a request to:

    http://www.adjust.com/callback?key=value&foo=bar

It should be mentioned that we support a variety of placeholders like `{idfa}`
that can be used as parameter values. In the resulting callback this
placeholder would be replaced with the ID for Advertisers of the current
device. Also note that we don't store any of your custom parameters, but only
append them to your callbacks. If you haven't registered a callback for an
event, these parameters won't even be read.

### Add tracking of revenue

If your users can generate revenue by clicking on advertisements or making
in-app purchases you can track those revenues. If, for example, a click is
worth one cent, you could make the following call to track that revenue:

```actionscript
AdjustIo.instance.trackRevenue(1.0);
```

The parameter is supposed to be in cents and will get rounded to one decimal
point. If you want to differentiate between different kinds of revenue you can
get different Event Tokens for each kind. Again, you need to create those Event
Tokens in your [dashboard]. In that case you would make a call like this:

```actionscript
AdjustIo.instance.trackRevenue(1.0, "abc123");
```

Again, you can register a callback and provide a dictionary of named
parameters, just like it worked with normal events.

```actionscript
var parameters: Object = { key: "value", bar: "foo" };

AdjustIo.instance.trackRevenue(1.0, "abc123", parameters);
```

[adjust.io]: http://adjust.io
[dashboard]: http://adjust.io
[releases]: https://github.com/adeven/adjust_air_sdk/releases
[preferences]: https://raw.github.com/adeven/adjust_sdk/master/Resources/air/preferences.png
[added]: https://raw.github.com/adeven/adjust_sdk/master/Resources/air/added.png
[permissions]: https://raw.github.com/adeven/adjust_sdk/master/Resources/air/permissions.png
[receiver]: https://raw.github.com/adeven/adjust_sdk/master/Resources/air/receiver.png
[xcode-logs]: https://raw.github.com/adeven/adjust_sdk/master/Resources/air/xcode-logs.png

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
