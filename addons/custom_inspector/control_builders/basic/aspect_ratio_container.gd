@tool
extends CIBase
class_name CIAspectRatioContainer

# arc = aspect ratio container

func set_ratio(ratio: float) -> CIAspectRatioContainer:
	add_build_setter(func(arc: AspectRatioContainer): arc.ratio = ratio)
	return self

func set_stretch_mode(stretch_mode: AspectRatioContainer.StretchMode) -> CIAspectRatioContainer:
	add_build_setter(func(arc: AspectRatioContainer): arc.stretch_mode = stretch_mode)
	return self

func set_h_alignment(alignment: AspectRatioContainer.AlignmentMode) -> CIAspectRatioContainer:
	add_build_setter(func(arc: AspectRatioContainer): arc.alignment_horizontal = alignment)
	return self

func set_v_alignment(alignment: AspectRatioContainer.AlignmentMode) -> CIAspectRatioContainer:
	add_build_setter(func(arc: AspectRatioContainer): arc.alignment_vertical = alignment)
	return self

func build(parent: Control = null) -> Control:
	var arc: AspectRatioContainer = AspectRatioContainer.new()
	finish_control_setup(arc, parent)
	return arc
