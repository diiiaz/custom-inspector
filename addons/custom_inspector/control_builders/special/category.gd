@tool
extends CIBase
class_name CICategory


@export_storage var _foldable: bool = false
@export_storage var _text: String = ""
@export_storage var _icon: Texture2D = null
@export_storage var _color: Color = editor_theme.get_stylebox("bg", "EditorInspectorCategory").bg_color

# Foldable container data
@export_storage var _target_object: RefCounted
@export_storage var _content_root: Control


func set_text(text: String) -> CICategory:
	_text = text
	return self


func set_icon(icon_path: String) -> CICategory:
	_icon = CIHelper.get_icon(icon_path)
	return self


## Set category as foldable and return self for chaining
func foldable(target_object: RefCounted, content_root: Control) -> CICategory:
	_foldable = true
	_target_object = target_object
	_content_root = content_root
	return self


## Set container color and return self for chaining
func set_color(color: Color) -> CICategory:
	_color = color
	return self


## Build basic category header if not foldable else build a CIFoldableContainer
func build(parent: Control = null) -> Control:
	if _foldable:
		var foldable_container: Control = CIFoldableContainer.new().set_object(_target_object).set_content_container(_content_root).set_color(_color).build(parent)
		build_header_text_and_icon(foldable_container.find_child("*Panel*", true, false))
		return foldable_container
	
	var root: Control = CIMarginContainer.new().set_all_margins(0).build()
	build_header(root)
	finish_control_setup(root, parent)
	return root


func build_header(parent: Control) -> void:
	var header_stylebox = editor_theme.get_stylebox("bg", "EditorInspectorCategory").duplicate()
	header_stylebox.content_margin_top = 0
	header_stylebox.content_margin_bottom = 0
	header_stylebox.bg_color = _color
	
	var header_panel = CIPanel.new() \
		.set_panel(header_stylebox) \
		.set_minimum_size(Vector2(0, 32)) \
		.build(parent)
	
	build_header_text_and_icon(header_panel)


func build_header_text_and_icon(parent: Control) -> void:
	var hbox: HBoxContainer = CIHBoxContainer.new().set_alignment(BoxContainer.AlignmentMode.ALIGNMENT_CENTER).set_mouse_filter(Control.MOUSE_FILTER_IGNORE).build(parent)
	
	CITextureRect.new() \
		.set_texture(_icon) \
		.set_expand_mode(TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL) \
		.set_stretch_mode(TextureRect.STRETCH_KEEP_CENTERED) \
		.set_h_size_flag(Control.SIZE_SHRINK_CENTER) \
		.set_mouse_filter(Control.MOUSE_FILTER_IGNORE) \
		.build(hbox)
	
	var label: RichTextLabel = CIRichLabel.new() \
		.set_text("[b]" + _text + "[/b]") \
		.set_autowrap(TextServer.AUTOWRAP_OFF) \
		.set_h_alignment(HORIZONTAL_ALIGNMENT_CENTER) \
		.set_v_alignment(VERTICAL_ALIGNMENT_CENTER) \
		.set_h_size_flag(Control.SIZE_SHRINK_CENTER) \
		.set_mouse_filter(Control.MOUSE_FILTER_IGNORE) \
		.build(hbox) 
