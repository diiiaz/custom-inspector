extends RefCounted
class_name CIHelper

const INSPECTOR_ROOT_NAME: String = "InspectorRoot"

static func get_icon(icon_path: String, get_default_if_null: bool = true) -> Texture:
	if EditorInterface.get_editor_theme().has_icon(icon_path, "EditorIcons"):
		return EditorInterface.get_editor_theme().get_icon(icon_path, "EditorIcons")
	elif FileAccess.file_exists(icon_path):
		return load(icon_path)
	elif get_default_if_null:
		return EditorInterface.get_editor_theme().get_icon("Object", "EditorIcons")
	return null


static func enum_to_menu_button_items(enumerator: Dictionary) -> Array[CIMenuButton.CIMenuItem]:
	var items: Array[CIMenuButton.CIMenuItem] = []
	for index: int in range(enumerator.size()):
		var key: String = enumerator.keys()[index]
		items.append(CIMenuButton.CIMenuItem.new().set_text(key))
	return items

static func string_array_to_menu_button_items(array: PackedStringArray) -> Array[CIMenuButton.CIMenuItem]:
	var items: Array[CIMenuButton.CIMenuItem] = []
	for index: int in range(array.size()):
		var key: String = array[index]
		items.append(CIMenuButton.CIMenuItem.new().set_text(key))
	return items


static func load_enum_items_in_option_button(option_button: OptionButton, enumerator: Dictionary) -> void:
	for index: int in range(enumerator.size()):
		var key: String = enumerator.keys()[index].capitalize()
		option_button.add_item(key, index)

static func load_string_array_items_in_option_button(option_button: OptionButton, array: PackedStringArray) -> void:
	for index: int in range(array.size()):
		var key: String = array[index].capitalize()
		option_button.add_item(key, index)


static func get_class_name(thing) -> StringName:
	var base_type: Variant.Type = typeof(thing)
	var base_type_name: String = type_string(typeof(thing))
	if base_type == TYPE_OBJECT:
		if thing.get_script() != null:
			base_type_name = ((thing as Object).get_script() as Script).get_global_name()
		else:
			base_type_name = (thing as Object).get_class()
	return base_type_name
