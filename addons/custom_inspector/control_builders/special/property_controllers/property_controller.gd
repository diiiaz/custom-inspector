extends CIBase
class_name CIPropertyController

var _value: Variant
func initialize_value(value: Variant) -> CIPropertyController:
	_value = value
	return self

func set_value(value: Variant) -> void:
	if _value_changed_callback.is_null():
		return
	_value_changed_callback.call(value)

var _value_changed_callback: Callable = Callable()
func set_value_changed_callback(callable: Callable) -> CIPropertyController:
	_value_changed_callback = callable
	return self

var _object: Object
var _property_name: String
func bind_to_property(object: Object, property_name: String) -> CIPropertyController:
	_object = object
	_property_name = property_name
	initialize_value(object.get(property_name))
	set_value_changed_callback(
		func(new_value: Variant):
			object.set(property_name, new_value)
			object.notify_property_list_changed()
			)
	return self
