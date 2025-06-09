@tool
extends CIPropertyController
class_name CIPropertyOptionController

@export_storage var _remap: Dictionary


func load_enum(enumerator: Dictionary) -> CIPropertyOptionController:
	add_build_setter(CIHelper.load_enum_items_in_option_button.bind(enumerator))
	for index: int in range(enumerator.size()):
		_remap[enumerator.values()[index]] = index
	return self


func build(parent: Control = null) -> Control:
	var option_button: OptionButton = CIOptionButton.new().build()
	option_button.item_selected.connect(
		func(item_index: int):
			set_value(int(_remap.keys()[item_index]))
	)
	finish_control_setup(option_button, parent)
	option_button.select(_remap[get_value()])
	return option_button
