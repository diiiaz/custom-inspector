@tool
extends CIPropertyNumberController
class_name CIPropertyPercentageController

func _init() -> void:
	set_as_percentage_controller()

func set_percentage_step(percentage_step: float = 1.0) -> CIPropertyPercentageController:
	set_slider_range(0.0, 1.0, 0.01 * percentage_step)
	set_spinbox_range(0, 100, percentage_step)
	return self
