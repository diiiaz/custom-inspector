@tool
extends CISeparator
class_name CIVSeparator

func build(parent: Control = null) -> Control:
	set_orientation(CIConstants.ORIENTATION.VERTICAL)
	return super.build(parent)
