extends CIBase
class_name CICategory

var _state_tweener: Tween

var _mask: Control = null
var _container: MarginContainer = null
var _arrow_texture_rect: TextureRect = null

var _foldable: bool = false
var _is_open: bool = false

var _object: RefCounted

var _text: String = ""
var _icon: Texture2D = null


func _init(text: String, icon: Texture2D = null) -> void:
	_text = text
	_icon = icon


func _ready() -> void:
	if _foldable:
		if not _object.has_meta(_get_meta_name()):
			_set_open_meta(true)
		_set_state(_object.get_meta(_get_meta_name()), false)


func _set_open_meta(open: bool) -> void:
	_object.set_meta(_get_meta_name(), open)


func foldable(object: RefCounted, root: Control) -> CICategory:
	_object = object
	_foldable = true
	add_build_setter(func(_unused): _container.add_child(root))
	return self


func _get_meta_name() -> String:
	return "ci_category_folding_%s_open" % [_text.to_snake_case().replace(" ", "_")]


# ---------------------- State ----------------------

func _open(animate: bool = true) -> void:
	_is_open = true
	_set_open_meta(_is_open)
	update_state(_container.size.y, animate)


func _close(animate: bool = true) -> void:
	_is_open = false
	_set_open_meta(_is_open)
	update_state(0, animate)


func _toggle_state(animate: bool = true) -> void:
	var open: bool = not _is_open
	_open(animate) if open else _close(animate)


func _set_state(open: bool, animate: bool = true) -> void:
	_open(animate) if open else _close(animate)


func update_state(wanted_height: float, animate: bool = true) -> void:
	if not _foldable:
		return
	if not animate:
		_mask.custom_minimum_size.y = wanted_height
		_arrow_texture_rect.rotation_degrees = 0 if not _is_open else 90
		return
	if _state_tweener != null and _state_tweener.is_running():
		_state_tweener.stop()
		_state_tweener = null
	_state_tweener = _container.get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel()
	_state_tweener.tween_property(_mask, "custom_minimum_size:y", wanted_height, 0.3)
	_state_tweener.tween_property(_arrow_texture_rect, "rotation_degrees", 0 if not _is_open else 90, 0.3)


# ---------------------- Build ----------------------

func build(parent: Control = null) -> Control:
	var root: VBoxContainer = CIVBoxContainer.new().build()
	_build_category_header(root)
	_build_container(root)
	finish_control_setup(root, parent)
	add_ready_setter(func(_unused): _ready())
	return root


func _build_category_header(parent: Control) -> void:
	var panel_stylebox: StyleBox = editor_theme.get_stylebox("bg", "EditorInspectorCategory").duplicate()
	panel_stylebox.content_margin_top = 0
	panel_stylebox.content_margin_bottom = 0
	var panel: PanelContainer = CIPanel.new().set_panel(panel_stylebox).set_minimum_size(Vector2(0, 32)).build(parent)
	
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
			.set_mouse_entered_callable(func(_unused): panel.self_modulate = Color.WHITE * 1.2) \
			.set_mouse_exited_callable(func(_unused): panel.self_modulate = Color.WHITE) \
			.set_pressed_callable(func(_unused): _toggle_state()) \
			.build(panel)


func _build_container(parent: Control) -> void:
	_mask = CIControl.new().clip_content().build(parent)
	_container = CIMarginContainer.new().set_margins(0, 0, editor_theme.get_constant("inspector_margin", "Editor"), 0).set_anchors_preset(Control.PRESET_TOP_WIDE).build(_mask)
