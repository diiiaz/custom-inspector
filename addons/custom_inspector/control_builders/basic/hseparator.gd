@tool
extends CISeparator
class_name CIHSeparator

func build(parent: Control = null) -> Control:
	set_orientation(CIConstants.ORIENTATION.HORIZONTAL)
	return super.build(parent)
