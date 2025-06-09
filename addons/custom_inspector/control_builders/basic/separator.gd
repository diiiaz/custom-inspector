@tool
extends CIBase
class_name CISeparator

@export_storage var _orientation: CIConstants.ORIENTATION

func set_orientation(orientation: CIConstants.ORIENTATION):
	_orientation = orientation
	return self

func set_separation(separation: int):
	add_build_setter(func(separator: Separator): separator.add_theme_constant_override("separation", separation))
	return self

func build(parent: Control = null) -> Control:
	var separator: Separator = HSeparator.new() if _orientation == CIConstants.ORIENTATION.HORIZONTAL else VSeparator.new()
	finish_control_setup(separator, parent)
	return separator
