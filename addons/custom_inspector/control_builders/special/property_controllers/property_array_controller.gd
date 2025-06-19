@tool
extends CIPropertyController
class_name CIPropertyArrayController

const _DEFAULT_NAME_TEMPLATE: String = "[color=WHITE]{array_property_name}[/color]   [color={details_color}]Array[{array_type}] (size {array_size})"

@export_storage var _content_root: VBoxContainer = null
@export_storage var _color: Color = editor_theme.get_stylebox("normal", "InspectorActionButton").bg_color
@export_storage var _property_controller: CIPropertyController

var foldable_container_builder: CIFoldableContainer
var foldable_container: Control
var _array_type: Variant.Type
var _property_containers_builders: Array[CIPropertyContainer]


func set_property_controller(property_controller: CIPropertyController) -> CIPropertyArrayController:
	_property_controller = property_controller.duplicate(true)
	return self


## Set container color and return self for chaining
func set_color(color: Color) -> CIPropertyArrayController:
	_color = color
	return self


func build(parent: Control = null) -> Control:
	var _root: VBoxContainer = CIVBoxContainer.new().build()
	_content_root = CIVBoxContainer.new().build(_root)
	_array_type = get_value().get_typed_builtin()
	
	foldable_container_builder = CIFoldableContainer.new().set_object(_object).set_content_container(_root).set_color(_color)
	foldable_container = foldable_container_builder.build(parent)
	var foldable_container_panel: PanelContainer = foldable_container.find_child("*Panel*", true, false)
	
	_build_header_text(foldable_container_panel, get_value())
	_build_array()
	
	CIButton.new().set_text("Add Element").set_pressed_callable(
		func(_unused): 
			var new_arr: Array = get_value()
			new_arr.append(_get_default_value_from_type(_array_type))
			set_value(new_arr)
			_build_item(_content_root, new_arr.size()-1)
			foldable_container_builder.update_container_height(false)
			) \
		.build(_root)
	
	return foldable_container


func _build_array() -> void:
	for index: int in range(get_value().size()):
		_build_item(_content_root, index)


func _build_item(parent: Control, index: int) -> void:
	var hbox: HBoxContainer = CIHBoxContainer.new().build(parent)
	# Property Container
	var propety_container: CIPropertyContainer = CIPropertyContainer.new() \
		.set_property_name(str(hbox.get_index())) \
		.set_property_size(CIPropertyContainer.SIZE.LARGE if _array_type == TYPE_OBJECT else CIPropertyContainer.SIZE.HALF) \
		.set_controller(
			_property_controller.duplicate(true) \
				.set_object(_object) \
				.set_getter(func(): return get_value()[hbox.get_index()]) \
				.set_setter(
					func(new_value: Variant):
						var new_arr: Array = get_value()
						# special cases
						if _array_type != TYPE_NIL:
							match _array_type:
								TYPE_INT:
									new_arr[hbox.get_index()] = int(new_value)
								_:
									new_arr[hbox.get_index()] = new_value
						else:
							new_arr[hbox.get_index()] = new_value
						set_value(new_arr)
						))
	
	_property_containers_builders.append(propety_container)
	propety_container.build(hbox)
	
	CIButton.new() \
		.set_icon("Remove") \
		.set_pressed_callable(
			func(button: Button):
				var new_arr: Array = get_value()
				new_arr.remove_at(hbox.get_index())
				set_value(new_arr)
				
				_property_containers_builders.remove_at(hbox.get_index())
				update_indexes()
				
				hbox.hide()
				foldable_container_builder.update_container_height(false)
				hbox.queue_free()
				) \
		.set_h_size_flag(Control.SIZE_SHRINK_END) \
		.build(hbox)


func update_indexes() -> void:
	for index: int in range(_property_containers_builders.size()):
		var property_container: CIPropertyContainer = _property_containers_builders[index]
		property_container.property_label.text = str(index)


func _build_header_text(parent: Control, array: Array) -> void:
	var margin: MarginContainer = CIMarginContainer.new().set_margins(0, 0, 32, 0).set_mouse_filter(Control.MOUSE_FILTER_IGNORE).build(parent)
	
	var base_type_name: String = type_string(_array_type)
	if not array.is_empty():
		base_type_name = CIHelper.get_class_name(array[0])
	
	var name: String = _DEFAULT_NAME_TEMPLATE.format({
		"array_property_name": _property_name.capitalize(),
		"array_type": base_type_name,
		"array_size": str(array.size()),
		"details_color": Color(1, 1, 1, 0.5).to_html(),
	})
	CIRichLabel.new().set_text(name).set_v_alignment(VERTICAL_ALIGNMENT_CENTER).set_mouse_filter(Control.MOUSE_FILTER_IGNORE).build(margin)


func _get_default_value_from_type(type: Variant.Type) -> Variant:
	match type:
		TYPE_FLOAT: return 0.0
		TYPE_INT: return 0
		TYPE_BOOL: return false
		TYPE_STRING: return ""
		TYPE_OBJECT: return null
		TYPE_VECTOR2: return Vector2.ZERO
		TYPE_COLOR: return Color.BLACK
	return 0
