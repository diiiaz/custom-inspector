@tool
extends CIPropertyController
class_name CIPropertyResourceController

const Helper = preload("res://addons/custom_inspector/helper.gd")

@export_storage var _resource_names_filter: PackedStringArray

var label: Label
var edit_button: Button
var delete_button: Button
var custom_inspector_root: Control


func setup_names_filter(resource_names_filter: PackedStringArray) -> CIPropertyResourceController:
	_resource_names_filter = resource_names_filter
	return self


@export_storage var _overriden_path_formatting_callable: Callable = Callable()
func override_path_formatting(path_formatting_callable: Callable) -> CIPropertyResourceController:
	_overriden_path_formatting_callable = path_formatting_callable
	return self


func build(parent: Control = null) -> Control:
	var vbox: VBoxContainer = CIVBoxContainer.new().build()
	
	var hbox: HBoxContainer = CIHBoxContainer.new().build(vbox)
	label = CILabel.new().set_h_alignment(HORIZONTAL_ALIGNMENT_CENTER).build(hbox)
	CIPanel.new().show_behind_parent().build(label)
	
	edit_button = CIButton.new() \
		.set_icon("Edit") \
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
	
	delete_button = CIButton.new() \
		.set_icon("UndoRedo") \
		.set_pressed_callable(func(_unused): set_value("" if typeof(get_value()) == TYPE_STRING else null)) \
		.set_h_size_flag(Control.SIZE_SHRINK_BEGIN) \
		.build(hbox)
	
	custom_inspector_root = CIMarginContainer.new().set_all_margins(0).build(vbox)
	finish_control_setup(vbox, parent)
	return vbox


func _on_value_changed(new_value) -> void:
	if label:
		label.text = "<empty>" if not _has_resource() else _path_formatting(_get_resource_path())
	if edit_button:
		edit_button.disabled = not _has_resource() or _read_only
	if delete_button:
		delete_button.disabled = not _has_resource() or _read_only
	if custom_inspector_root:
		if custom_inspector_root.get_child_count() > 0:
			for child in custom_inspector_root.get_children():
				child.queue_free()
		var has_custom_inspector_function: bool = _has_resource() and get_value().get_script() != null and get_value().get_script().source_code.contains("\nfunc _create_custom_inspector")
		custom_inspector_root.visible = has_custom_inspector_function
		if has_custom_inspector_function:
			get_value()._create_custom_inspector(custom_inspector_root)


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
