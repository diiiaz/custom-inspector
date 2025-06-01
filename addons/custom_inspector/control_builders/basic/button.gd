extends CIBaseButton
class_name CIButton


func set_text(text: String) -> CIButton:
	add_build_setter(func(button: Button): button.set_text(text))
	return self

func set_icon(icon: String) -> CIButton:
	add_build_setter(func(button: Button): button.set_button_icon(CIHelper.get_icon(icon)))
	return self

func set_flat() -> CIButton:
	add_build_setter(func(button: Button): button.flat = true)
	return self

func build(parent: Control = null) -> Control:
	var button: Button = Button.new()
	finish_control_setup(button, parent)
	return button
