@tool
extends CIBaseButton
class_name CIGridContainer


func _init(columns: int) -> void:
	add_build_setter(func(grid_container: GridContainer): grid_container.columns = columns)


func build(parent: Control = null) -> Control:
	var grid_container: GridContainer = GridContainer.new()
	finish_control_setup(grid_container, parent)
	return grid_container
