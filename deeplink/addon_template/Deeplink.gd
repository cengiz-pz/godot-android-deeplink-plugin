@tool
class_name Deeplink
extends Node

signal deeplink_received(url, scheme, host, path)

const PLUGIN_SINGLETON_NAME: String = "@pluginName@"

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

var _url: String
var _scheme: String
var _host: String
var _path: String


func _ready() -> void:
	_update_plugin()


func _notification(a_what: int) -> void:
	if a_what == NOTIFICATION_APPLICATION_RESUMED:
		_update_plugin()


func _update_plugin() -> void:
	if _plugin_singleton == null:
		if Engine.has_singleton(PLUGIN_SINGLETON_NAME):
			_plugin_singleton = Engine.get_singleton(PLUGIN_SINGLETON_NAME)
		else:
			printerr("%s singleton not found!" % PLUGIN_SINGLETON_NAME)

	if _plugin_singleton != null:
		_url = str(_plugin_singleton.getUrl())
		_scheme = str(_plugin_singleton.getScheme())
		_host = str(_plugin_singleton.getHost())
		_path = str(_plugin_singleton.getPath())

		_plugin_singleton.clearData()

		if (_url != null and not _url.is_empty()) or \
				(_scheme != null and not _scheme.is_empty()) or \
				(_host != null and not _host.is_empty()) or \
				(_path != null and not _path.is_empty()):
			emit_signal("deeplink_received", _url, _scheme, _host, _path)


func is_domain_associated(a_domain: String) -> bool:
	var __result = false
	if _plugin_singleton != null:
		__result = _plugin_singleton.isDomainAssociated(a_domain)
	else:
		printerr("%s plugin not initialized" % PLUGIN_SINGLETON_NAME)

	return __result


func navigate_to_open_by_default_settings() -> void:
	if _plugin_singleton != null:
		_plugin_singleton.navigateToOpenByDefaultSettings()
	else:
		printerr("%s plugin not initialized" % PLUGIN_SINGLETON_NAME)


func get_link_url() -> String:
	return _url


func get_link_scheme() -> String:
	return _scheme


func get_link_host() -> String:
	return _host


func get_link_path() -> String:
	return _path
