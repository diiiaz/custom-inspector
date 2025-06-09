@tool
extends CIBase
class_name CIControl


func build(parent: Control = null) -> Control:
	var control: Control = Control.new()
	finish_control_setup(control, parent)
	return control
