extends OptionButton

@export var resolutions: Array[Vector2i] = []


# Called when the node enters the scene tree for the first time.
func _ready():
	var screen = Rect2i(Vector2i.ZERO, DisplayServer.screen_get_size())
	var current_size = DisplayServer.window_get_size()
	for i in range(len(resolutions)):
		if screen.encloses(Rect2i(Vector2i.ZERO, resolutions[i])):
			add_item(str(resolutions[i]), i)
		if current_size == resolutions[i]:
			selected = i


func _on_item_selected(index):
	var desired = resolutions[index]
	if desired == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		DisplayServer.window_set_size(DisplayServer.screen_get_size())
		DisplayServer.window_set_position(Vector2i.ZERO)
	if desired != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_size(desired)


func _process(delta):
	var window_mode = DisplayServer.window_get_mode()
	disabled = window_mode != DisplayServer.WINDOW_MODE_WINDOWED
