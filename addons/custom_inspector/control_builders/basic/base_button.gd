extends CIBase
class_name CIBaseButton

func set_pressed_callable(callable: Callable) -> CIBaseButton:
	add_build_setter(func(button: Button): button.pressed.connect(callable))
	return self

func set_disable(disable: bool = true) -> CIBaseButton:
	add_build_setter(func(button: Button): button.disabled = disable)
	return self


func build() -> Control:
	assert(false, "The method 'build' must be overridden in the subclass. (you can't use CIBaseButton by itself.)")
	return null
