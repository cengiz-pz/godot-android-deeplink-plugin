# ![](deeplink/addon_template/icon.png?raw=true) Deeplink Plugin

Deeplink plugin allows processing of application links that enable direct navigation to requested app content

## ![](deeplink/addon_template/icon.png?raw=true) Prerequisites
Follow instructions on the following page to create a custom Android build
- [Create custom Android build](https://docs.godotengine.org/en/stable/tutorials/export/android_custom_build.html)

Follow instructions on the following page to associate your Godot app with your website:
- [Associate your Godot app with your website](https://developer.android.com/studio/write/app-link-indexing#associatesite)

## ![](deeplink/addon_template/icon.png?raw=true) Installation
There are 2 ways to install the `Deeplink` plugin into your project:
- Through the Godot Editor's AssetLib
- Manually by downloading archives from Github

### ![](deeplink/addon_template/icon.png?raw=true) Installing via AssetLib
Steps:
- search for and select the `Deeplink` plugin in Godot Editor
- click `Download` button
- enable the plugin via `Project->Export...->Android` in the Godot Editor

### ![](deeplink/addon_template/icon.png?raw=true) Installing manually
Steps:
- download release archive from Github
- unzip the release archive
- copy to your Godot project's `addons` directory
- enable the plugin via `Project->Export...->Android` in the Godot Editor

## ![](deeplink/addon_template/icon.png?raw=true) Usage
- Add one `Deeplink` node to your scene per URL association and follow the following steps:
  - set the required field on each `Deeplink` node
    - `scheme`
    - `host`
    - `path prefix`
- register a listener for the `deeplink_received` signal
- use the following methods to get deeplink data:
    - `get_link_url()` -> full URL for the deeplink
	- `get_link_scheme()` -> scheme for the deeplink (ie. 'https')
	- `get_link_host()` -> host for the deeplink (ie. 'www.example.com')
	- `get_link_path()` -> path for the deeplink (the part that comes after host)
- additional methods:
  - `is_domain_associated(a_domain: String)` -> returns true if your application is correctly associated with the given domain on the tested device
  - `navigate_to_open_by_default_settings()` -> navigates to the Android OS' `Open by Default` settings screen for your application

## ![](deeplink/addon_template/icon.png?raw=true) Troubleshooting
`adb logcat` is one of the best tools for troubleshooting unexpected behavior
- use `$> adb logcat | grep 'godot'` on Linux
	- `adb logcat *:W` to see warnings and errors
	- `adb logcat *:E` to see only errors
	- `adb logcat | grep 'godot|somethingElse'` to filter using more than one string at the same time
- use `#> adb.exe logcat | select-string "godot"` on powershell (Windows)

Also check out:
https://docs.godotengine.org/en/stable/tutorials/platform/android/android_plugin.html#troubleshooting
