### Version 4.10.0 (xx September 2016)
#### Added
- Standard Deeplinking

#### Changed
- Implement delegates and session (Callback and Partner) parameters

#### Native SDKs
- [iOS@4.10.1][ios_sdk_v4.10.1]
- [Android@4.10.0][android_sdk_v4.10.0]

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
- [iOS@v4.5.4][ios_sdk_v4.5.4]
- [Android@v4.2.3][android_sdk_v4.2.3]

---

### Version 4.0.1 (8th September 2015)
#### Changed
- Code cleanup.

#### Fixed
- Removed hard coded environment variable.

#### Native SDKs
- [iOS@v4.2.8][ios_sdk_v4.2.8]
- [Android@v4.1.2][android_sdk_v4.1.2]

---

### Version 4.0.0 (2nd September 2015)
#### Added
- Upgraded adjust SDK to version `4.0.0`.

#### Changed
- Updated Native iOS SDK to version **4.2.8**.
- Updated Native Android SDK to version **4.1.2**.

#### Native SDKs
- [iOS@v4.2.8][ios_sdk_v4.2.8]
- [Android@v4.1.2][android_sdk_v4.1.2]

---

### Version 3.4.3 (2nd April 2015)
#### Added
- Added auxiliary classes to non-native/default target.

#### Native SDKs
- [iOS@v3.4.0][ios_sdk_v3.4.0]
- [Android@v3.5.0][android_sdk_v3.5.0]

---

### Version 3.4.2 (10th March 2015)
#### Added
- Added support for iOS 64 bit.
- Prefixed names to prevent namespace collisions.

#### Native SDKs
- [iOS@v3.4.0][ios_sdk_v3.4.0]
- [Android@v3.5.0][android_sdk_v3.5.0]

---

### Version 3.4.1 (2nd October 2014)
#### Fixed
- Fixed flash lifecycle events issue.

#### Native SDKs
- [iOS@v3.4.0][ios_sdk_v3.4.0]
- [Android@v3.5.0][android_sdk_v3.5.0]

---

### Version 3.4.0 (29th September 2014)
#### Added
- Added In-App Source Access.
- Add option to disable and enable the SDK temporarily.

#### Changed
- Updated native iOS SDK to version **3.4.0**.
- Updated native Android SDK to version **3.5.0**.

#### Native SDKs
- [iOS@v3.4.0][ios_sdk_v3.4.0]
- [Android@v3.5.0][android_sdk_v3.5.0]

---

### Version 2.2.2 (24th July 2014)
#### Added
- Added transmission of `Google Ad Identifier` for Android devices.

#### Native SDKs
- [iOS@v2.2.0][ios_sdk_v2.2.0]
- [Android@v2.1.6][android_sdk_v2.1.6]

---

### Version 2.2.1 (26th March 2014)
#### Fixed
- Fixed tracking events and revenue with custom parameters.

#### Native SDKs
- [iOS@v2.2.0][ios_sdk_v2.2.0]
- [Android@v2.1.6][android_sdk_v2.1.6]

---

### Version 2.2.0 (5th March 2014)
#### Changed
- Updated native iOS SDK to version **2.2.0**.

#### Fixed
- Fixed an issue with calling `trackRevenue` on iOS.

#### Native SDKs
- [iOS@v2.2.0][ios_sdk_v2.2.0]
- [Android@v2.1.6][android_sdk_v2.1.6]

---

### Version 2.1.3 (13th January 2014)
#### Changed
- Updated native iOS SDK to version **2.1.3**.
- Updated native Android SDK to version **2.1.6**.

#### Native SDKs
- [iOS@v2.1.3][ios_sdk_v2.1.3]
- [Android@v2.1.6][android_sdk_v2.1.6]

---

### Version 2.1.2 (10th January 2014)
#### Changed
- Updated native iOS SDK to version **2.1.2**.
- Updated native Android SDK to version **2.1.5**.

#### Native SDKs
- [iOS@v2.1.2][ios_sdk_v2.1.2]
- [Android@v2.1.5][android_sdk_v2.1.5]

---

### Version 2.1.1 (26th November 2013)
#### Changed
- Updated native Android SDK to version **2.1.4**.

#### Fixed
- Fixed Android extension build system.

#### Native SDKs
- [iOS@v2.1.1][ios_sdk_v2.1.1]
- [Android@v2.1.4][android_sdk_v2.1.4]

---

### Version 2.1.0 (22nd November 2013)
#### Added
- Initial release of the adjust SDK for Adobe AIR.
- Supported platforms: `iOS` and `Android`.

#### Native SDKs
- [iOS@v2.1.1][ios_sdk_v2.1.1]
- [Android@v2.1.3][android_sdk_v2.1.3]

[ios_sdk_v2.1.1]: https://github.com/adjust/ios_sdk/tree/v2.1.1
[ios_sdk_v2.1.2]: https://github.com/adjust/ios_sdk/tree/v2.1.2
[ios_sdk_v2.1.3]: https://github.com/adjust/ios_sdk/tree/v2.1.3
[ios_sdk_v2.2.0]: https://github.com/adjust/ios_sdk/tree/v2.2.0
[ios_sdk_v3.4.0]: https://github.com/adjust/ios_sdk/tree/v3.4.0
[ios_sdk_v4.2.8]: https://github.com/adjust/ios_sdk/tree/v4.2.8
[ios_sdk_v4.5.4]: https://github.com/adjust/ios_sdk/tree/v4.5.4

[android_sdk_v2.1.3]: https://github.com/adjust/android_sdk/tree/v2.1.3
[android_sdk_v2.1.4]: https://github.com/adjust/android_sdk/tree/v2.1.4
[android_sdk_v2.1.5]: https://github.com/adjust/android_sdk/tree/v2.1.5
[android_sdk_v2.1.6]: https://github.com/adjust/android_sdk/tree/v2.1.6
[android_sdk_v3.5.0]: https://github.com/adjust/android_sdk/tree/v3.5.0
[android_sdk_v4.1.2]: https://github.com/adjust/android_sdk/tree/v4.1.2
[android_sdk_v4.2.3]: https://github.com/adjust/android_sdk/tree/v4.2.3
