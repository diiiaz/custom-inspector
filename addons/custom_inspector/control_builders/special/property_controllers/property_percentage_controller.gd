@tool
extends CIPropertyNumberController
class_name CIPropertyPercentageController

func _init() -> void:
	set_slider_range(0.0, 1.0, 0.01)
	set_spinbox_range(0, 100, 1)
	set_suffix("%")
	_slider_to_spinbox_callable = \
		func(slider_value: float):
			return slider_value * 100
	_spinbox_to_slider_callable = \
		func(spinbox_value: float):
			return spinbox_value / 100.0

func set_percentage_step(percentage_step: float = 1.0) -> CIPropertyPercentageController:
	set_slider_range(0.0, 1.0, 0.01 * percentage_step)
	set_spinbox_range(0, 100, percentage_step)
	return self
