extends CIBase
class_name CIPropertyContainer

var _binder_object: Object = null
var _binder_property_name: String = ""
var _property_name_override: String = ""
var _controller: CIPropertyController = null
var _inline: bool = true

var _property_panel: PanelContainer
var _status_label: RichTextLabel

var _statuses: Array[CIPropertyStatus] = []


func _init(object: Object, property_name: String, inline: bool = true, property_name_override: String = "") -> void:
	_binder_object = object
	_binder_property_name = property_name
	if _controller == null:
		_controller = _auto_get_controller(object, property_name)
	_inline = inline
	if property_name_override != "":
		_property_name_override = property_name_override


func _auto_get_controller(object: Object, property_name: String) -> CIPropertyController:
	match typeof(object.get(property_name)):
		TYPE_INT: return CIPropertyNumberController.new().set_range(-INF, INF, 1)
		TYPE_FLOAT: return CIPropertyNumberController.new().set_range(-INF, INF, 0.01)
		TYPE_STRING: return CIPropertyStringController.new()
		TYPE_BOOL: return CIPropertyBooleanController.new()
		TYPE_VECTOR2: return CIPropertyVectorController.new()
		TYPE_COLOR: return CIPropertyColorController.new()
	return null


func set_controller(controller: CIPropertyController) -> CIPropertyContainer:
	_controller = controller
	return self


func build(parent: Control = null) -> Control:
	add_status(CIStatusTemplate.create_error("Property \"%s\" does not exist." % [_binder_property_name]).set_status_checker(func(): return _binder_property_name not in _binder_object))
	add_status(CIStatusTemplate.create_error("Controller does not exist or is not valid.").set_status_checker(func(): return  _controller == null))
	
	var stylebox: StyleBoxFlat = editor_theme.get_stylebox("panel", "Panel").duplicate()
	stylebox.set_content_margin_all(0)
	stylebox.set_border_width_all(1)
	
	_property_panel = CIPanel.new().set_panel(stylebox).build()
	var vbox: VBoxContainer = CIVBoxContainer.new().build(_property_panel)
	
	_status_label = CIRichLabel.new().set_text("tyest").build(vbox)
	
	var property: BoxContainer = CIBoxContainer.new().set_orientation(CIConstants.ORIENTATION.HORIZONTAL if _inline else CIConstants.ORIENTATION.VERTICAL).build(vbox)
	
	CILabel.new().set_text(_binder_property_name.capitalize() if _property_name_override.is_empty() else _property_name_override).build(property)
	
	if _controller != null:
		_controller.bind_to_property(_binder_object, _binder_property_name).build(property)
		add_statuses(_controller._statuses)
	
	update_statuses()
	finish_control_setup(_property_panel, parent)
	return _property_panel


# x-----------------------------------------------------------x Statuses

func add_status(status: CIPropertyStatus) -> CIPropertyContainer:
	_statuses.append(status)
	return self

func add_statuses(statuses: Array[CIPropertyStatus]) -> CIPropertyContainer:
	_statuses.append_array(statuses)
	return self

func get_statuses() -> Array[CIPropertyStatus]:
	var valid_statuses: Array[CIPropertyStatus] = []
	for status: CIPropertyStatus in _statuses:
		if status.is_valid():
			valid_statuses.append(status)
	valid_statuses.sort_custom(CIPropertyStatus.sort_function)
	return valid_statuses

func update_statuses() -> void:
	var statuses: Array[CIPropertyStatus] = get_statuses()
	var has_statuses: bool = not statuses.is_empty()
	_property_panel.self_modulate.a = 1.0 if has_statuses else 0.0
	
	_status_label.visible = has_statuses
	
	var stylebox: StyleBoxFlat = _property_panel.get("theme_override_styles/panel")
	stylebox.set_content_margin_all(6 if has_statuses else 0)
	
	if has_statuses:
		var status: CIPropertyStatus = statuses[0]
		stylebox.bg_color = status.get_color() * Color(1, 1, 1, 0.15)
		stylebox.border_color = status.get_color()
		var text_color: Color = status.get_color()
		text_color.ok_hsl_l = 0.7
		_status_label.text = "[color={color}]".format({"color": text_color.to_html(false)}) + status.get_string() + "\n"
