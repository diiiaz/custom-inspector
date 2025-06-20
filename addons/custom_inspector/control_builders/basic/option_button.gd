@tool
extends CIBaseButton
class_name CIOptionButton


func load_enum(enumerator: Dictionary) -> CIOptionButton:
	add_build_setter(CIHelper.load_enum_items_in_option_button.bind(enumerator))
	return self

func load_string_array(array: Array[String]) -> CIOptionButton:
	add_build_setter(CIHelper.load_string_array_items_in_option_button.bind(array))
	return self

func build(parent: Control = null) -> Control:
	var option_button: OptionButton = OptionButton.new()
	finish_control_setup(option_button, parent)
	return option_button
