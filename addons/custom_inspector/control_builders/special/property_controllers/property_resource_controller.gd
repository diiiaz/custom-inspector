@tool
extends CIPropertyController
class_name CIPropertyResourceController

const Helper = preload("res://addons/custom_inspector/helper.gd")

@export_storage var _resource_names_filter: PackedStringArray


func setup_names_filter(resource_names_filter: PackedStringArray) -> CIPropertyResourceController:
	_resource_names_filter = resource_names_filter
	return self


@export_storage var _overriden_path_formatting_callable: Callable = Callable()
func override_path_formatting(path_formatting_callable: Callable) -> CIPropertyResourceController:
	_overriden_path_formatting_callable = path_formatting_callable
	return self


func build(parent: Control = null) -> Control:
	var hbox: HBoxContainer = CIHBoxContainer.new().build()
	var label_text: String = "<empty>" if not _has_resource() else _path_formatting(_get_resource_path())
	var label: Label = CILabel.new().set_text(label_text).set_h_alignment(HORIZONTAL_ALIGNMENT_CENTER).build(hbox)
	CIPanel.new().show_behind_parent().build(label)
	
	CIButton.new() \
		.set_icon("Edit") \
		.disable(not _has_resource() or _read_only) \
		.set_pressed_callable(func(_unused): EditorInterface.edit_resource(load(_get_resource_path()))) \
		.set_h_size_flag(Control.SIZE_SHRINK_BEGIN) \
		.build(hbox)
	
	CIButton.new() \
		.set_icon("Load") \
		.set_pressed_callable(
			func(_unused):
				EditorInterface.popup_quick_open(
					func(path: String) -> void:
						if path.is_empty():
							return
						set_value(path if typeof(get_value()) == TYPE_STRING else load(path))
				, _resource_names_filter
				)) \
		.disable(_read_only) \
		.set_h_size_flag(Control.SIZE_SHRINK_BEGIN) \
		.build(hbox)
	
	CIButton.new() \
		.set_icon("Remove") \
		.set_disable(not _has_resource() or _read_only) \
		.set_pressed_callable(func(_unused): set_value("" if typeof(get_value()) == TYPE_STRING else null)) \
		.set_h_size_flag(Control.SIZE_SHRINK_BEGIN) \
		.build(hbox)
	
	finish_control_setup(hbox, parent)
	return hbox


func _path_formatting(path: String) -> String:
	if _overriden_path_formatting_callable != Callable():
		return _overriden_path_formatting_callable.call(path)
	return path.get_file()

func _get_resource_path() -> String:
	if typeof(get_value()) == TYPE_STRING:
		return get_value()
	if typeof(get_value()) == TYPE_OBJECT:
		return get_value().resource_path
	return ""

func _has_resource() -> bool:
	if typeof(get_value()) == TYPE_STRING:
		return FileAccess.file_exists(get_value())
	if typeof(get_value()) == TYPE_OBJECT:
		return get_value() != null
	return false
