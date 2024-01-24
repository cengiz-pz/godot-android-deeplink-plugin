extends Node

@onready var deeplink: Deeplink = $Deeplink as Deeplink
@onready var _label: RichTextLabel = $CanvasLayer/CenterContainer/VBoxContainer/RichTextLabel as RichTextLabel
@onready var _text_edit: TextEdit = $CanvasLayer/CenterContainer/VBoxContainer/VBoxContainer/TextEdit as TextEdit


func _on_is_associated_button_pressed() -> void:
	_print_to_screen("Association for domain %s is %s" % [
		_text_edit.text,
		"valid" if deeplink.is_domain_associated(_text_edit.text) else "invalid"
		])


func _on_navigate_button_pressed() -> void:
	_print_to_screen("Navigating to 'Open by Default' settings screen")
	deeplink.navigate_to_open_by_default_settings()


func _print_to_screen(a_message: String, a_is_error: bool = false) -> void:
	_label.add_text("%s\n\n" % a_message)
	if a_is_error:
		printerr(a_message)
	else:
		print(a_message)


func _on_deeplink_deeplink_received(url, scheme, host, path) -> void:
	_print_to_screen("Deeplink received with url: %s, scheme: %s, host: %s, path: %s" % [
		url, scheme, host, path
	])
