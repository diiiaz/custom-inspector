@tool
extends CIBaseButton
class_name CIGridContainer


func set_columns(columns: int) -> CIGridContainer:
	add_build_setter(func(grid_container: GridContainer): grid_container.columns = columns)
	return self


func build(parent: Control = null) -> Control:
	var grid_container: GridContainer = GridContainer.new()
	finish_control_setup(grid_container, parent)
	return grid_container
