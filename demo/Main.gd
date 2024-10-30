#
# © 2024-present https://github.com/cengiz-pz
#

extends Node

onready var deeplink: Deeplink = $Deeplink as Deeplink
onready var _label: RichTextLabel = $CanvasLayer/CenterContainer/VBoxContainer/RichTextLabel as RichTextLabel
onready var _text_edit: TextEdit = $CanvasLayer/CenterContainer/VBoxContainer/VBoxContainer/TextEdit as TextEdit


func _ready() -> void:
	deeplink.connect("deeplink_received", self, "_on_deeplink_deeplink_received")

	# check if app link was received at startup
	var __url: String = deeplink.get_link_url()
	if __url != null and not __url.empty():
		var __deeplink_url = DeeplinkUrl.new()
		__deeplink_url.set_scheme(deeplink.get_link_scheme())
		__deeplink_url.set_host(deeplink.get_link_host())
		__deeplink_url.set_path(deeplink.get_link_path())
		_on_deeplink_deeplink_received(__deeplink_url)


func _on_check_association_button_pressed() -> void:
	_print_to_screen("Association for domain %s is %s" % [
			_text_edit.text,
			"valid" if deeplink.is_domain_associated(_text_edit.text) else "invalid"
		])


func _on_navigate_button_pressed() -> void:
	_print_to_screen("Navigating to 'Open by Default' settings screen")
	deeplink.navigate_to_open_by_default_settings()


func _on_deeplink_deeplink_received(a_url: DeeplinkUrl) -> void:
	_print_to_screen("Deeplink received with scheme: %s, host: %s, path: %s" % [
		a_url.get_scheme(), a_url.get_host(), a_url.get_path()
	])


func _print_to_screen(a_message: String, a_is_error: bool = false) -> void:
	_label.add_text("%s\n\n" % a_message)
	if a_is_error:
		printerr(a_message)
	else:
		print(a_message)
