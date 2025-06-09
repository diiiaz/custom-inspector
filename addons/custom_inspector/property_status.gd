@tool
extends RefCounted
class_name CIPropertyStatus 

static func ALWAYS_TRUE() -> bool: return true

@export_storage var _color: Color = Color.WHITE
@export_storage var _status_string: String = ""
@export_storage var _status_checker: Callable = ALWAYS_TRUE
@export_storage var _severity: int = 0
@export_storage var _global_severity: int = 0
@export_storage var _prefix: String = ""

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

func set_global_severity(severity: int) -> CIPropertyStatus:
	_global_severity = severity
	return self

func get_string() -> String: return "" if _status_checker.call() == false else _prefix + _status_string
func get_color() -> Color: return _color
func is_valid() -> bool: return _status_checker.call()


static func sort_function(a: CIPropertyStatus, b: CIPropertyStatus) -> bool:
	if a._global_severity == b._global_severity:
		if a._severity == b._severity:
			return a._status_string < b._status_string
		return a._severity > b._severity
	return a._global_severity > b._global_severity
