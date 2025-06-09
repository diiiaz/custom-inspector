@tool
extends CIBase
class_name CIFoldableContainer
## Foldable container for inspector UI with toggle animation

const FOLD_STATE_META_KEY: String = "ci_foldable_container"

# UI Components
@export_storage var _root_control: Control
@export_storage var _content_mask: Control
@export_storage var _content_container: MarginContainer
@export_storage var _content_panel: PanelContainer
@export_storage var _arrow_icon: TextureRect

# State management
@export_storage var _target_object: RefCounted
@export_storage var _animation_tween: Tween
@export_storage var _header_stylebox: StyleBoxFlat
@export_storage var _is_expanded: bool = false
@export_storage var _color: Color = editor_theme.get_stylebox("bg", "EditorInspectorCategory").bg_color
@export_storage var _force_color: Color = Color.WHITE


func set_content_container(content_root: Control) -> CIFoldableContainer:
	add_build_setter(func(_unused): _content_container.add_child(content_root))
	return self


func set_object(object: Object) -> CIFoldableContainer:
	_target_object = object
	return self


func _ready(container_control: Control) -> void:
	_root_control = container_control
	
	# Initialize fold state from metadata
	initialize_fold_state()
	
	# Connect child container updates
	connect_child_containers()
	
	# Initial layout setup
	await container_control.get_tree().process_frame
	update_mask_height.call_deferred(_content_panel.get_minimum_size().y if _is_expanded else 0)


## Initialize fold state from target object's metadata
func initialize_fold_state() -> void:
	var state_id := get_state_identifier()
	
	if not _target_object.has_meta(FOLD_STATE_META_KEY):
		_target_object.set_meta(FOLD_STATE_META_KEY, {})
	
	var state_map: Dictionary = _target_object.get_meta(FOLD_STATE_META_KEY)
	if not state_map.has(state_id):
		state_map[state_id] = false
	
	_is_expanded = state_map[state_id]
	_root_control.set_meta("content_mask", _content_mask)
	set_expanded_state(_is_expanded, false)


## Generate unique identifier for this container's state
func get_state_identifier() -> String:
	var parent_inspector = _root_control.find_parent(CIHelper.INSPECTOR_ROOT_NAME)
	return str(str(parent_inspector.get_path_to(_root_control).get_name_count()).hash() + _root_control.get_index())


## Connect child foldable containers for height updates
func connect_child_containers() -> void:
	for child_container in _content_panel.find_children("CIFoldableContainer*", "Control", true, false):
		child_container.get_meta("content_mask").item_rect_changed.connect(
			func(): 
				var target_height = _content_panel.get_minimum_size().y if _is_expanded else _content_mask.size.y
				update_mask_height(target_height)
		)


## Set container color and return self for chaining
func set_color(color: Color) -> CIFoldableContainer:
	var hue: float = color.ok_hsl_h
	_color = Color.from_ok_hsl(hue, 0.7, 0.4)
	return self


#region State Management

## Toggle expanded/collapsed state
func toggle_state(_ununsed, animate: bool = true) -> void:
	set_expanded_state(not _is_expanded, animate)


## Set specific expanded state
func set_expanded_state(expanded: bool, animate: bool = true) -> void:
	_is_expanded = expanded
	update_container_height(animate)


## Update container height with animation
func update_container_height(animate: bool = true) -> void:
	var target_height = _content_panel.get_minimum_size().y if _is_expanded else 0
	animate_height_change(target_height, animate)


## Animate height transition and UI updates
func animate_height_change(target_height: float, animate: bool) -> void:
	# Save state to metadata
	var state_map: Dictionary = _target_object.get_meta(FOLD_STATE_META_KEY)
	state_map[get_state_identifier()] = _is_expanded
	_target_object.set_meta(FOLD_STATE_META_KEY, state_map)
	
	# Configure animation parameters
	var duration: float = 0.15 if animate else 0.0001
	
	# Clean up existing tween
	if _animation_tween and _animation_tween.is_running():
		_animation_tween.kill()
	
	# Create new tween
	_animation_tween = _root_control.get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel()
	
	# Animate components
	_animation_tween.tween_method(update_mask_height, _content_mask.custom_minimum_size.y, target_height, duration)
	
	var arrow_rotation: int = 90 if _is_expanded else 0
	_animation_tween.tween_property(_arrow_icon, "rotation_degrees", arrow_rotation, duration)
	
	var corner_radius: int = 0 if _is_expanded else editor_theme.get_stylebox("bg", "EditorInspectorCategory").corner_radius_bottom_left
	_animation_tween.tween_property(_header_stylebox, "corner_radius_bottom_left", corner_radius, duration)
	_animation_tween.tween_property(_header_stylebox, "corner_radius_bottom_right", corner_radius, duration)


## Update mask height (callback for tween)
func update_mask_height(height: float) -> void:
	if _content_mask == null:
		return
	_content_mask.custom_minimum_size.y = height

#endregion


#region UI Construction

## Build container UI hierarchy
func build(parent: Control = null) -> Control:
	var container = CIVBoxContainer.new().set_separation(0).build()
	build_header(container)
	build_content_area(container)
	finish_control_setup(container, parent)
	add_ready_setter(_ready)
	return container


## Build header section with toggle button
func build_header(parent: Control) -> void:
	_header_stylebox = editor_theme.get_stylebox("bg", "EditorInspectorCategory").duplicate()
	_header_stylebox.content_margin_top = 0
	_header_stylebox.content_margin_bottom = 0
	_header_stylebox.bg_color = _color
	
	var header_panel = CIPanel.new() \
		.set_panel(_header_stylebox) \
		.set_minimum_size(Vector2(0, 32)) \
		.build(parent)
	
	build_arrow_icon(header_panel)
	build_toggle_button(header_panel)


## Build arrow icon for header
func build_arrow_icon(parent: Control) -> void:
	var aspect_container = CIAspectRatioContainer.new() \
		.set_stretch_mode(AspectRatioContainer.STRETCH_HEIGHT_CONTROLS_WIDTH) \
		.set_h_alignment(AspectRatioContainer.ALIGNMENT_BEGIN) \
		.set_h_size_flag(Control.SIZE_SHRINK_BEGIN) \
		.build(parent)
	
	var control_container = CIControl.new().build(aspect_container)
	
	_arrow_icon = CITextureRect.new() \
		.set_texture(CIHelper.get_icon("CodeFoldedRightArrow")) \
		.set_expand_mode(TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL) \
		.set_stretch_mode(TextureRect.STRETCH_KEEP_CENTERED) \
		.add_ready_setter(center_arrow_pivot) \
		.build(control_container)


## Center arrow icon pivot point
func center_arrow_pivot(icon: TextureRect) -> void:
	await icon.get_tree().process_frame
	icon.pivot_offset = icon.size / 2.0


## Build invisible toggle button
func build_toggle_button(parent: Control) -> void:
	CIButton.new() \
		.set_flat() \
		.set_mouse_entered_callable(highlight_header.bind(parent)) \
		.set_mouse_exited_callable(unhighlight_header.bind(parent)) \
		.set_pressed_callable(toggle_state) \
		.build(parent)


## Highlight header on hover
func highlight_header(_unused, parent: Control) -> void:
	_content_panel.self_modulate = Color.WHITE * 1.2
	parent.self_modulate = Color.WHITE * 1.2  # parent refers to header panel


## Remove header highlight
func unhighlight_header(_unused, parent: Control) -> void:
	_content_panel.self_modulate = Color.WHITE
	parent.self_modulate = Color.WHITE  # parent refers to header panel


## Build content area with styling
func build_content_area(parent: Control) -> void:
	_content_mask = CIControl.new().clip_content().build(parent)
	var margin_root = CIMarginContainer.new().set_all_margins(0).build(_content_mask)
	
	var panel_style = create_content_stylebox()
	_content_panel = CIPanel.new().set_panel(panel_style).build(margin_root)
	
	_content_container = CIMarginContainer.new() \
		.set_all_margins(0) \
		.set_anchors_preset(Control.PRESET_TOP_WIDE) \
		.build(_content_panel)


## Create stylebox for content panel
func create_content_stylebox() -> StyleBoxFlat:
	var style = editor_theme.get_stylebox("bg", "EditorInspectorCategory").duplicate()
	style.set_content_margin_all(6)
	style.bg_color = _color * Color(1, 1, 1, 0.1)
	style.set_border_width_all(2)
	style.border_color = _color
	style.corner_radius_top_left = 0
	style.corner_radius_top_right = 0
	return style

#endregion
