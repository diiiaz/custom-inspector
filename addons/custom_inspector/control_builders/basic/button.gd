extends CIBaseButton
class_name CIButton

const Helper = preload("res://addons/custom_inspector/helper.gd")


func set_text(text: String) -> CIButton:
	add_build_setter(func(button: Button): button.set_text(text))
	return self

func set_icon(icon: String) -> CIButton:
	add_build_setter(func(button: Button): button.set_button_icon(Helper.get_icon(icon)))
	return self

func build() -> Control:
	var button: Button = Button.new()
	finish_control_setup(button)
	return button
