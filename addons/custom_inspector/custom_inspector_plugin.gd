extends EditorInspectorPlugin

const METHOD_NAME: String = "_create_custom_inspector"

var _object: Object
var _inspector_root: Control


func _can_handle(object: Object) -> bool:
	return is_object_valid(object)


func _parse_begin(object: Object) -> void:
	_object = object
	_inspector_root = CIMarginContainer.new().set_all_margins(0).set_node_name("InspectorRoot").build()
	object.call(METHOD_NAME, _inspector_root)
	add_custom_control(_inspector_root)
	#print("custom_inspector_plugin.gd::_parse_begin()")
	#_inspector_root.print_tree_pretty()


static func is_object_valid(object: Object) -> bool:
	if object.get_script() == null:
		return false
	if not object.get_script().is_tool():
		return false
	if not object.has_method(METHOD_NAME):
		return false
	return true
