extends Label

var is_hovered = false
var seed := ""

func set_seed(seed_txt : String):
	seed = seed_txt
	text = "Seed: " + seed


func _process(delta: float) -> void:
	visible = get_global_rect().has_point(get_global_mouse_position())

func _input(event):
	pass
	#if not is_hovered:
		#return
	#if event is InputEventMouseButton && event.is_double_click():
		#self_modulate = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1))
		#var current_clipboard = DisplayServer.clipboard_get()
		#if current_clipboard == seed:
			#return
		#DisplayServer.clipboard_set(seed)


func _on_mouse_entered():
	pass
	#is_hovered = true
	#scale = Vector2(1, 1.1)


func _on_mouse_exited():
	pass
	#is_hovered = false
	#scale = Vector2.ONE
