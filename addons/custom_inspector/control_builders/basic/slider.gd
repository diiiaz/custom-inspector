extends CIBase
class_name CISlider

var _orientation: CIConstants.ORIENTATION

func set_value(value: float) -> CISlider:
	add_build_setter(func(slider: Slider): slider.value = value)
	return self

func set_range(min: float, max: float, step: float) -> CISlider:
	add_build_setter(
		func(slider: Slider):
			slider.min_value = min
			slider.max_value = max
			slider.step = step
	)
	return self

func set_orientation(orientation: CIConstants.ORIENTATION) -> CISlider:
	_orientation = orientation
	return self


func build() -> Control:
	var slider: Slider = HSlider.new() if _orientation == CIConstants.ORIENTATION.HORIZONTAL else VSlider.new()
	finish_control_setup(slider)
	return slider
