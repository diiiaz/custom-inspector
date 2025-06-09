@tool
extends CIBoxContainer
class_name CIHBoxContainer

func build(parent: Control = null) -> Control:
	set_orientation(CIConstants.ORIENTATION.HORIZONTAL)
	return super.build(parent)
