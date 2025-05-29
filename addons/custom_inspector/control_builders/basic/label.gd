extends CIBase
class_name CILabel


func set_text(text: String) -> CILabel:
	add_build_setter(func(label: Label): label.set_text(text))
	return self

func set_v_alignment(value: VerticalAlignment) -> CILabel:
	add_build_setter(func(label: Label): label.vertical_alignment = value)
	return self

func set_h_alignment(value: HorizontalAlignment) -> CILabel:
	add_build_setter(func(label: Label): label.horizontal_alignment = value)
	return self

func build() -> Control:
	var label: Label = Label.new()
	finish_control_setup(label)
	return label
