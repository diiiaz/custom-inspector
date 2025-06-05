# Modified version of Nathan Hoad's DialogueManager Updater:
# https://github.com/nathanhoad/godot_dialogue_manager/
@tool
extends RefCounted

const REMOTE_RELEASES_API_URL_TEMPLATE = "https://api.github.com/repos/diiiaz/{repo_name}/releases"
const REMOTE_RELEASES_URL_TEMPLATE = "https://github.com/diiiaz/{repo_name}/releases"

const UPDATE_TEXT = "\
⬤ Update available for plugin \"{plugin_name}\": \
[color=TURQUOISE]\
[url={\"key\": \"install_plugin_update_for_{plugin_name_snake_case}\"}]\
click to download and install {plugin_name} {version}\
[/url][/color], \
[color=WEB_GRAY][i]\
or visit {releases_link} to download it manually.\
[/i][/color]"

const RICH_LABEL_META_KEY = "install_plugin_update_for_{plugin_name_snake_case}"
const TEMP_FILE_NAME = "user://temp.zip"

var _editor_plugin: EditorPlugin
var _remote_releases_link: String = ""
var _releases_link: String = ""
var _console_output_rich_text_label: RichTextLabel = EditorInterface.get_base_control().get_node("/root/@EditorNode@21272/@Panel@14/@VBoxContainer@15/DockHSplitLeftL/DockHSplitLeftR/DockHSplitMain/@VBoxContainer@26/DockVSplitCenter/@EditorBottomPanel@7933/@VBoxContainer@7918/@EditorLog@7952/@VBoxContainer@7935/@RichTextLabel@7937")
var _next_version_release: Dictionary

var _plugin_name: String:
	get: return get_config_file().get_value("plugin", "name")


func initialize(editor_plugin: EditorPlugin, repo_name: String) -> void:
	_remote_releases_link = REMOTE_RELEASES_API_URL_TEMPLATE.format({"repo_name": repo_name})
	_releases_link = REMOTE_RELEASES_URL_TEMPLATE.format({"repo_name": repo_name})
	editor_plugin.tree_exiting.connect(deinitialize)
	_console_output_rich_text_label.meta_clicked.connect(_on_console_output_meta_clicked)
	_editor_plugin = editor_plugin
	check_for_update()


func deinitialize() -> void:
	_editor_plugin.tree_exiting.disconnect(deinitialize)
	_console_output_rich_text_label.meta_clicked.disconnect(_on_console_output_meta_clicked)


func _on_console_output_meta_clicked(meta: Variant) -> void:
	var json_meta = JSON.parse_string(meta)
	if json_meta == null: return
	if json_meta.key == RICH_LABEL_META_KEY.format({"plugin_name_snake_case": _plugin_name.to_snake_case()}):
		if DirAccess.dir_exists_absolute(ProjectSettings.globalize_path("res://_local/")):
			push_error("You can't update the addon from within itself.")
			#failed.emit()
			return
		
		var http_request: HTTPRequest = HTTPRequest.new()
		http_request.request_completed.connect(_on_http_request_download_request_completed, CONNECT_ONE_SHOT)
		_editor_plugin.add_child(http_request)
		http_request.request(_next_version_release.zipball_url)


func get_update_text() -> String:
	return UPDATE_TEXT.format({
		"plugin_name": _plugin_name,
		"plugin_name_snake_case": _plugin_name.to_snake_case(),
		"releases_link": _releases_link,
		"version": _next_version_release.tag_name,
	})


func get_config_file() -> ConfigFile:
	var config: ConfigFile = ConfigFile.new()
	config.load(get_script().resource_path.get_base_dir() + "/plugin.cfg")
	return config


## Get the current version
func get_version() -> String:
	return get_config_file().get_value("plugin", "version")


# Convert a version number to an actually comparable number
func version_to_number(version: String) -> int:
	var bits = version.split(".")
	return bits[0].to_int() * 1000000 + bits[1].to_int() * 1000 + bits[2].to_int()


func check_for_update() -> void:
	var http_request: HTTPRequest = HTTPRequest.new()
	http_request.request_completed.connect(_on_http_request_check_request_completed, CONNECT_ONE_SHOT)
	_editor_plugin.add_child(http_request)
	http_request.request(_remote_releases_link)


func _on_http_request_check_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	prints(result, response_code, headers, body)
	if result != HTTPRequest.RESULT_SUCCESS: return
	
	var current_version: String = get_version()
	
	# Work out the next version from the releases information on GitHub
	var response = JSON.parse_string(body.get_string_from_utf8())
	if typeof(response) != TYPE_ARRAY: return

	# GitHub releases are in order of creation, not order of version
	var versions = (response as Array).filter(func(release):
		var version: String = release.tag_name.substr(1)
		var major_version: int = version.split(".")[0].to_int()
		var current_major_version: int = current_version.split(".")[0].to_int()
		return major_version == current_major_version and version_to_number(version) > version_to_number(current_version)
	)
	if versions.size() > 0:
		_next_version_release = versions[0]
		print_rich(get_update_text())


func _on_http_request_download_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		#failed.emit()
		return

	# Save the downloaded zip
	var zip_file: FileAccess = FileAccess.open(TEMP_FILE_NAME, FileAccess.WRITE)
	zip_file.store_buffer(body)
	zip_file.close()

	OS.move_to_trash(ProjectSettings.globalize_path("res://addons/%s" % [_plugin_name.to_snake_case()]))

	var zip_reader: ZIPReader = ZIPReader.new()
	zip_reader.open(TEMP_FILE_NAME)
	var files: PackedStringArray = zip_reader.get_files()

	var base_path = files[1]
	# Remove archive folder
	files.remove_at(0)
	# Remove assets folder
	files.remove_at(0)

	for path in files:
		var new_file_path: String = path.replace(base_path, "")
		if path.ends_with("/"):
			DirAccess.make_dir_recursive_absolute("res://addons/%s" % new_file_path)
		else:
			var file: FileAccess = FileAccess.open("res://addons/%s" % new_file_path, FileAccess.WRITE)
			file.store_buffer(zip_reader.read_file(path))

	zip_reader.close()
	DirAccess.remove_absolute(TEMP_FILE_NAME)

	#updated.emit(_next_version_release.tag_name.substr(1))
