@tool
extends CIPropertyController
class_name CIPropertyBooleanController

@export_storage var _text: String = "On"

func set_text(text: String) -> CIPropertyBooleanController:
	_text = text
	return self

func build(parent: Control = null) -> Control:
	var checkbox: CheckBox = CICheckbox.new().set_value(get_value()).set_text(_text).disable(_read_only).build()
	checkbox.toggled.connect(func(toggled: bool): set_value(toggled))
	CIPanel.new().show_behind_parent().set_mouse_filter(Control.MOUSE_FILTER_IGNORE).build(checkbox)
	finish_control_setup(checkbox, parent)
	return checkbox
