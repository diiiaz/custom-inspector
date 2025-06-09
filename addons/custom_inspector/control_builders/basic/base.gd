@tool
extends Resource
class_name CIBase

static var editor_theme: Theme:
	get:
		if Engine.is_editor_hint():
			if editor_theme == null:
				editor_theme = EditorInterface.get_editor_theme()
			return editor_theme
		return null

@export_storage var _build_setters: Array[Callable]
@export_storage var _ready_setters: Array[Callable]
@export_storage var _errors: PackedStringArray
@export_storage var _name_overriden: bool = false

func add_build_setter(setter: Callable):
	_build_setters.append(setter)
	return self

func add_ready_setter(setter: Callable):
	_ready_setters.append(setter)
	return self

func finish_control_setup(control: Control, parent: Control = null) -> void:
	control.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	control.set_v_size_flags(Control.SIZE_EXPAND_FILL)
	control.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if not _name_overriden:
		set_node_name(CIHelper.get_class_name(control))
	#add_build_setter(func(_control: Control): _control.name = CIHelper.get_class_name(_control))
	control.ready.connect(
		func():
			for setter: Callable in _ready_setters:
				setter.call(control)
	)
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
	add_ready_setter(func(control: Control): control.name = name)
	_name_overriden = true
	return self

func set_h_size_flag(flag: Control.SizeFlags) -> CIBase:
	add_build_setter(func(control: Control): control.size_flags_horizontal = flag)
	return self

func set_v_size_flag(flag: Control.SizeFlags) -> CIBase:
	add_build_setter(func(control: Control): control.size_flags_vertical = flag)
	return self

func set_anchors_preset(preset: Control.LayoutPreset) -> CIBase:
	add_build_setter(func(control: Control): control.set_anchors_and_offsets_preset(preset))
	return self

func set_minimum_size(size: Vector2) -> CIBase:
	add_build_setter(func(control: Control): control.custom_minimum_size = size)
	return self

func set_mouse_entered_callable(callable: Callable) -> CIBase:
	add_build_setter(func(control: Control): control.mouse_entered.connect(callable.bind(control)))
	return self

func set_mouse_exited_callable(callable: Callable) -> CIBase:
	add_build_setter(func(control: Control): control.mouse_exited.connect(callable.bind(control)))
	return self

func clip_content() -> CIBase:
	add_build_setter(func(control: Control): control.clip_contents = true)
	return self

func set_custom_meta(name: StringName, value: Variant, set_on_control: bool = true) -> CIBase:
	if set_on_control:
		add_build_setter(func(control: Control): control.set_meta(name, value))
	else:
		set_meta(name, value)
	return self

func get_custom_meta(control: Control, name: StringName, get_from_control: bool = true) -> Variant:
	if get_from_control:
		return control.get_meta(name)
	else:
		return get_meta(name)
	return null


func build(_parent: Control = null) -> Control:
	assert(false, "The method 'build' must be overridden in the subclass.")
	return null
