extends RefCounted
class_name CIHelper

static func get_icon(icon_path: String, get_default_if_null: bool = true) -> Texture:
	if EditorInterface.get_editor_theme().has_icon(icon_path, "EditorIcons"):
		return EditorInterface.get_editor_theme().get_icon(icon_path, "EditorIcons")
	elif FileAccess.file_exists(icon_path):
		return load(icon_path)
	elif get_default_if_null:
		return EditorInterface.get_editor_theme().get_icon("Object", "EditorIcons")
	return null
