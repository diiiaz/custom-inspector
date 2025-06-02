extends CIBase
class_name CICategory

const META_ARRAY_NAME: String = "ci_category"

var _state_tweener: Tween

var _mask: Control = null
var _container: MarginContainer = null
var _container_root: MarginContainer = null
var _container_panel: PanelContainer = null
var _arrow_texture_rect: TextureRect = null

var _foldable: bool = false
var _is_open: bool = false

var _object: RefCounted

var _text: String = ""
var _icon: Texture2D = null

var _header_panel_stylebox: StyleBoxFlat

var _color: Color = editor_theme.get_stylebox("bg", "EditorInspectorCategory").bg_color


func _init(text: String, icon: Texture2D = null) -> void:
	_text = text
	_icon = icon


func _ready() -> void:
	if _foldable:
		if not _object.has_meta(META_ARRAY_NAME):
			_object.set_meta(META_ARRAY_NAME, {})
		if not (_object.get_meta(META_ARRAY_NAME) as Dictionary).has(_get_text_as_meta()):
			(_object.get_meta(META_ARRAY_NAME) as Dictionary)[_get_text_as_meta()] = false
		_is_open = (_object.get_meta(META_ARRAY_NAME) as Dictionary)[_get_text_as_meta()]
		_set_state(_is_open, false)


func _get_text_as_meta() -> String:
	return _text.to_snake_case().replace(" ", "_")


func set_color(color: Color) -> CICategory:
	var hue: float = color.ok_hsl_h
	_color = Color.from_ok_hsl(hue, 0.7, 0.4)
	return self


func foldable(object: RefCounted, root: Control) -> CICategory:
	_object = object
	_foldable = true
	add_build_setter(func(_unused): _container.add_child(root))
	return self


# ---------------------- State ----------------------

func _open(animate: bool = true) -> void:
	_is_open = true
	update_state(_container_root.size.y, animate)


func _close(animate: bool = true) -> void:
	_is_open = false
	update_state(0, animate)


func _toggle_state(animate: bool = true) -> void:
	var open: bool = not _is_open
	_open(animate) if open else _close(animate)


func _set_state(open: bool, animate: bool = true) -> void:
	_open(animate) if open else _close(animate)


func update_state(wanted_height: float, animate: bool = true) -> void:
	if not _foldable:
		return
	var new_meta: Dictionary = _object.get_meta(META_ARRAY_NAME)
	new_meta[_get_text_as_meta()] = _is_open
	_object.set_meta(META_ARRAY_NAME, new_meta)
	var tween_speed: float = 0.15
	if not animate:
		tween_speed = 0.0
	if _state_tweener != null and _state_tweener.is_running():
		_state_tweener.stop()
		_state_tweener = null
	_state_tweener = _container.get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel()
	_state_tweener.tween_property(_mask, "custom_minimum_size:y", wanted_height, tween_speed)
	_state_tweener.tween_property(_arrow_texture_rect, "rotation_degrees", 0 if not _is_open else 90, tween_speed)
	_state_tweener.tween_property(_header_panel_stylebox, "corner_radius_bottom_left", editor_theme.get_stylebox("bg", "EditorInspectorCategory").corner_radius_bottom_left if not _is_open else 0, tween_speed)
	_state_tweener.tween_property(_header_panel_stylebox, "corner_radius_bottom_right", editor_theme.get_stylebox("bg", "EditorInspectorCategory").corner_radius_bottom_right if not _is_open else 0, tween_speed)


# ---------------------- Build ----------------------

func build(parent: Control = null) -> Control:
	var root: VBoxContainer = CIVBoxContainer.new().set_separation(0).build()
	_build_category_header(root)
	_build_container(root)
	finish_control_setup(root, parent)
	add_ready_setter(func(_unused): _ready())
	return root


func _build_category_header(parent: Control) -> void:
	_header_panel_stylebox = editor_theme.get_stylebox("bg", "EditorInspectorCategory").duplicate()
	_header_panel_stylebox.content_margin_top = 0
	_header_panel_stylebox.content_margin_bottom = 0
	_header_panel_stylebox.bg_color = _color
	var panel: PanelContainer = CIPanel.new().set_panel(_header_panel_stylebox).set_minimum_size(Vector2(0, 32)).build(parent)
	
	# ---------- Arrow ----------
	if _foldable:
		var aspect_ratio_controller: AspectRatioContainer = CIAspectRatioContainer.new() \
			.set_stretch_mode(AspectRatioContainer.STRETCH_HEIGHT_CONTROLS_WIDTH) \
			.set_h_alignment(AspectRatioContainer.ALIGNMENT_BEGIN) \
			.set_h_size_flag(Control.SIZE_SHRINK_BEGIN) \
			.build(panel)
		
		var control: Control = CIControl.new().build(aspect_ratio_controller)
		
		_arrow_texture_rect = CITextureRect.new() \
			.set_texture(CIHelper.get_icon("CodeFoldedRightArrow")) \
			.set_expand_mode(TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL) \
			.set_stretch_mode(TextureRect.STRETCH_KEEP_CENTERED) \
			.add_ready_setter(
				func(texture_rect: TextureRect):
					await texture_rect.get_tree().process_frame
					texture_rect.pivot_offset = texture_rect.size / 2.0
					) \
			.build(control)
	
	# ---------- Label & Icon ----------
	var hbox: HBoxContainer = CIHBoxContainer.new().set_separation(6).set_alignment(BoxContainer.ALIGNMENT_CENTER).build(panel)
	if _icon == null:
		_icon = CIHelper.get_icon("")
	
	CITextureRect.new() \
		.set_texture(_icon) \
		.set_expand_mode(TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL) \
		.set_stretch_mode(TextureRect.STRETCH_KEEP_CENTERED) \
		.set_h_size_flag(Control.SIZE_SHRINK_CENTER) \
		.build(hbox)
	
	var label: RichTextLabel = CIRichLabel.new() \
		.set_text("[b]" + _text + "[/b]") \
		.set_autowrap(TextServer.AUTOWRAP_OFF) \
		.set_h_alignment(HORIZONTAL_ALIGNMENT_CENTER) \
		.set_v_alignment(VERTICAL_ALIGNMENT_CENTER) \
		.set_h_size_flag(Control.SIZE_SHRINK_CENTER) \
		.build(hbox) 
	
	# ---------- Invisible Button ----------
	if _foldable:
		CIButton.new() \
			.set_flat() \
			.set_mouse_entered_callable(
				func(_unused):
					_container_panel.self_modulate = Color.WHITE * 1.2
					panel.self_modulate = Color.WHITE * 1.2) \
			.set_mouse_exited_callable(
				func(_unused):
					_container_panel.self_modulate = Color.WHITE
					panel.self_modulate = Color.WHITE) \
			.set_pressed_callable(func(_unused): _toggle_state()) \
			.build(panel)


func _build_container(parent: Control) -> void:
	_mask = CIControl.new().clip_content().build(parent)
	_container_root = CIMarginContainer.new().set_all_margins(0).build(_mask)
	
	var panel_stylebox: StyleBoxFlat = editor_theme.get_stylebox("bg", "EditorInspectorCategory").duplicate()
	panel_stylebox.set_content_margin_all(6)
	panel_stylebox.bg_color = _color * Color(1, 1, 1, 0.1)
	panel_stylebox.set_border_width_all(2)
	panel_stylebox.border_color = _color
	panel_stylebox.corner_radius_top_left = 0
	panel_stylebox.corner_radius_top_right = 0
	_container_panel = CIPanel.new().set_panel(panel_stylebox).build(_container_root)
	
	_container = CIMarginContainer.new().set_all_margins(0).set_anchors_preset(Control.PRESET_TOP_WIDE).build(_container_panel)
