@tool
extends CIBase
class_name CICheckbox


func set_value(value: bool) -> CICheckbox:
	add_build_setter(func(button: Button): button.button_pressed = value)
	return self

func set_toggled_callable(callable: Callable) -> CICheckbox:
	add_build_setter(func(button: Button): button.toggled.connect(callable))
	return self

func set_text(text: String) -> CICheckbox:
	add_build_setter(func(button: Button): button.set_text(text))
	return self


func build(parent: Control = null) -> Control:
	var checkbox: CheckBox = CheckBox.new()
	checkbox.text = "On"
	finish_control_setup(checkbox, parent)
	return checkbox
