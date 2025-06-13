@tool
extends CIBase
class_name CIBaseButton

func set_pressed_callable(callable: Callable) -> CIBaseButton:
	add_build_setter(func(button: BaseButton): button.pressed.connect(callable.bind(button)))
	return self

func disable(disabled: bool = true) -> CIBaseButton:
	add_build_setter(func(button: BaseButton): button.editable = not disabled)
	return self


func build(_parent: Control = null) -> Control:
	assert(false, "The method 'build' must be overridden in the subclass. (you can't use CIBaseButton by itself.)")
	return null
