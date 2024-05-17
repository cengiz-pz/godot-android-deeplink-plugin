#
# © 2024-present https://github.com/cengiz-pz
#

extends Node

@onready var deeplink: Deeplink = $Deeplink as Deeplink
@onready var _label: RichTextLabel = $CanvasLayer/CenterContainer/VBoxContainer/RichTextLabel as RichTextLabel
@onready var _text_edit: TextEdit = $CanvasLayer/CenterContainer/VBoxContainer/VBoxContainer/TextEdit as TextEdit


func _ready() -> void:
	if not deeplink.host.is_empty():
		_text_edit.text = deeplink.host

	# check if app link was received at startup
	var __url: String = deeplink.get_link_url()
	if __url != null and not __url.is_empty():
		_on_deeplink_deeplink_received(__url, deeplink.get_link_scheme(), deeplink.get_link_host(),
					deeplink.get_link_path())

func _on_is_associated_button_pressed() -> void:
	_print_to_screen("Association for domain %s is %s" % [
			_text_edit.text,
			"valid" if deeplink.is_domain_associated(_text_edit.text) else "invalid"
		])


func _on_navigate_button_pressed() -> void:
	_print_to_screen("Navigating to 'Open by Default' settings screen")
	deeplink.navigate_to_open_by_default_settings()


func _on_deeplink_deeplink_received(url: String, scheme: String, host: String, path: String) -> void:
	_print_to_screen("Deeplink received with url: %s, scheme: %s, host: %s, path: %s" % [
		url, scheme, host, path
	])


func _print_to_screen(a_message: String, a_is_error: bool = false) -> void:
	_label.add_text("%s\n\n" % a_message)
	if a_is_error:
		printerr(a_message)
	else:
		print(a_message)
