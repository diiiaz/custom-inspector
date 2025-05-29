extends CIBaseButton
class_name CIOptionButton


func setup_items(enumerator: Dictionary) -> CIOptionButton:
	add_build_setter(
		func(option_button: OptionButton):
			for index: int in range(enumerator.size()):
				var key: String = enumerator.keys()[index].capitalize()
				option_button.add_item(key, index)
	)
	return self


func build() -> Control:
	var option_button: OptionButton = OptionButton.new()
	finish_control_setup(option_button)
	return option_button
