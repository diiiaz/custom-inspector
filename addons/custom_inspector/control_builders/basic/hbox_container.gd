extends CIBoxContainer
class_name CIHBoxContainer

func build() -> Control:
	set_orientation(CIConstants.ORIENTATION.HORIZONTAL)
	return super.build()
