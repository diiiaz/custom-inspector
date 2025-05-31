extends CIBaseButton
class_name CIEmptySpace


func _init(size: Vector2) -> void:
	set_minimum_size(size)


func build(parent: Control = null) -> Control:
	var control: Control = Control.new()
	finish_control_setup(control, parent)
	return control
