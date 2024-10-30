
---
# ![](deeplink/addon_template/icon.png?raw=true) Deeplink Plugin for Godot 3.5

Deeplink plugin allows processing of Android application links that enable direct navigation to requested app content.

_For iOS version, visit https://github.com/cengiz-pz/godot-ios-deeplink-plugin ._

## ![](deeplink/addon_template/icon.png?raw=true) Prerequisites
Follow instructions on the following page to create a custom Android gradle build
- [Create custom Android gradle build](https://docs.godotengine.org/en/stable/tutorials/export/android_gradle_build.html)

Follow instructions on the following page to associate your Godot app with your website:
- [Associate your Godot app with your website](https://developer.android.com/studio/write/app-link-indexing#associatesite)

## ![](deeplink/addon_template/icon.png?raw=true) Installation
Installation steps:
- download the release archive from Github
- unzip the release archive
- copy the unzipped folder's contents to your Godot project's root directory
- enable the addon via the `Plugins` tab of `Project->Project Settings...` menu, in the Godot Editor
- enable the plugin via the `Android` tab of `Project->Export...` menu, in the Godot Editor

## ![](deeplink/addon_template/icon.png?raw=true) Godot App Requirements
- Your Godot app should:
  - have `INTERNET` permission enabled
  - have `ACCESS_NETWORK_STATE` permission enabled
  - set minimum Android SDK to `21`

## ![](deeplink/addon_template/icon.png?raw=true) Configuration
- Update `AndroidManifest.xml` with the following `activity` element placed inside the `application` element.

```
		<activity
			android:name="org.godotengine.plugin.android.deeplink.DeeplinkActivity"
			android:theme="@style/Theme.AppCompat.NoActionBar"
			android:excludeFromRecents="true"
			android:launchMode="singleTask"
			android:exported="true"
			android:noHistory="true">

			<!-- label value can also be a reference to an internationalizable string such as "@string/filter_view_http_..."-->
			<intent-filter android:label="MyExampleHttpsFilter" android:autoVerify="true">
				<action android:name="android.intent.action.VIEW" />
				<category android:name="android.intent.category.DEFAULT" />
				<category android:name="android.intent.category.BROWSABLE" />
				<!-- Accepts URIs that begin with "https://www.example.com/mypath” -->
				<data android:scheme="https"
					android:host="www.example.com"
					android:pathPrefix="/mypath" />
				<!-- note that the leading "/" is required for pathPrefix-->
			</intent-filter>
		</activity>
```

- Set `android:scheme` to your required scheme.
- Replace `www.example.com` with your domain.
- Replace `/mypath` with the app link path you'll be using. Use `/` for all paths.

## ![](deeplink/addon_template/icon.png?raw=true) Usage
- Add `Deeplink` node to your scene.
- register a listener for the `deeplink_received` signal
	- Use the `DeeplinkUrl` object to retrieve `url`, `scheme`, `host`, and `path` data
- additional methods:
	- `is_domain_associated(a_domain: String)` -> returns true if your application is correctly associated with the given domain on the device
	- `navigate_to_open_by_default_settings()` -> navigates to the Android OS' `Open by Default` settings screen for your application. On this screen, tap on `Supported web addresses` to view all web addresses that can be associated with your app. Tap on the button placed next to the web domain to activate association.

## ![](deeplink/addon_template/icon.png?raw=true) Verification and Testing
`adb shell` command can be used to simulate app links as follows:
- `$> adb shell am start -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "https://www.example.com/mypath/mydata"`

For more information visit:
  - [Verify Android App Links](https://developer.android.com/training/app-links/verify-android-applinks)

## ![](deeplink/addon_template/icon.png?raw=true) Troubleshooting

### Unhandled Deeplinks
If your game is not handling your deeplinks, then make sure to revisit the [Prerequisites](#prerequisites) section.

### ADB logcat
`adb logcat` is one of the best tools for troubleshooting unexpected behavior
- use `$> adb logcat | grep 'godot'` on Linux
	- `adb logcat *:W` to see warnings and errors
	- `adb logcat *:E` to see only errors
	- `adb logcat | grep 'godot|somethingElse'` to filter using more than one string at the same time
- use `#> adb.exe logcat | select-string "godot"` on powershell (Windows)

Also check out:
https://docs.godotengine.org/en/stable/tutorials/platform/android/android_plugin.html#troubleshooting
<br/><br/><br/>

---
# ![](deeplink/addon_template/icon.png?raw=true) Credits
Developed by [Cengiz](https://github.com/cengiz-pz)

Original repository: [Godot Android Deeplink Plugin](https://github.com/cengiz-pz/godot-android-deeplink-plugin)

<br/><br/><br/>

---
# ![](deeplink/addon_template/icon.png?raw=true) All Plugins

| Plugin | Android | iOS |
| :---: | :--- | :--- |
| Notification Scheduler | https://github.com/cengiz-pz/godot-android-notification-scheduler-plugin | https://github.com/cengiz-pz/godot-ios-notification-scheduler-plugin |
| Admob | https://github.com/cengiz-pz/godot-android-admob-plugin | https://github.com/cengiz-pz/godot-ios-admob-plugin |
| Deeplink | https://github.com/cengiz-pz/godot-android-deeplink-plugin | https://github.com/cengiz-pz/godot-ios-deeplink-plugin |
| Share | https://github.com/cengiz-pz/godot-android-share-plugin | https://github.com/cengiz-pz/godot-ios-share-plugin |
| In-App Review | https://github.com/cengiz-pz/godot-android-inapp-review-plugin | https://github.com/cengiz-pz/godot-ios-inapp-review-plugin |
