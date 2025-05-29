extends CIPropertyController
class_name CIPropertyNumberController

var _slider_to_spinbox_callable: Callable = \
	func(value: float):
		return value
var _spinbox_to_slider_callable: Callable = \
	func(value: float):
		return value

var _spinbox: SpinBox = null
var _slider: Slider = null
var _allow_greater: bool = false
var _allow_lesser: bool = false


var _prefix: String = ""
func set_prefix(prefix: String) -> CIPropertyNumberController:
	_prefix = prefix
	return self

var _suffix: String = ""
func set_suffix(suffix: String) -> CIPropertyNumberController:
	_suffix = suffix
	return self


var _hide_slider: bool = false
func hide_slider() -> CIPropertyNumberController:
	_hide_slider = true
	return self


var _spinbox_min: float = 0.0
var _spinbox_max: float = 100.0
var _spinbox_step: float = 0.1
func set_spinbox_range(min: float, max: float, step: float) -> CIPropertyNumberController:
	if is_inf(min):_allow_lesser = true
	if is_inf(max):_allow_greater = true
	_spinbox_min = min
	_spinbox_max = max
	_spinbox_step = step
	return self

var _slider_min: float = 0.0
var _slider_max: float = 100.0
var _slider_step: float = 0.1
func set_slider_range(min: float, max: float, step: float) -> CIPropertyNumberController:
	if is_inf(min):_allow_lesser = true
	if is_inf(max):_allow_greater = true
	_slider_min = min
	_slider_max = max
	_slider_step = step
	return self

func set_range(min: float, max: float, step: float) -> CIPropertyNumberController:
	set_spinbox_range(min, max, step)
	set_slider_range(min, max, step)
	return self


func set_as_percentage_controller(percentage_step: float = 1) -> CIPropertyNumberController:
	set_slider_range(0.0, 1.0, 0.01 * percentage_step)
	set_spinbox_range(0, 100, percentage_step)
	set_suffix("%")
	_slider_to_spinbox_callable = \
		func(slider_value: float):
			return slider_value * 100
	_spinbox_to_slider_callable = \
		func(spinbox_value: float):
			return spinbox_value / 100.0
	return self


func build(parent: Control = null) -> Control:
	# main controls builders
	if not (_hide_slider or _allow_greater or _allow_lesser):
		_slider = _create_slider()
	_spinbox = _create_spinbox()
	
	# signals
	if _value_changed_callback != Callable():
		_spinbox.get_line_edit().text_submitted.connect(
			func(text_number: String):
				if text_number.is_empty():
					_spinbox.value = 0
					text_number = "0"
				var unclamped_value: float = _spinbox_to_slider_callable.call(snappedf(text_number.to_float(), _spinbox_step))
				var clamped_value: float = clampf(unclamped_value, _slider_min, _slider_max)
				set_value(clamped_value))
		if _slider != null:
			_slider.drag_ended.connect(
				func(value: float):
					var final_value: float = snappedf(_slider.get_value(), _slider_step)
					set_value(final_value))
	
	if _slider != null:
		_spinbox.get_line_edit().text_submitted.connect(func(text_number: String): _slider.value = _spinbox_to_slider_callable.call(text_number.to_float()))
		_slider.drag_ended.connect(func(_v): _slider.release_focus())
		_slider.value_changed.connect(
			func(value: float):
				var final_value: float = snappedf(_slider.get_value(), _slider_step)
				_spinbox.value = _slider_to_spinbox_callable.call(final_value))
	
	finish_control_setup(_spinbox, parent)
	return _spinbox


func _create_spinbox() -> SpinBox:
	var spinbox_builder = CISpinbox.new() \
		.set_range(_spinbox_min, _spinbox_max, _spinbox_step) \
		.set_value(_slider_to_spinbox_callable.call(_value)) \
		.set_prefix(_prefix) \
		.set_suffix(_suffix) \
		.remove_icons()
	if _allow_greater:
		spinbox_builder.allow_greater()
	if _allow_lesser:
		spinbox_builder.allow_lesser()
	_spinbox = spinbox_builder.build()
	var spinbox_panel: StyleBox = CIPanel.default_panel.duplicate()
	_spinbox.get_line_edit().add_theme_stylebox_override("normal", spinbox_panel)
	spinbox_panel.content_margin_left = 18
	spinbox_panel.content_margin_top = 0
	
	var spinbox_margin: MarginContainer = CIMarginContainer.new() \
		.set_margin(CIConstants.DIRECTION.TOP, 16) \
		.set_margin(CIConstants.DIRECTION.BOTTOM, 0) \
		.set_margin(CIConstants.DIRECTION.LEFT, 12) \
		.set_margin(CIConstants.DIRECTION.RIGHT, 12) \
		.set_mouse_filter(Control.MOUSE_FILTER_IGNORE) \
		.build(_spinbox)
	
	if _slider != null:
		_spinbox.get_line_edit().editing_toggled.connect(
			func(toggle: bool):
				spinbox_margin.visible = not toggle
				spinbox_panel.content_margin_top = 0 if not toggle else 6
		)
	else:
		spinbox_panel.content_margin_top = 0
		spinbox_panel.content_margin_bottom = 0
	
	if _slider != null:
		spinbox_margin.add_child(_slider)
	
	return _spinbox


func _create_slider() -> Slider:
	_slider = CIHSlider.new().set_range(_slider_min, _slider_max, _slider_step).set_value(_value).build()
	
	var slider_theme_style_slider: StyleBoxLine = StyleBoxLine.new()
	slider_theme_style_slider.color = CIBase.editor_theme.get_color("label_color", "EditorSpinSlider") * Color(1, 1, 1, 0.2)
	slider_theme_style_slider.thickness = 2
	_slider.add_theme_stylebox_override("slider", slider_theme_style_slider)
	
	var slider_theme_style_grabber_area: StyleBoxLine = StyleBoxLine.new()
	slider_theme_style_grabber_area.color = CIBase.editor_theme.get_color("label_color", "EditorSpinSlider") * Color(1, 1, 1, 0.5)
	slider_theme_style_grabber_area.thickness = 2
	_slider.add_theme_stylebox_override("grabber_area", slider_theme_style_grabber_area)
	_slider.add_theme_stylebox_override("grabber_area_highlight", slider_theme_style_grabber_area)

	var slider_theme_icon_grabber: Texture2D = CIHelper.get_icon("GuiScrollGrabberHl")
	_slider.add_theme_icon_override("grabber", slider_theme_icon_grabber)
	_slider.add_theme_icon_override("grabber_highlight", CIHelper.get_icon("GuiSliderGrabber"))
	_slider.add_theme_constant_override("center_grabber", 1)
	
	return _slider
