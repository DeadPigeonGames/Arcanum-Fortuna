class_name TooltipBase
extends Control

@export var mouse_offset = Vector2(25, 25)

func _process(delta):
	move_to_mouse_pos(self.get_rect())


func move_to_mouse_pos(tooltip_rect : Rect2):
	var target_position = get_global_mouse_position() + mouse_offset
	var max_size = get_viewport_rect().size - tooltip_rect.size
	target_position.x = clampf(target_position.x, 0, max_size.x)
	target_position.y = clampf(target_position.y, 0, max_size.y)
	global_position = target_position
