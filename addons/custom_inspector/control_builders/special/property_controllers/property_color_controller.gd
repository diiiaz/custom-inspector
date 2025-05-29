extends CIPropertyController
class_name CIPropertyColorController

func build(parent: Control = null) -> Control:
	var color_picker_button: ColorPickerButton = ColorPickerButton.new()
	color_picker_button.color = _value
	
	var stylebox: StyleBox = editor_theme.get_stylebox("child_bg", "EditorProperty").duplicate()
	stylebox.set_content_margin_all(6)
	
	color_picker_button.add_theme_stylebox_override("normal", stylebox)
	color_picker_button.popup_closed.connect(func(): set_value(color_picker_button.color))
	
	finish_control_setup(color_picker_button, parent)
	return color_picker_button
