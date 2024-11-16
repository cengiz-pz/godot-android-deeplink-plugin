#
# © 2024-present https://github.com/cengiz-pz
#

@tool
extends EditorPlugin

const PLUGIN_NODE_TYPE_NAME: String = "Deeplink"
const PLUGIN_PARENT_NODE_TYPE: String = "Node"
const PLUGIN_NAME: String = "@pluginName@"
const PLUGIN_VERSION: String = "@pluginVersion@"
const PLUGIN_DEPENDENCIES: Array = [ @pluginDependencies@ ]

var export_plugin: AndroidExportPlugin


func _enter_tree() -> void:
	add_custom_type(PLUGIN_NODE_TYPE_NAME, PLUGIN_PARENT_NODE_TYPE, preload("Deeplink.gd"), preload("icon.png"))
	export_plugin = AndroidExportPlugin.new()
	add_export_plugin(export_plugin)


func _exit_tree() -> void:
	remove_custom_type(PLUGIN_NODE_TYPE_NAME)
	remove_export_plugin(export_plugin)
	export_plugin = null


class AndroidExportPlugin extends EditorExportPlugin:
	var _plugin_name = PLUGIN_NAME

	const DEEPLINK_ACTIVITY_FORMAT = """
		<activity
			android:name="org.godotengine.plugin.android.deeplink.DeeplinkActivity"
			android:theme="@android:style/Theme.Translucent.NoTitleBar.Fullscreen"
			android:excludeFromRecents="true"
			android:launchMode="singleTask"
			android:exported="true"
			android:noHistory="true">

			%s
		</activity>
"""

	const DEEPLINK_INTENT_FILTER_FORMAT = """
			<intent-filter android:label="%s" %s>
				<action android:name="android.intent.action.VIEW" />
				%s
				%s
				<data android:scheme="%s"
					android:host="%s"
					android:pathPrefix="%s" />
			</intent-filter>
"""

	const DEEPLINK_INTENT_FILTER_AUTO_VERIFY_PROPERTY = "android:autoVerify=\"true\""
	const DEEPLINK_INTENT_FILTER_DEFAULT_CATEGORY = "<category android:name=\"android.intent.category.DEFAULT\" />"
	const DEEPLINK_INTENT_FILTER_BROWSABLE_CATEGORY = "<category android:name=\"android.intent.category.BROWSABLE\" />"


	func _supports_platform(platform: EditorExportPlatform) -> bool:
		if platform is EditorExportPlatformAndroid:
			return true
		return false


	func _get_android_libraries(platform: EditorExportPlatform, debug: bool) -> PackedStringArray:
		if debug:
			return PackedStringArray(["%s/bin/debug/%s-%s-debug.aar" % [_plugin_name, _plugin_name, PLUGIN_VERSION]])
		else:
			return PackedStringArray(["%s/bin/release/%s-%s-release.aar" % [_plugin_name, _plugin_name, PLUGIN_VERSION]])


	func _get_name() -> String:
		return _plugin_name


	func _get_android_dependencies(platform: EditorExportPlatform, debug: bool) -> PackedStringArray:
		return PackedStringArray(PLUGIN_DEPENDENCIES)


	func _get_android_manifest_application_element_contents(platform: EditorExportPlatform, debug: bool) -> String:
		var __filters: String = ""

		var __deeplink_nodes: Array = _get_deeplink_nodes(EditorInterface.get_edited_scene_root())

		for __node in __deeplink_nodes:
			var __deeplink_node = __node as Deeplink
			__filters += DEEPLINK_INTENT_FILTER_FORMAT % [
						__deeplink_node.label,
						DEEPLINK_INTENT_FILTER_AUTO_VERIFY_PROPERTY if __deeplink_node.is_auto_verify else "",
						DEEPLINK_INTENT_FILTER_DEFAULT_CATEGORY if __deeplink_node.is_default else "",
						DEEPLINK_INTENT_FILTER_BROWSABLE_CATEGORY if __deeplink_node.is_browsable else "",
						__deeplink_node.scheme,
						__deeplink_node.host,
						__deeplink_node.path_prefix
					]

		return DEEPLINK_ACTIVITY_FORMAT % __filters


	func _get_deeplink_nodes(a_node: Node) -> Array:
		var __result: Array = []

		if a_node is Deeplink:
			__result.append(a_node)

		if a_node.get_child_count() > 0:
			for __child in a_node.get_children():
				__result.append_array(_get_deeplink_nodes(__child))

		return __result
