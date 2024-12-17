<p align="center">
  <img width="256" height="256" src="demo/deeplink.png">
</p>

---
# ![](deeplink/addon_template/icon.png?raw=true) Deeplink Plugin

Deeplink plugin allows processing of Android application links that enable direct navigation to requested app content.

_For iOS version, visit https://github.com/cengiz-pz/godot-ios-deeplink-plugin ._

## ![](deeplink/addon_template/icon.png?raw=true) Prerequisites
Follow instructions on the following page to create a custom Android gradle build
- [Create custom Android gradle build](https://docs.godotengine.org/en/stable/tutorials/export/android_gradle_build.html)

Follow instructions on the following page to associate your Godot app with your website:
- [Associate your Godot app with your website](https://developer.android.com/studio/write/app-link-indexing#associatesite)

## ![](deeplink/addon_template/icon.png?raw=true) Installation
There are 2 ways to install the `Deeplink` plugin into your project:
- Through the Godot Editor's AssetLib
- Manually by downloading archives from Github

Before starting installation, please delete any other versions of this plugin.

### ![](deeplink/addon_template/icon.png?raw=true) Installing via AssetLib
Steps:
- search for and select the `Deeplink` plugin in Godot Editor
- click `Download` button
- on the installation dialog...
	- keep `Change Install Folder` setting pointing to your project's root directory
	- keep `Ignore asset root` checkbox checked
	- click `Install` button
- enable the plugin via the `Plugins` tab of `Project->Project Settings...` menu, in the Godot Editor

### ![](deeplink/addon_template/icon.png?raw=true) Installing manually
Steps:
- download release archive from Github
- unzip the release archive
- copy to your Godot project's root directory
- enable the plugin via the `Plugins` tab of `Project->Project Settings...` menu, in the Godot Editor

## ![](deeplink/addon_template/icon.png?raw=true) Usage
- Add `Deeplink` nodes to your scene per URL association and follow the following steps:
	- set the required field on each `Deeplink` node
		- `scheme`
		- `host`
		- `path prefix`
	- note that `scheme`, `host`, and `path prefix` must all match for a URI to be processed by the app
		- leave `path prefix` empty to process all paths in `host`
- register a listener for the `deeplink_received` signal
	- process `url`, `scheme`, `host`, and `path` data from the signal
- alternatively, use the following methods to get most recent deeplink data:
	- `get_link_url()` -> full URL for the deeplink
	- `get_link_scheme()` -> scheme for the deeplink (ie. 'https')
	- `get_link_host()` -> host for the deeplink (ie. 'www.example.com')
	- `get_link_path()` -> path for the deeplink (the part that comes after host)
- additional methods:
	- `is_domain_associated(a_domain: String)` -> returns true if your application is correctly associated with the given domain on the tested device
	- `navigate_to_open_by_default_settings()` -> navigates to the Android OS' `Open by Default` settings screen for your application

## ![](deeplink/addon_template/icon.png?raw=true) Testing
`adb shell` command can be used to simulate app links as follows:
- `$> adb shell am start -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "https://www.example.com/mydata/path"`

## ![](admob/addon_template/icon.png?raw=true) Android Export
- Make sure that the scene that contains your Deeplink nodes is selected in the Godot Editor when building and exporting for Android
	- Close other scenes to make sure
	- _Deeplink nodes will be searched in the scene that is currently open in the Godot Editor_

## ![](deeplink/addon_template/icon.png?raw=true) Troubleshooting

### Unhandled Deeplinks
If your game is not handling your deeplinks, then make sure to revisit the [Android Export](#android-export) and [Prerequisites](#prerequisites) sections.

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

<br/><br/>


___

# ![](deeplink/addon_template/icon.png?raw=true) Contribution

This section provides information on how to build the plugin for contributors.

<br/>

___

## ![](deeplink/addon_template/icon.png?raw=true) Prerequisites

- [Install AndroidStudio](https://developer.android.com/studio)

<br/>

___

## ![](deeplink/addon_template/icon.png?raw=true) Refreshing addon submodule

- Remove `deeplink/addon_template` directory
- Run `git submodule update --remote --merge`

<br/><br/>

---
# ![](deeplink/addon_template/icon.png?raw=true) All Plugins

| Plugin | Android | iOS |
| :---: | :--- | :--- |
| Notification Scheduler | https://github.com/cengiz-pz/godot-android-notification-scheduler-plugin | https://github.com/cengiz-pz/godot-ios-notification-scheduler-plugin |
| Admob | https://github.com/cengiz-pz/godot-android-admob-plugin | https://github.com/cengiz-pz/godot-ios-admob-plugin |
| Deeplink | https://github.com/cengiz-pz/godot-android-deeplink-plugin | https://github.com/cengiz-pz/godot-ios-deeplink-plugin |
| Share | https://github.com/cengiz-pz/godot-android-share-plugin | https://github.com/cengiz-pz/godot-ios-share-plugin |
| In-App Review | https://github.com/cengiz-pz/godot-android-inapp-review-plugin | https://github.com/cengiz-pz/godot-ios-inapp-review-plugin |
