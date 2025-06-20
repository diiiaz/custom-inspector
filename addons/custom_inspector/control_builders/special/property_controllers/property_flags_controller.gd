@tool
extends CIPropertyController
class_name CIPropertyFlagsController

@export_storage var _flags: int = 0
@export_storage var _string_flags: PackedStringArray


func load_enum(enumerator: Dictionary) -> CIPropertyFlagsController:
	_string_flags.clear()
	for flag_index: int in range(enumerator.size()):
		_string_flags.append(enumerator.keys()[flag_index])
	return self


func build(parent: Control = null) -> Control:
	_flags = get_value()
	var panel: PanelContainer = CIPanel.new().build()
	var vbox: VBoxContainer = CIVBoxContainer.new().build(panel)
	
	for flag_index: int in range(_string_flags.size()):
		var checkbox: CheckBox = CICheckbox.new().set_text(_string_flags[flag_index].capitalize()).disable(_read_only).build(vbox)
		checkbox.button_pressed = is_flag_set(flag_index)
		checkbox.toggled.connect(
			func(toggled: bool):
				if toggled:
					_flags |= (1 << flag_index)
				else:
					_flags &= ~(1 << flag_index)
				set_value(_flags)
		)
	
	finish_control_setup(panel, parent)
	return panel


func is_flag_set(index: int) -> bool:
	return (_flags & (1 << index)) != 0
