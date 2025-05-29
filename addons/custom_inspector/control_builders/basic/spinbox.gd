extends CIBase
class_name CISpinbox


func set_value(value: float) -> CISpinbox:
	add_build_setter(func(spinbox: SpinBox): spinbox.value = value)
	return self

func set_range(min: float, max: float, step: float) -> CISpinbox:
	add_build_setter(
		func(spinbox: SpinBox):
			if is_inf(min):
				min = 0
				spinbox.allow_lesser = true
			if is_inf(max):
				max = 1
				spinbox.allow_greater = true
			spinbox.min_value = min
			spinbox.max_value = max
			spinbox.step = step
	)
	return self


func allow_greater() -> CISpinbox:
	add_build_setter(func(spinbox: SpinBox): spinbox.allow_greater = true)
	return self

func allow_lesser() -> CISpinbox:
	add_build_setter(func(spinbox: SpinBox): spinbox.allow_lesser = true)
	return self


func set_prefix(prefix: String) -> CISpinbox:
	add_build_setter(func(spinbox: SpinBox): spinbox.prefix = prefix)
	return self

func set_suffix(suffix: String) -> CISpinbox:
	add_build_setter(func(spinbox: SpinBox): spinbox.suffix = suffix)
	return self


func remove_icons() -> CISpinbox:
	add_build_setter(
		func(spinbox: SpinBox):
			spinbox.add_theme_constant_override("field_and_buttons_separation", -16)
			var empty_texture: ImageTexture = ImageTexture.new()
			spinbox.add_theme_icon_override("down", empty_texture)
			spinbox.add_theme_icon_override("down_hover", empty_texture)
			spinbox.add_theme_icon_override("down_pressed", empty_texture)
			spinbox.add_theme_icon_override("down_disabled", empty_texture)
			spinbox.add_theme_icon_override("up", empty_texture)
			spinbox.add_theme_icon_override("up_hover", empty_texture)
			spinbox.add_theme_icon_override("up_pressed", empty_texture)
			spinbox.add_theme_icon_override("up_disabled", empty_texture)
			spinbox.add_theme_icon_override("updown", empty_texture)
	)
	return self


func build() -> Control:
	var spinbox: SpinBox = SpinBox.new()
	
	spinbox.select_all_on_focus = true
	
	finish_control_setup(spinbox)
	return spinbox
