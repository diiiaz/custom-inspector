extends CIPropertyController
class_name CIPropertyOptionController

var _items: Dictionary

func _init(items: Dictionary) -> void:
	_items = items

func build(parent: Control = null) -> Control:
	var option_button: OptionButton = CIOptionButton.new().setup_items(_items).build()
	option_button.select(_value)
	option_button.item_selected.connect(
		func(item_index: int):
			set_value(item_index)
	)
	finish_control_setup(option_button, parent)
	return option_button
