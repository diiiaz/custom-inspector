extends CIPropertyController
class_name CIPropertyBooleanController

var _text: String = "On"
func set_text(text: String) -> CIPropertyBooleanController:
	_text = text
	return self

func build() -> Control:
	var checkbox: CheckBox = CICheckbox.new().set_value(_value).set_text(_text).build()
	checkbox.toggled.connect(func(toggled: bool): set_value(toggled))
	checkbox.add_child(CIPanel.new().show_behind_parent().set_mouse_filter(Control.MOUSE_FILTER_IGNORE).build())
	finish_control_setup(checkbox)
	return checkbox
