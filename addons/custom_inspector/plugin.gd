@tool
extends EditorPlugin

var inspector_plugin: EditorInspectorPlugin = load(get_plugin_path().path_join("custom_inspector_plugin.gd")).new()


func _enter_tree():
	add_inspector_plugin(inspector_plugin)
	load_plugin_updater("custom-inspector")


func _exit_tree():
	remove_inspector_plugin(inspector_plugin)


func get_plugin_path() -> String:
	return get_script().resource_path.get_base_dir()


# need to be called inside _enter_tree() of a EditorPlugin
# like that we can remove safely plugin_updater.gd without any errors if we don't want auto updates.
func load_plugin_updater(repo_name: String) -> void:
	var updater_path: String = get_plugin_path().path_join("plugin_updater.gd")
	if FileAccess.file_exists(ProjectSettings.globalize_path(updater_path)):
		var updater = load(updater_path).new()
		if updater != null:
			updater.initialize(self, repo_name)
