@tool
extends CIBase
class_name CIPropertyController

signal value_changed(new_value)

@export_storage var _object: Object
@export_storage var _property_name: String
@export_storage var _read_only: bool = false
@export_storage var _statuses: Array[CIPropertyStatus] = []

@export_storage var _property_setter: Callable = Callable()
@export_storage var _property_getter: Callable = Callable()


func _init() -> void:
	add_status(CIStatusTemplate.create_error("Object is not set, use set_object() to set one.").set_status_checker(func(): return _object == null))


func set_object(object: Object) -> CIPropertyController:
	_object = object
	return self


func set_property_name(name: String) -> CIPropertyController:
	_property_name = name
	return self


func read_only(read_only: bool = true) -> CIPropertyController:
	_read_only = read_only
	return self


func setup_setget(property_name: String) -> CIPropertyController:
	set_property_name(property_name)
	set_setter(func(new_value): _object.set(property_name, new_value))
	set_getter(func(): return _object.get(property_name))
	return self

func set_setter(setter: Callable) -> CIPropertyController:
	_property_setter = setter
	return self

func set_getter(getter: Callable) -> CIPropertyController:
	_property_getter = getter
	_on_value_changed.call_deferred(get_value())
	return self


func set_value(new_value: Variant) -> void:
	if _property_setter.is_null():
		push_error("\"_property_setter\" is null.")
		return
	_property_setter.call(new_value)
	value_changed.emit(new_value)
	_on_value_changed(new_value)


func get_value() -> Variant:
	if _property_getter.is_null():
		push_error("\"_property_getter\" is null.")
		return null
	return _property_getter.call()


func get_statuses() -> Array[CIPropertyStatus]:
	return _statuses

func add_status(status: CIPropertyStatus) -> CIPropertyController:
	_statuses.append(status)
	return self

func _on_value_changed(new_value) -> void:
	pass
