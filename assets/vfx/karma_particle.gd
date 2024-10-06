extends GPUParticles2D


func _ready() -> void:
	lifetime *= Settings.animation_time
	lifetime = clampf(lifetime, 0.01, lifetime)


func set_text(new_text):
	$text.text = new_text
	$text.visible = true


func set_color(new_color: Color):
	modulate = new_color
