extends CIPropertyController
class_name CIPropertyStringController

func build() -> Control:
	var line_edit: LineEdit = CILineEdit.new().set_text(_value).build()
	line_edit.text_submitted.connect(func(text: String): set_value(text))
	finish_control_setup(line_edit)
	return line_edit
