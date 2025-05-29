extends CIBase
class_name CIRichLabel


func set_text(text: String) -> CIRichLabel:
	add_build_setter(func(label: RichTextLabel): label.set_text(text))
	return self

func set_v_alignment(value: VerticalAlignment) -> CIRichLabel:
	add_build_setter(func(label: RichTextLabel): label.vertical_alignment = value)
	return self

func set_h_alignment(value: HorizontalAlignment) -> CIRichLabel:
	add_build_setter(func(label: RichTextLabel): label.horizontal_alignment = value)
	return self


func build(parent: Control = null) -> Control:
	var rich_label: RichTextLabel = RichTextLabel.new()
	rich_label.bbcode_enabled = true
	rich_label.fit_content = true
	rich_label.scroll_active = false
	rich_label.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	finish_control_setup(rich_label, parent)
	return rich_label
