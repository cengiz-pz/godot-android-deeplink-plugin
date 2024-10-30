#
# © 2024-present https://github.com/cengiz-pz
#

tool
extends EditorPlugin

const PLUGIN_NODE_TYPE_NAME: String = "@pluginNodeName@"
const PLUGIN_PARENT_NODE_TYPE: String = "Node"
const PLUGIN_NAME: String = "@pluginName@"
const PLUGIN_VERSION: String = "@pluginVersion@"
const PLUGIN_DEPENDENCIES: Array = [ @pluginDependencies@ ]

var export_plugin: AndroidExportPlugin


func _enter_tree() -> void:
	add_custom_type(PLUGIN_NODE_TYPE_NAME, PLUGIN_PARENT_NODE_TYPE, preload("@pluginNodeName@.gd"), preload("icon.png"))
	export_plugin = AndroidExportPlugin.new()
	add_export_plugin(export_plugin)


func _exit_tree() -> void:
	remove_custom_type(PLUGIN_NODE_TYPE_NAME)
	remove_export_plugin(export_plugin)
	export_plugin = null


class AndroidExportPlugin extends EditorExportPlugin:
	var _plugin_name = PLUGIN_NAME
