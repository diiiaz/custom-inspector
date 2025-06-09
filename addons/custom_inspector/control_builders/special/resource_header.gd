@tool
extends CIBase
class_name CIResourceHeader

var _resource: Resource

func _init(resource: Resource) -> void:
	_resource = resource


func build(parent: Control = null) -> Control:
	var panel: PanelContainer = CIPanel.new().build()
	var margin: MarginContainer = CIMarginContainer.new() \
		.set_all_margins(8) \
		.build(panel)
	
	var vbox: VBoxContainer = CIVBoxContainer.new() \
		.set_v_size_flag(Control.SIZE_EXPAND_FILL) \
		.build(margin)
	
	var resource_name: String = _resource.resource_path.get_file().get_slice(".", 0).capitalize()
	var resource_name_label: RichTextLabel = CIRichLabel.new() \
		.set_text("[b]" + resource_name + "[/b]") \
		.set_h_alignment(HORIZONTAL_ALIGNMENT_CENTER) \
		.build(vbox)
	
	var resource_path_label: RichTextLabel = CIRichLabel.new() \
		.set_text(_resource.resource_path) \
		.set_h_alignment(HORIZONTAL_ALIGNMENT_CENTER) \
		.build(vbox)
	
	resource_path_label.add_theme_font_size_override("normal_font_size", 12)
	resource_path_label.self_modulate.a = 0.5
	
	finish_control_setup(panel, parent)
	return panel
