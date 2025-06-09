@tool
extends CIBase
class_name CIBoxContainer

var _orientation: CIConstants.ORIENTATION

func set_orientation(orientation: CIConstants.ORIENTATION):
	_orientation = orientation
	return self

func set_separation(separation: int):
	add_build_setter(func(box_container: BoxContainer): box_container.add_theme_constant_override("separation", separation))
	return self

func set_alignment(alignment: BoxContainer.AlignmentMode):
	add_build_setter(func(box_container: BoxContainer): box_container.set_alignment(alignment))
	return self

func build(parent: Control = null) -> Control:
	var box_container: BoxContainer = HBoxContainer.new() if _orientation == CIConstants.ORIENTATION.HORIZONTAL else VBoxContainer.new()
	finish_control_setup(box_container, parent)
	return box_container
