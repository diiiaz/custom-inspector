extends CIPropertyController
class_name CIPropertyFlagsController

var _flags: int = 0
var _string_flags: PackedStringArray

func _init(string_array: PackedStringArray) -> void:
	_string_flags = string_array


func build() -> Control:
	_flags = _value
	var panel: PanelContainer = CIPanel.new().build()
	var vbox: VBoxContainer = CIVBoxContainer.new().build()
	panel.add_child(vbox)
	
	for flag_index: int in range(_string_flags.size()):
		var checkbox: CheckBox = CICheckbox.new().set_text(_string_flags[flag_index].capitalize()).build()
		vbox.add_child(checkbox)
		checkbox.button_pressed = is_flag_set(flag_index)
		checkbox.toggled.connect(
			func(toggled: bool):
				if toggled:
					_flags |= (1 << flag_index)
				else:
					_flags &= ~(1 << flag_index)
				set_value(_flags)
		)
	
	finish_control_setup(panel)
	return panel


func is_flag_set(index: int) -> bool:
	return (_flags & (1 << index)) != 0
