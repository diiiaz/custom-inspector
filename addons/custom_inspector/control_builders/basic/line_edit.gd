extends CIBase
class_name CILineEdit

func set_text(text: String) -> CILineEdit:
	add_build_setter(func(line_edit: LineEdit): line_edit.set_text(text))
	return self

func set_placeholder_text(text: String) -> CILineEdit:
	add_build_setter(func(line_edit: LineEdit): line_edit.placeholder_text = text)
	return self

func build(parent: Control = null) -> Control:
	var line_edit: LineEdit = LineEdit.new()
	finish_control_setup(line_edit, parent)
	return line_edit
