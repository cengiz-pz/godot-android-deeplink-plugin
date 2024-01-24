@tool
extends EditorPlugin

const PLUGIN_NODE_TYPE_NAME: String = "Deeplink"
const PLUGIN_PARENT_NODE_TYPE: String = "Node"
const PLUGIN_NAME: String = "@pluginName@"
const PLUGIN_VERSION: String = "@pluginVersion@"

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
		return PackedStringArray([
			"androidx.annotation:annotation:1.7.1"
		])


	func _get_android_manifest_activity_element_contents(platform: EditorExportPlatform, debug: bool) -> String:
		var __contents: String = ""

		var __deeplink_nodes: Array = _get_deeplink_nodes(EditorInterface.get_edited_scene_root())

		for __node in __deeplink_nodes:
			var __deeplink_node = __node as Deeplink
			if __deeplink_node.is_auto_verify:
				__contents += "<intent-filter android:label=\"%s\" android:autoVerify=\"true\">\n" % __deeplink_node.label
			else:
				__contents += "<intent-filter android:label=\"%s\">\n" % __deeplink_node.label
			__contents += "\t<action android:name=\"android.intent.action.VIEW\" />\n"
			if __deeplink_node.is_default:
				__contents += "\t<category android:name=\"android.intent.category.DEFAULT\" />\n"
			if __deeplink_node.is_browsable:
				__contents += "\t<category android:name=\"android.intent.category.BROWSABLE\" />\n"
			__contents += "\t<data android:scheme=\"%s\" android:host=\"%s\" android:pathPrefix=\"%s\" />\n" % [__deeplink_node.scheme, __deeplink_node.host, __deeplink_node.path_prefix]
			__contents += "</intent-filter>\n"

		return __contents


	func _get_deeplink_nodes(a_node: Node) -> Array:
		var __result: Array = []

		if a_node is Deeplink:
			__result.append(a_node)

		if a_node.get_child_count() > 0:
			for __child in a_node.get_children():
				__result.append_array(_get_deeplink_nodes(__child))

		return __result
