@tool
extends CISlider
class_name CIVSlider

func build(parent: Control = null) -> Control:
	set_orientation(CIConstants.ORIENTATION.VERTICAL)
	return super.build(parent)
