@tool
extends EditorPlugin

var inspector_plugin = load(get_plugin_path().path_join("custom_inspector_plugin.gd")).new()

func _enter_tree():
	add_inspector_plugin(inspector_plugin)

func _exit_tree():
	remove_inspector_plugin(inspector_plugin)

func get_plugin_path() -> String:
	return get_script().resource_path.get_base_dir()
