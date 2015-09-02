## Migrate your adjust SDK for Adobe AIR to 4.0.0 from 3.4.3

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

public class Example extends Sprite
{
    public function Example()
    {
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

public class Example extends Sprite
{
    public function Example()
    {
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
