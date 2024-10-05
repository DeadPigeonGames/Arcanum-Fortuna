class_name TooltipBase
extends Control

@export var mouse_offset : Vector2

var viewport : Viewport


func _ready():
	viewport = get_viewport()


func _process(delta):
	move_to_mouse_pos(self.get_rect())


func move_to_mouse_pos(tooltip_rect : Rect2):
	var target_position = get_global_mouse_position()
	var max_size = viewport.get_visible_rect().size - tooltip_rect.size
	if target_position.x > max_size.x:
		target_position.x -= tooltip_rect.size.x
		target_position.x -= mouse_offset.x
	else:
		target_position.x += mouse_offset.x
	if target_position.y > max_size.y:
		target_position.y -= tooltip_rect.size.y
	target_position.y += mouse_offset.y
	global_position = target_position
