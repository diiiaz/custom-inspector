@tool
extends CIPropertyController
class_name CIPropertyVectorController

@export_storage var _min: float = -INF
@export_storage var _max: float = INF
@export_storage var _step: float = 0.1


func set_range(min: float, max: float, step: float) -> CIPropertyVectorController:
	_min = min
	_max = max
	_step = step
	return self


func build(parent: Control = null) -> Control:
	var hbox: HBoxContainer = CIHBoxContainer.new().build()
	
	var x_number_controller: SpinBox = CIPropertyNumberController.new().set_object(_object) \
		.read_only(_read_only) \
		.set_range(_min, _max, _step) \
		.set_setter(func(new_value): set_value(Vector2(new_value, get_value().y))) \
		.set_getter(func(): return get_value().x) \
		.build(hbox)
	
	var y_number_controller: SpinBox = CIPropertyNumberController.new().set_object(_object) \
		.read_only(_read_only) \
		.set_range(_min, _max, _step) \
		.set_setter(func(new_value): set_value(Vector2(get_value().x, new_value))) \
		.set_getter(func(): return get_value().y) \
		.build(hbox)
	
	var spinbox_stylebox: StyleBox = x_number_controller.get_line_edit().get("theme_override_styles/normal").duplicate()
	spinbox_stylebox.content_margin_left += 8
	
	x_number_controller.get_line_edit().add_theme_stylebox_override("normal", spinbox_stylebox)
	y_number_controller.get_line_edit().add_theme_stylebox_override("normal", spinbox_stylebox)
	
	
	var x_label: RichTextLabel = CIRichLabel.new() \
		.set_text("[color={color}]x[/color]".format({"color": editor_theme.get_color("property_color_x", "Editor").to_html()})) \
		.set_mouse_filter(Control.MOUSE_FILTER_IGNORE) \
		.set_v_alignment(VERTICAL_ALIGNMENT_CENTER) \
		.build(x_number_controller)
	
	var y_label: RichTextLabel = CIRichLabel.new() \
		.set_text("[color={color}]y[/color]".format({"color": editor_theme.get_color("property_color_y", "Editor").to_html()})) \
		.set_mouse_filter(Control.MOUSE_FILTER_IGNORE) \
		.set_v_alignment(VERTICAL_ALIGNMENT_CENTER) \
		.build(y_number_controller)
	
	var label_stylebox: StyleBoxEmpty = StyleBoxEmpty.new()
	label_stylebox.content_margin_left = 8
	
	x_label.add_theme_stylebox_override("normal", label_stylebox)
	y_label.add_theme_stylebox_override("normal", label_stylebox)
	
	finish_control_setup(hbox, parent)
	return hbox
