extends RefCounted
class_name CIBase

static var editor_theme: Theme:
	get:
		if Engine.is_editor_hint():
			if editor_theme == null:
				editor_theme = EditorInterface.get_editor_theme()
			return editor_theme
		return null

var _build_setters: Array[Callable]
var _errors: PackedStringArray


func add_build_setter(setter: Callable):
	_build_setters.append(setter)
	return self

func finish_control_setup(control: Control, parent: Control = null) -> void:
	control.set_name(control.get_class())
	control.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	control.set_v_size_flags(Control.SIZE_EXPAND_FILL)
	control.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for setter: Callable in _build_setters:
		setter.call(control)
	if parent != null:
		parent.add_child(control)



func show_bounding_box() -> CIBase:
	add_build_setter(func(control: Control): CIReferenceRect.new().build(control))
	return self

func show_behind_parent() -> CIBase:
	add_build_setter(func(control: Control): control.show_behind_parent = true)
	return self

func set_mouse_filter(mouse_filter: Control.MouseFilter) -> CIBase:
	add_build_setter(func(control: Control): control.mouse_filter = mouse_filter)
	return self

func set_node_name(name: String) -> CIBase:
	add_build_setter(func(control: Control): control.set_name(name))
	return self

func set_h_size_flag(flag: Control.SizeFlags) -> CIBase:
	add_build_setter(func(control: Control): control.size_flags_horizontal = flag)
	return self

func set_v_size_flag(flag: Control.SizeFlags) -> CIBase:
	add_build_setter(func(control: Control): control.size_flags_vertical = flag)
	return self



func build(_parent: Control = null) -> Control:
	assert(false, "The method 'build' must be overridden in the subclass.")
	return null
