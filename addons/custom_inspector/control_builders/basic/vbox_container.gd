extends CIBoxContainer
class_name CIVBoxContainer

func build() -> Control:
	set_orientation(CIConstants.ORIENTATION.VERTICAL)
	return super.build()
