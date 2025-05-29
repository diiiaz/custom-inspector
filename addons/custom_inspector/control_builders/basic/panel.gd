extends CIBase
class_name CIPanel

static var default_panel: StyleBox:
	get:
		if Engine.is_editor_hint():
			if default_panel == null:
				default_panel = editor_theme.get_stylebox("panel", "Panel")
			return default_panel
		return null


func set_panel(stylebox: StyleBox) -> CIPanel:
	if stylebox == default_panel:
		return self
	add_build_setter(func(panel: PanelContainer): panel.add_theme_stylebox_override("panel", stylebox))
	return self


func build() -> Control:
	var panel: PanelContainer = PanelContainer.new()
	panel.add_theme_stylebox_override("panel", default_panel)
	finish_control_setup(panel)
	return panel
