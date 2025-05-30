extends CIPropertyController
class_name CIPropertyOptionController

var _remap: Dictionary

func load_enum(enumerator: Dictionary) -> CIPropertyOptionController:
	add_build_setter(CIHelper.load_enum_items_in_option_button.bind(enumerator))
	for index: int in range(enumerator.size()):
		_remap[enumerator.values()[index]] = index
	return self

func load_string_array(array: Array[String]) -> CIPropertyOptionController:
	add_build_setter(CIHelper.load_string_array_items_in_option_button.bind(array))
	return self

func build(parent: Control = null) -> Control:
	var option_button: OptionButton = CIOptionButton.new().build()
	option_button.item_selected.connect(
		func(item_index: int):
			set_value(int(_remap.keys()[item_index]))
	)
	finish_control_setup(option_button, parent)
	option_button.select(_remap[_value])
	return option_button
