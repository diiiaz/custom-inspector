@tool
extends CIPropertyController
class_name CIPropertyArrayController

const _DEFAULT_NAME_TEMPLATE: String = "[color=WHITE]{array_property_name}[/color]   [color={details_color}]Array[{array_type}] (size {array_size})"

@export_storage var _content_root: VBoxContainer = null
@export_storage var _color: Color = editor_theme.get_stylebox("normal", "InspectorActionButton").bg_color
@export_storage var _property_controller: CIPropertyController


func set_property_controller(property_controller: CIPropertyController) -> CIPropertyArrayController:
	_property_controller = property_controller.duplicate(true)
	return self


## Set container color and return self for chaining
func set_color(color: Color) -> CIPropertyArrayController:
	_color = color
	return self


func build(parent: Control = null) -> Control:
	_content_root = CIVBoxContainer.new().build()
	var array_type: Variant.Type = get_value().get_typed_builtin()
	
	var foldable_container: Control = CIFoldableContainer.new().set_object(_object).set_content_container(_content_root).set_color(_color).build(parent)
	var foldable_container_panel: PanelContainer = foldable_container.find_child("*Panel*", true, false)
	_build_header_text(foldable_container_panel, get_value(), array_type)
	
	for index: int in range(get_value().size()):
		CIPropertyContainer.new() \
			.set_property_name(str(index)) \
			.set_controller(
				_property_controller.duplicate(true) \
					.set_object(_object) \
					.set_setter(
						func(new_value: Variant):
							var new_arr: Array = get_value()
							# special cases
							if array_type != TYPE_NIL:
								match array_type:
									TYPE_INT:
										new_arr[index] = int(new_value)
									_:
										new_arr[index] = new_value
							else:
								new_arr[index] = new_value
							set_value(new_arr)
							
							) \
					.set_getter(func(): return get_value()[index]) \
		).build(_content_root)
		
	return foldable_container


func _build_header_text(parent: Control, array: Array, array_type: Variant.Type) -> void:
	var margin: MarginContainer = CIMarginContainer.new().set_margins(0, 0, 32, 0).set_mouse_filter(Control.MOUSE_FILTER_IGNORE).build(parent)
	
	var base_type_name: String = type_string(array_type)
	if not array.is_empty():
		base_type_name = CIHelper.get_class_name(array[0])
	
	var name: String = _DEFAULT_NAME_TEMPLATE.format({
		"array_property_name": _property_name.capitalize(),
		"array_type": base_type_name,
		"array_size": str(array.size()),
		"details_color": Color(1, 1, 1, 0.5).to_html(),
	})
	CIRichLabel.new().set_text(name).set_v_alignment(VERTICAL_ALIGNMENT_CENTER).set_mouse_filter(Control.MOUSE_FILTER_IGNORE).build(margin)
