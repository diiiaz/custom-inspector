@tool
extends CISlider
class_name CIHSlider

func build(parent: Control = null) -> Control:
	set_orientation(CIConstants.ORIENTATION.HORIZONTAL)
	return super.build(parent)
