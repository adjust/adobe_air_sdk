## Migrate your adjust SDK for Adobe AIR to 4.17.0 from 3.4.3

### SDK initialization

We have changed how you configure and start the adjust SDK. All initial setup is now done with a new 
instance of the `AdjustConfig` object. The following steps should now be taken to configure the adjust SDK:

1. Create an instance of an `AdjustConfig` config object with the app token and environment.
2. Optionally, you can now call methods of the `AdjustConfig` object to specify available options.
3. Launch the SDK by invoking `Adjust.start` with the config object.

Here is an example of how the setup might look before and after the migration:

##### Before

```actionscript
import com.adjust.sdk.Adjust;
import com.adjust.sdk.Environment;
import com.adjust.sdk.LogLevel;

public class Example extends Sprite {
    public function Example() {
        var appToken = "{YourAppToken}";
        var environment = Environment.SANDBOX;
        var logLevel = LogLevel.INFO;
        var enableEventBuffering = false;
        
        Adjust.appDidLaunch(appToken, environment, logLevel, enableEventBuffering);
    }
}
```

##### After

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

### Event tracking

We also introduced proper event objects that are set up before they are tracked. Again, an example of how it 
might look like before and after:

##### Before

```actionscript
var parameters: Object = { key: "value", bar: "foo" };

Adjust.trackEvent("abc123", parameters);
```

##### After

```actionscript
var adjustEvent:AdjustEvent = new AdjustEvent("abc123");

adjustEvent.addCallbackParameter("key", "value");
adjustEvent.addCallbackParameter("foo", "bar");

Adjust.trackEvent(adjustEvent);
```

### Revenue tracking

Revenues are now handled like normal events. You just set a revenue and a currency to track revenues. 
Note that it is no longer possible to track revenues without associated event tokens. You might need 
to create an additional event token in your dashboard.

*Please note* - the revenue format has been changed from a cent float to a whole currency-unit float. 
Current revenue tracking must be adjusted to whole currency units (i.e., divided by 100) in order to 
remain consistent.

##### Before

```actionscript
Adjust.trackRevenue(1.0, "abc123");
```

##### After

```actionscript
var adjustEvent:AdjustEvent = new AdjustEvent("abc123");
adjustEvent.setRevenue(0.01, "EUR");
Adjust.trackEvent(adjustEvent);
```

### Get attribution information

In version 3.x.x of the adjust SDK, you could access attribution data in a callback method which you
would pass to the `Adjust` instance as a parameter of the `setResponseDelegate` method. Starting from 
version 4.0.0, attribution information is obtained in another method, which we call the **attribution 
callback**. This method needs to be defined and passed as a parameter of the `setAttributionCallbackDelegate` 
method of the `AdjustConfig` object.

##### Before

```actionscript
import com.adjust.sdk.Adjust;

public class Example extends Sprite {
    public function Example() {
        // ...

        Adjust.setResponseDelegate(ResponseDelegate);
    }

    private function ResponseDelegate(responseData: Object): void {
        // Do stuff with attribution info.
    }
}
```

###### After

```actionscript
import com.adjust.sdk.Adjust;

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
        // Do stuff with attribution info.
    }
}
```

### Broadcast receiver

We have renamed the adjust broadcast receiver (which you should use in case that you don't have your own)
starting from version 4.0.0. This means that you should edit its entry in your application descripter file
and change the name of the broadcast receiver class from `ReferrerReceiver` to `AdjustReferrerReceiver`.

##### Before

```actionscript
<receiver
    android:name="com.adjust.sdk.ReferrerReceiver"
    android:exported="true" >
    <intent-filter>
        <action android:name="com.android.vending.INSTALL_REFERRER" />
    </intent-filter>
</receiver>
```

##### After

```actionscript
<receiver
    android:name="com.adjust.sdk.AdjustReferrerReceiver"
    android:permission="android.permission.INSTALL_PACKAGES"
    android:exported="true" >
    <intent-filter>
        <action android:name="com.android.vending.INSTALL_REFERRER" />
    </intent-filter>
</receiver>
```

