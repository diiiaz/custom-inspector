extends CIBoxContainer
class_name CIVBoxContainer

func build(parent: Control = null) -> Control:
	set_orientation(CIConstants.ORIENTATION.VERTICAL)
	return super.build(parent)
