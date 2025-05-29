extends CIBase
class_name CICategory

var _text: String = ""
var _icon: Texture2D = null
func _init(text: String, icon: Texture2D = null) -> void:
	_text = text
	_icon = icon


func build(parent: Control = null) -> Control:
	var panel_stylebox: StyleBox = editor_theme.get_stylebox("bg", "EditorInspectorCategory").duplicate()
	panel_stylebox.content_margin_top = 7
	panel_stylebox.content_margin_bottom = 7
	var panel: PanelContainer = CIPanel.new().set_panel(panel_stylebox).build()
	
	var hbox: HBoxContainer = CIHBoxContainer.new().set_separation(6).build(panel)
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	
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
			.set_h_alignment(HORIZONTAL_ALIGNMENT_CENTER) \
			.set_h_size_flag(Control.SIZE_SHRINK_CENTER) \
			.build(hbox) 
	
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	
	finish_control_setup(panel, parent)
	return panel
