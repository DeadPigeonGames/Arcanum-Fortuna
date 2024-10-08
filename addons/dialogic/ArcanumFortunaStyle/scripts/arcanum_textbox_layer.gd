@tool
class_name ArcanumTextBoxLayer
extends VisualNovelTextBoxLayer

const ACTIVE_PATH := "res://addons/dialogic/ArcanumFortunaStyle/name_underlay_active.tres"
const INACTIVE_PATH := "res://addons/dialogic/ArcanumFortunaStyle/name_underlay_inactive.tres"

var left_label_panel
var right_label_panel

var anchor : Control

var name_plate_active : StyleBoxTexture
var name_plate_inactive : StyleBoxTexture

var was_left : bool
var was_right : bool

func _ready() -> void:
	name_plate_active = load(ACTIVE_PATH)
	name_plate_inactive = load(INACTIVE_PATH)
	find_labels(self)
	set_label_active(left_label_panel.get_child(0), true)
	set_label_active(right_label_panel.get_child(0), true)
	set_label_visible(right_label_panel.get_child(0), false)
	anchor.set_z_index(anchor.z_index + 1)


func _process(delta: float) -> void:
	if not left_label_panel:
		return
	var left_label = left_label_panel.get_child(0)
	var given_text : String = left_label.text
	
	if given_text == "":
		set_label_visible(left_label_panel.get_child(0), false)
		set_label_visible(right_label_panel.get_child(0), false)
	if given_text == "You":
		was_left = true
		set_label_visible(left_label_panel.get_child(0), true)
		set_label_visible(right_label_panel.get_child(0), false)
	if given_text != "You":
		was_right = true
		set_label_visible(right_label_panel.get_child(0), true)
		set_label_visible(left_label_panel.get_child(0), false)
	
	if was_left:
		left_label.text = "You"
		set_label_visible(left_label_panel.get_child(0), true)
		
	if was_right:
		set_label_visible(right_label_panel.get_child(0), true)


func apply_name_label_settings_internal(name_label_panel : PanelContainer):
	var name_label : DialogicNode_NameLabel = name_label_panel.get_child(0)
	
	if name_label_use_global_font_size:
		name_label.add_theme_font_size_override(&"font_size", get_global_setting(&'font_size', name_label_custom_font_size) as int)
	else:
		name_label.add_theme_font_size_override(&"font_size", name_label_custom_font_size)

	if name_label_use_global_font and get_global_setting(&'font', false):
		name_label.add_theme_font_override(&'font', load(get_global_setting(&'font', '') as String) as Font)
	elif not name_label_font.is_empty():
		name_label.add_theme_font_override(&'font', load(name_label_font) as Font)

	if name_label_use_global_color:
		name_label.add_theme_color_override(&"font_color", get_global_setting(&'font_color', name_label_custom_color) as Color)
	else:
		name_label.add_theme_color_override(&"font_color", name_label_custom_color)

	name_label.use_character_color = name_label_use_character_color

	if name_label_box_use_global_color:
		name_label_panel.self_modulate = get_global_setting(&'bg_color', name_label_box_modulate)
	else:
		name_label_panel.self_modulate = name_label_box_modulate
	var dialog_text_panel: PanelContainer = %DialogTextPanel
	name_label_panel.position = name_label_box_offset+Vector2(0, -40)
	name_label_panel.position -= Vector2(
		dialog_text_panel.get_theme_stylebox(&'panel', &'PanelContainer').content_margin_left,
		dialog_text_panel.get_theme_stylebox(&'panel', &'PanelContainer').content_margin_top)
	name_label_panel.anchor_left = name_label_alignment/2.0
	name_label_panel.anchor_right = name_label_alignment/2.0
	name_label_panel.grow_horizontal = [1, 2, 0][name_label_alignment]
	pass


func find_labels(start_node):
	if left_label_panel == null or right_label_panel == null:
		for node in start_node.get_children(true):
			if node.name.contains("Left"):
				left_label_panel = node
			if node.name.contains("Right"):
				right_label_panel = node
			if node.name.contains("Anchor"):
				anchor = node
			find_labels(node)


func set_label_active(name_label : DialogicNode_NameLabel, value : bool):
	if value:
		name_label.set_z_index(name_label.z_index + 1)
		name_label.add_theme_stylebox_override(&'normal', name_plate_active)
	else:
		name_label.set_z_index(name_label.z_index - 1)
		name_label.add_theme_stylebox_override(&'normal', name_plate_inactive)


func set_label_visible(name_label : DialogicNode_NameLabel, value : bool):
	name_label.set_visible(value)


func _apply_name_label_settings() -> void:
	find_labels(self)
	apply_name_label_settings_internal(left_label_panel)
	apply_name_label_settings_internal(right_label_panel)
