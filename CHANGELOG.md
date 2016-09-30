### Version 4.10.0 (30th September 2016)
#### Added
- Added support for iOS 10.
- Added revenue deduplication for Android platform.
- Added an option for enabling/disabling tracking while app is in background.
- Added a callback to be triggered if event is successfully tracked.
- Added a callback callback to be triggered if event tracking failed.
- Added a callback to be triggered if session is successfully tracked.
- Added a callback to be triggered if session tracking failed.
- Added possibility to set session callback and partner parameters with `addSessionCallbackParameter` and `addSessionPartnerParameter` methods.
- Added possibility to remove session callback and partner parameters by key with `removeSessionCallbackParameter` and `removeSessionPartnerParameter` methods.
- Added possibility to remove all session callback and partner parameters with `resetSessionCallbackParameters` and `resetSessionPartnerParameters` methods.
- Added new `Suppress` log level.
- Added possibility to delay initialisation of the SDK while maybe waiting to obtain some session callback or partner parameters with `delayed start` feature on adjust config instance.
- Added possibility to set user agent manually on adjust config instance.
- Added callback method to get deferred deep link content into the app.
- Added possibility to decide whether the SDK should launch the deferred deep link or not.
- Added possibility to set user agent manually on adjust config instance.

#### Changed
- Deferred deep link info will now arrive as part of the attribution response and not as part of the answer to first session.
- Updated docs.
- Native SDKs stability updates and improvements.
- Updated native iOS SDK to version **4.10.1**.
- Updated native Android SDK to version **4.10.2**.

#### Native SDKs
- [iOS SDK 4.10.1][ios_sdk_v4.10.1]
- [Android SDK 4.10.2][android_sdk_v4.10.2]

---

### Version 4.1.0 (23rd March 2016)
#### Added
- Added `CHANGELOG.md`.
- Added `getIdfa` method for getting `IDFA` on iOS device.
- Added `getGoogleAdId` method for getting `Google Play Services Ad Id` on Android device.

#### Changed
- Renamed `Adjust.framework` to `AdjustSdk.framework`.
- Removed `MAC MD5` tracking feature for `iOS platform` completely.
- Updated native iOS SDK to version **4.5.4**.
- Updated native Android SDK to version **4.2.3**.

#### Native SDKs
- [iOS SDK v4.5.4][ios_sdk_v4.5.4]
- [Android SDK v4.2.3][android_sdk_v4.2.3]

---

### Version 4.0.1 (8th September 2015)
#### Changed
- Code cleanup.

#### Fixed
- Removed hard coded environment variable.

#### Native SDKs
- [iOS SDK v4.2.8][ios_sdk_v4.2.8]
- [Android SDK v4.1.2][android_sdk_v4.1.2]

---

### Version 4.0.0 (2nd September 2015)
#### Added
- Upgraded adjust SDK to version `4.0.0`.

#### Changed
- Updated Native iOS SDK to version **4.2.8**.
- Updated Native Android SDK to version **4.1.2**.

#### Native SDKs
- [iOS SDK v4.2.8][ios_sdk_v4.2.8]
- [Android SDK v4.1.2][android_sdk_v4.1.2]

---

### Version 3.4.3 (2nd April 2015)
#### Added
- Added auxiliary classes to non-native/default target.

#### Native SDKs
- [iOS SDK v3.4.0][ios_sdk_v3.4.0]
- [Android SDK v3.5.0][android_sdk_v3.5.0]

---

### Version 3.4.2 (10th March 2015)
#### Added
- Added support for iOS 64 bit.
- Prefixed names to prevent namespace collisions.

#### Native SDKs
- [iOS SDK v3.4.0][ios_sdk_v3.4.0]
- [Android SDK v3.5.0][android_sdk_v3.5.0]

---

### Version 3.4.1 (2nd October 2014)
#### Fixed
- Fixed flash lifecycle events issue.

#### Native SDKs
- [iOS SDK v3.4.0][ios_sdk_v3.4.0]
- [Android SDK v3.5.0][android_sdk_v3.5.0]

---

### Version 3.4.0 (29th September 2014)
#### Added
- Added In-App Source Access.
- Add option to disable and enable the SDK temporarily.

#### Changed
- Updated native iOS SDK to version **3.4.0**.
- Updated native Android SDK to version **3.5.0**.

#### Native SDKs
- [iOS SDK v3.4.0][ios_sdk_v3.4.0]
- [Android SDK v3.5.0][android_sdk_v3.5.0]

---

### Version 2.2.2 (24th July 2014)
#### Added
- Added transmission of `Google Ad Identifier` for Android devices.

#### Native SDKs
- [iOS SDK v2.2.0][ios_sdk_v2.2.0]
- [Android SDK v2.1.6][android_sdk_v2.1.6]

---

### Version 2.2.1 (26th March 2014)
#### Fixed
- Fixed tracking events and revenue with custom parameters.

#### Native SDKs
- [iOS SDK v2.2.0][ios_sdk_v2.2.0]
- [Android SDK v2.1.6][android_sdk_v2.1.6]

---

### Version 2.2.0 (5th March 2014)
#### Changed
- Updated native iOS SDK to version **2.2.0**.

#### Fixed
- Fixed an issue with calling `trackRevenue` on iOS.

#### Native SDKs
- [iOS SDK v2.2.0][ios_sdk_v2.2.0]
- [Android SDK v2.1.6][android_sdk_v2.1.6]

---

### Version 2.1.3 (13th January 2014)
#### Changed
- Updated native iOS SDK to version **2.1.3**.
- Updated native Android SDK to version **2.1.6**.

#### Native SDKs
- [iOS SDK v2.1.3][ios_sdk_v2.1.3]
- [Android SDK v2.1.6][android_sdk_v2.1.6]

---

### Version 2.1.2 (10th January 2014)
#### Changed
- Updated native iOS SDK to version **2.1.2**.
- Updated native Android SDK to version **2.1.5**.

#### Native SDKs
- [iOS SDK v2.1.2][ios_sdk_v2.1.2]
- [Android SDK v2.1.5][android_sdk_v2.1.5]

---

### Version 2.1.1 (26th November 2013)
#### Changed
- Updated native Android SDK to version **2.1.4**.

#### Fixed
- Fixed Android extension build system.

#### Native SDKs
- [iOS SDK v2.1.1][ios_sdk_v2.1.1]
- [Android SDK v2.1.4][android_sdk_v2.1.4]

---

### Version 2.1.0 (22nd November 2013)
#### Added
- Initial release of the adjust SDK for Adobe AIR.
- Supported platforms: `iOS` and `Android`.

#### Native SDKs
- [iOS SDK v2.1.1][ios_sdk_v2.1.1]
- [Android SDK v2.1.3][android_sdk_v2.1.3]

[ios_sdk_v2.1.1]: https://github.com/adjust/ios_sdk/tree/v2.1.1
[ios_sdk_v2.1.2]: https://github.com/adjust/ios_sdk/tree/v2.1.2
[ios_sdk_v2.1.3]: https://github.com/adjust/ios_sdk/tree/v2.1.3
[ios_sdk_v2.2.0]: https://github.com/adjust/ios_sdk/tree/v2.2.0
[ios_sdk_v3.4.0]: https://github.com/adjust/ios_sdk/tree/v3.4.0
[ios_sdk_v4.2.8]: https://github.com/adjust/ios_sdk/tree/v4.2.8
[ios_sdk_v4.5.4]: https://github.com/adjust/ios_sdk/tree/v4.5.4
[ios_sdk_v4.10.1]: https://github.com/adjust/ios_sdk/tree/v4.5.4

[android_sdk_v2.1.3]: https://github.com/adjust/android_sdk/tree/v2.1.3
[android_sdk_v2.1.4]: https://github.com/adjust/android_sdk/tree/v2.1.4
[android_sdk_v2.1.5]: https://github.com/adjust/android_sdk/tree/v2.1.5
[android_sdk_v2.1.6]: https://github.com/adjust/android_sdk/tree/v2.1.6
[android_sdk_v3.5.0]: https://github.com/adjust/android_sdk/tree/v3.5.0
[android_sdk_v4.1.2]: https://github.com/adjust/android_sdk/tree/v4.1.2
[android_sdk_v4.2.3]: https://github.com/adjust/android_sdk/tree/v4.2.3
[android_sdk_v4.10.2]: https://github.com/adjust/android_sdk/tree/v4.10.2
