@tool
extends CIBaseButton
class_name CIEmptySpace


func set_minimum_size(size: Vector2) -> CIEmptySpace:
	set_minimum_size(size)
	return self


func build(parent: Control = null) -> Control:
	var control: Control = Control.new()
	finish_control_setup(control, parent)
	return control
