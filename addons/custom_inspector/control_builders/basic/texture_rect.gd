extends CIBase
class_name CITextureRect


func set_expand_mode(expand_mode: TextureRect.ExpandMode) -> CITextureRect:
	add_build_setter(func(texture_rect: TextureRect): texture_rect.expand_mode = expand_mode)
	return self

func set_stretch_mode(stretch_mode: TextureRect.StretchMode) -> CITextureRect:
	add_build_setter(func(texture_rect: TextureRect): texture_rect.stretch_mode = stretch_mode)
	return self

func set_texture(texture: Texture2D) -> CITextureRect:
	add_build_setter(func(texture_rect: TextureRect): texture_rect.set_texture(texture))
	return self

func load_editor_icon_as_texture(icon_name: String) -> CITextureRect:
	add_build_setter(func(texture_rect: TextureRect): texture_rect.set_texture(editor_theme.get_icon(icon_name, "EditorIcons")))
	return self


func build(parent: Control = null) -> Control:
	var texture_rect: TextureRect = TextureRect.new()
	finish_control_setup(texture_rect, parent)
	return texture_rect
