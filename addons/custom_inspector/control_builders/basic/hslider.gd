extends CISlider
class_name CIHSlider

func build() -> Control:
	set_orientation(CIConstants.ORIENTATION.HORIZONTAL)
	return super.build()
