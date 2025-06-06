extends CIBase
class_name CICategory


var _foldable: bool = false
var _text: String = ""
var _icon: Texture2D = null
var _color: Color = editor_theme.get_stylebox("bg", "EditorInspectorCategory").bg_color

# Foldable container data
var _target_object: RefCounted
var _content_root: Control


func _init(text: String, icon_path: String = "") -> void:
	_text = text
	_icon = CIHelper.get_icon(icon_path)


## Set category as foldable and return self for chaining
func foldable(target_object: RefCounted, content_root: Control) -> CICategory:
	_foldable = true
	_target_object = target_object
	_content_root = content_root
	return self


## Set container color and return self for chaining
func set_color(color: Color) -> CICategory:
	var hue: float = color.ok_hsl_h
	_color = Color.from_ok_hsl(hue, 0.7, 0.4)
	return self


## Build basic category header if not foldable else build a CIFoldableContainer
func build(parent: Control = null) -> Control:
	if _foldable:
		var foldable_container: Control = CIFoldableContainer.new(_target_object, _content_root).set_color(_color).build(parent)
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
