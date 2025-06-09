@tool
extends CIBase
class_name CIMarginContainer

const DIRECTION_NAME_MAP = {
	CIConstants.DIRECTION.TOP: "margin_top",
	CIConstants.DIRECTION.BOTTOM: "margin_bottom",
	CIConstants.DIRECTION.LEFT: "margin_left",
	CIConstants.DIRECTION.RIGHT: "margin_right",
}


func set_all_margins(margin_value: int) -> CIMarginContainer:
	add_build_setter(
		func(margin: MarginContainer):
			set_margin(CIConstants.DIRECTION.TOP, margin_value)
			set_margin(CIConstants.DIRECTION.BOTTOM, margin_value)
			set_margin(CIConstants.DIRECTION.LEFT, margin_value)
			set_margin(CIConstants.DIRECTION.RIGHT, margin_value)
	)
	return self


func set_margins(top: int, down: int, left: int, right: int) -> CIMarginContainer:
	add_build_setter(
		func(margin: MarginContainer):
			set_margin(CIConstants.DIRECTION.TOP, top)
			set_margin(CIConstants.DIRECTION.BOTTOM, down)
			set_margin(CIConstants.DIRECTION.LEFT, left)
			set_margin(CIConstants.DIRECTION.RIGHT, right)
	)
	return self


func set_margin(direction: CIConstants.DIRECTION, margin_value: int) -> CIMarginContainer:
	add_build_setter(func(margin: MarginContainer): margin.add_theme_constant_override(DIRECTION_NAME_MAP.get(direction), margin_value))
	return self


func build(parent: Control = null) -> Control:
	var margin: MarginContainer = MarginContainer.new()
	finish_control_setup(margin, parent)
	#prints(margin.get_name(), ":",  margin.get("theme_override_constants/margin_top"), margin.get("theme_override_constants/margin_down"), margin.get("theme_override_constants/margin_left"), margin.get("theme_override_constants/margin_right"))
	return margin
