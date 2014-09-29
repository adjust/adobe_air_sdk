# Flash Builder

In Flash Builder's Project Settings pick "ActionScript Build Path" from the list
at left. Navigate to the "Native Extensions" tab and click "Add ANE…" button and
locate Adjust-x.y.z.ane downloaded in the previous step.

![][preferences]

Flash Builder will complain about missing support for your desktop platform, but
don't worry, we added a ```default``` target which will be used when running your
app e.g. in emulator. Instead of tracking events/sessions/revenue it will ```trace()```
them so you could easily check if everything works as expected.

![][added]

[preferences]: https://raw.github.com/adjust/adjust_sdk/master/Resources/air/preferences.png
[added]: https://raw.github.com/adjust/adjust_sdk/master/Resources/air/added.png
