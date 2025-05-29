extends CIBase
class_name CIPropertyContainer


var _binder_object: Object = null
var _binder_property_name: String = ""
var _property_name_override: String = ""
var _controller: CIPropertyController = null
var _inline: bool = true
func _init(object: Object, property_name: String, inline: bool = true, property_name_override: String = "") -> void:
	_binder_object = object
	_binder_property_name = property_name
	if _controller == null:
		_controller = auto_get_controller(object, property_name)
	_inline = inline
	if property_name_override != "":
		_property_name_override = property_name_override


func auto_get_controller(object: Object, property_name: String) -> CIPropertyController:
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


func _get_property_name() -> String:
	return _binder_property_name.capitalize() if _property_name_override.is_empty() else _property_name_override


var _property_panel: PanelContainer
var _status_label: RichTextLabel
func build(parent: Control = null) -> Control:
	if _binder_property_name not in _binder_object:
		add_status(CIPropertyStatus.template(CIPropertyStatus.TEMPLATE.ERROR).set_text("Property \"%s\" does not exist." % [_binder_property_name]).set_severity(0))
	if _controller == null:
		add_status(CIPropertyStatus.template(CIPropertyStatus.TEMPLATE.ERROR).set_text("Controller does not exist or is not valid.").set_severity(1))
	
	var stylebox: StyleBoxFlat = editor_theme.get_stylebox("panel", "Panel").duplicate()
	stylebox.set_content_margin_all(0)
	stylebox.set_border_width_all(1)
	
	_property_panel = CIPanel.new().set_panel(stylebox).build()
	var vbox: VBoxContainer = CIVBoxContainer.new().build(_property_panel)
	
	_status_label = CIRichLabel.new().set_text("tyest").build(vbox)
	
	var property: BoxContainer = CIBoxContainer.new().set_orientation(CIConstants.ORIENTATION.HORIZONTAL if _inline else CIConstants.ORIENTATION.VERTICAL).build(vbox)
	
	CILabel.new().set_text(_get_property_name()).build(property)
	
	if _controller != null:
		_controller.bind_to_property(_binder_object, _binder_property_name).build(property)
	
	update_statuses()
	finish_control_setup(_property_panel, parent)
	return _property_panel


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


# x-----------------------------------------------------------x Statuses

static func ALWAYS_TRUE() -> bool: return true

var _statuses: Array[CIPropertyStatus] = []

func add_status(status: CIPropertyStatus) -> CIPropertyContainer:
	_statuses.append(status)
	return self

func get_statuses() -> Array[CIPropertyStatus]:
	var valid_statuses: Array[CIPropertyStatus] = []
	for status: CIPropertyStatus in _statuses:
		if status.is_valid():
			valid_statuses.append(status)
	valid_statuses.sort_custom(_sort_statuses)
	return valid_statuses

static func _sort_statuses(a: CIPropertyStatus, b: CIPropertyStatus) -> bool:
	if a._severity == b._severity:
		return a._status_string < b._status_string
	return a._severity < b._severity


func add_error(text: String, checker: Callable = ALWAYS_TRUE) -> CIPropertyContainer:
	add_status(CIPropertyStatus.template(CIPropertyStatus.TEMPLATE.ERROR).set_text(text).set_status_checker(checker))
	return self

func add_warning(text: String, checker: Callable = ALWAYS_TRUE) -> CIPropertyContainer:
	add_status(CIPropertyStatus.template(CIPropertyStatus.TEMPLATE.WARNING).set_text(text).set_status_checker(checker))
	return self

func add_info(text: String, checker: Callable = ALWAYS_TRUE) -> CIPropertyContainer:
	add_status(CIPropertyStatus.template(CIPropertyStatus.TEMPLATE.INFO).set_text(text).set_status_checker(checker))
	return self


class CIPropertyStatus extends RefCounted:
	@export_storage var _color: Color = Color.WHITE
	@export_storage var _status_string: String = ""
	@export_storage var _status_checker: Callable = CIPropertyContainer.ALWAYS_TRUE
	@export_storage var _severity: int = 0
	@export_storage var _prefix: String = ""
	
	enum TEMPLATE {
		ERROR,
		WARNING,
		INFO
	}
	
	func _init(status_string: String = "") -> void:
		_status_string = status_string
	
	func set_text(text: String) -> CIPropertyStatus:
		_status_string = text
		return self
	
	func set_prefix(prefix: String) -> CIPropertyStatus:
		_prefix = prefix
		return self
	
	func set_status_checker(checker_callable: Callable) -> CIPropertyStatus:
		_status_checker = checker_callable
		return self
	
	func set_color(color: Color) -> CIPropertyStatus:
		_color = color
		return self
	
	func set_severity(severity: int) -> CIPropertyStatus:
		_severity = severity
		return self
	
	func get_string() -> String:
		return "" if _status_checker.call() == false else _prefix + _status_string
	
	func get_color() -> Color:
		return _color
	
	func is_valid() -> bool:
		return _status_checker.call()
	
	static func template(template: TEMPLATE) -> CIPropertyStatus:
		return _get_template(template)
	
	static func _get_template(template: TEMPLATE) -> CIPropertyStatus:
		match template:
			TEMPLATE.ERROR: return CIPropertyStatus.new().set_color(Color.from_ok_hsl(0.085, 1.0, 0.5)).set_severity(2).set_prefix("● [b]ERROR:[/b] ")
			TEMPLATE.WARNING: return CIPropertyStatus.new().set_color(Color.from_ok_hsl(0.15, 1.0, 0.5)).set_severity(1).set_prefix("● [b]WARNING:[/b] ")
			TEMPLATE.INFO: return CIPropertyStatus.new().set_color(Color.from_ok_hsl(0.8, 1.0, 0.5)).set_severity(0).set_prefix("● [b]INFO:[/b] ")
		return null
