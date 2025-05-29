extends CIBase
class_name CIReferenceRect

func set_color(color: Color) -> CIReferenceRect:
	add_build_setter(func(ref_rect: ReferenceRect): ref_rect.border_color = color)
	return self

func set_width(width: int) -> CIReferenceRect:
	add_build_setter(func(ref_rect: ReferenceRect): ref_rect.border_width = width)
	return self


func build(parent: Control = null) -> Control:
	var ref_rect: ReferenceRect = ReferenceRect.new()
	ref_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ref_rect.border_width = 2
	finish_control_setup(ref_rect, parent)
	return ref_rect
