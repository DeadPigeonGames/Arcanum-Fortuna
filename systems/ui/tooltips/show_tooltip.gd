class_name ShowTooltip
extends Control

@export_category("Tooltip Settings")
@export var icon: Texture2D
@export var title := "Tooltip"
@export_multiline var text := "Lorem Ipsum... dolor sit amet..."
@export var tooltip_template := preload("res://Systems/UI/tooltips/tooltip_basic.tscn")
@export var offset := Vector2.ZERO


@export_subgroup("Trigger Settings")
@export var trigger_automatically := true
@export_flags("Hover Duration", "Right-Click") var trigger_mode := 0b11
@export var hover_min_duration := 0.5
var hovering := false
@onready var cooldown := hover_min_duration
var instance: TooltipBasic = null

static var tooltip_container = null

func show_tooltip():
	if not tooltip_container:
		tooltip_container = CanvasLayer.new()
		tooltip_container.name = "tooltip_container"
		tooltip_container.layer = 10
		get_tree().root.add_child(tooltip_container)

	if not instance:
		instance = tooltip_template.instantiate() as TooltipBasic
		instance.setup(title, icon, text)
		tooltip_container.add_child(instance)
		instance.global_position = get_global_mouse_position() + offset


func hide_tooltip():
	if instance:
		instance.queue_free()
		instance = null


func _input(event: InputEvent):
	if not trigger_automatically:
		return
	
	if not (trigger_mode & 0b1 << 1):
		return
	
	if event.is_action_pressed("show_tooltip"):
		if hovering:
			show_tooltip()

func _process(delta):
	if not trigger_automatically:
		return
	
	var parent_control = get_parent_control()
	if not parent_control:
		return
	
	if "hovering" in parent_control:
		hovering = parent_control.hovering
	else:
		hovering = (
				Rect2(Vector2(), parent_control.get_rect().size)
				.has_point(parent_control.get_local_mouse_position())
			)
	
	if hovering:
		cooldown -= delta
	else:
		cooldown = hover_min_duration
		hide_tooltip()
	
	if cooldown <= 0 and trigger_mode & 0b1:
		show_tooltip()