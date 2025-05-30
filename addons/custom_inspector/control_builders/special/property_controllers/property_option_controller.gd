extends CIPropertyController
class_name CIPropertyOptionController

var _items: Dictionary

func load_enum(enumerator: Dictionary) -> CIPropertyOptionController:
	add_build_setter(CIHelper.load_enum_items_in_option_button.bind(enumerator))
	return self

func build(parent: Control = null) -> Control:
	var option_button: OptionButton = CIOptionButton.new().build()
	option_button.select(_value)
	option_button.item_selected.connect(
		func(item_index: int):
			set_value(item_index)
	)
	finish_control_setup(option_button, parent)
	return option_button
