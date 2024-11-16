#
# © 2024-present https://github.com/cengiz-pz
#

@tool
class_name Deeplink extends Node

signal deeplink_received(url: DeeplinkUrl)

const PLUGIN_SINGLETON_NAME: String = "@pluginName@"

const DEEPLINK_RECEIVED_SIGNAL_NAME = "deeplink_received"

@export_category("Link")
@export var label: String = ""
@export var is_auto_verify: bool = true
@export_category("Link Category")
@export var is_default: bool = true
@export var is_browsable: bool = true
@export_category("Link Data")
@export var scheme: String = "https"
@export var host: String = ""
@export var path_prefix: String = ""

var _plugin_singleton: Object


func _ready() -> void:
	if _plugin_singleton == null:
		if Engine.has_singleton(PLUGIN_SINGLETON_NAME):
			_plugin_singleton = Engine.get_singleton(PLUGIN_SINGLETON_NAME)
			_connect_signals()
		else:
			printerr("%s singleton not found!" % PLUGIN_SINGLETON_NAME)


func _connect_signals() -> void:
	_plugin_singleton.connect(DEEPLINK_RECEIVED_SIGNAL_NAME, _on_deeplink_received)


func is_domain_associated(a_domain: String) -> bool:
	var __result = false
	if _plugin_singleton != null:
		__result = _plugin_singleton.is_domain_associated(a_domain)
	else:
		printerr("%s plugin not initialized" % PLUGIN_SINGLETON_NAME)

	return __result


func navigate_to_open_by_default_settings() -> void:
	if _plugin_singleton != null:
		_plugin_singleton.navigate_to_open_by_default_settings()
	else:
		printerr("%s plugin not initialized" % PLUGIN_SINGLETON_NAME)


func get_link_url() -> String:
	var __result = ""

	if _plugin_singleton != null:
		__result = _plugin_singleton.get_url()
	else:
		printerr("%s plugin not initialized" % PLUGIN_SINGLETON_NAME)

	return __result


func get_link_scheme() -> String:
	var __result = ""

	if _plugin_singleton != null:
		__result = _plugin_singleton.get_scheme()
	else:
		printerr("%s plugin not initialized" % PLUGIN_SINGLETON_NAME)

	return __result


func get_link_host() -> String:
	var __result = ""

	if _plugin_singleton != null:
		__result = _plugin_singleton.get_host()
	else:
		printerr("%s plugin not initialized" % PLUGIN_SINGLETON_NAME)

	return __result


func get_link_path() -> String:
	var __result = ""

	if _plugin_singleton != null:
		__result = _plugin_singleton.get_path()
	else:
		printerr("%s plugin not initialized" % PLUGIN_SINGLETON_NAME)

	return __result


func clear_data() -> void:
	if _plugin_singleton != null:
		_plugin_singleton.clear_data()
	else:
		printerr("%s plugin not initialized" % PLUGIN_SINGLETON_NAME)


func _on_deeplink_received(a_data: Dictionary) -> void:
	deeplink_received.emit(DeeplinkUrl.new(a_data))
