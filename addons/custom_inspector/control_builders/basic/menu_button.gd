extends CIButton
class_name CIMenuButton


func load_enum(enumerator: Dictionary) -> CIMenuButton:
	add_build_setter(func(_unused): setup_items(CIHelper.enum_to_menu_button_items(enumerator)))
	return self

func load_string_array(array: Array[String]) -> CIMenuButton:
	add_build_setter(func(_unused): setup_items(CIHelper.string_array_to_menu_button_items(array)))
	return self


func setup_items(items: Array[CIMenuItem]) -> CIMenuButton:
	add_build_setter(
		func(menu_button: MenuButton):
			for index: int in range(items.size()):
				var item: CIMenuItem = items[index]
				menu_button.get_popup().add_item(item.get_text().capitalize(), index)
				menu_button.get_popup().set_item_icon(index, item.get_icon())
				menu_button.get_popup().set_item_as_checkable(index, item.is_checkable())
				menu_button.get_popup().set_item_disabled(index, item.is_disabled())
				menu_button.get_popup().set_item_as_separator(index, item.is_separator())
	)
	return self


func set_item_selected_callable(callable: Callable) -> CIBaseButton:
	add_build_setter(func(menu_button: MenuButton): menu_button.get_popup().id_pressed.connect(callable))
	return self


func build(parent: Control = null) -> Control:
	var menu_button: MenuButton = MenuButton.new()
	menu_button.flat = false
	menu_button.theme_type_variation = "InspectorActionButton"
	finish_control_setup(menu_button, parent)
	return menu_button


class CIMenuItem extends RefCounted:
	var _text: String = ""
	var _icon: Texture2D = null
	var _checkable: bool = false
	var _disabled: bool = false
	var _separator: bool = false
	
	func get_text() -> String: return _text
	func get_icon() -> Texture2D: return _icon
	func is_checkable() -> bool: return _checkable
	func is_disabled() -> bool: return _disabled
	func is_separator() -> bool: return _separator
	
	func set_text(text: String) -> CIMenuItem:
		_text = text
		return self
	
	func set_icon(icon: Texture2D) -> CIMenuItem:
		_icon = icon
		return self
	
	func set_checkable(checkable: bool) -> CIMenuItem:
		_checkable = checkable
		return self
	
	func set_disabled(disabled: bool) -> CIMenuItem:
		_disabled = disabled
		return self
	
	func set_separator(separator: bool) -> CIMenuItem:
		_separator = separator
		return self
	
