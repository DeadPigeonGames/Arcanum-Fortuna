class_name VideoOptions
extends Control

var resolutions: Array[Vector2i] = \
[
	Vector2i(800, 600),
	Vector2i(1024, 768),
	Vector2i(1280, 720),
	Vector2i(1366, 768),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440)
]

var options = {
	"Windowed": DisplayServer.WINDOW_MODE_WINDOWED,
	"Borderless": DisplayServer.WINDOW_MODE_FULLSCREEN,
	"Fullscreen": DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
}

var window_mode_box : OptionButton 
var resolution_box : OptionButton
var os_resolution


func setup():
	window_mode_box = $Options/WindowMode/OptionButton
	resolution_box = $Options/Resolution/OptionButton
	setup_animation_speed_slider()
	setup_window_mode_box()
	select_current_window_mode()
	add_resolutions()
	setup_supported_resolutions()
	select_current_resolution()


func setup_window_mode_box():
	var current_mode = DisplayServer.window_get_mode()
	if not window_mode_box.has_selectable_items():
		for key : String in options.keys():
			var value = options[key]
			key = key.insert(0, "  ")
			window_mode_box.add_item(key, value)


func select_current_window_mode():
	for value in options.values():
		if DisplayServer.window_get_mode() == value:
			var idx = window_mode_box.get_item_index(value)
			window_mode_box.selected = idx


func apply_window_mode():
	var desired = window_mode_box.get_selected_id()
	DisplayServer.window_set_mode(desired)
	Settings.save_config()


func select_current_resolution():
	var current_size = DisplayServer.window_get_size()
	for i in range(len(resolutions)):
		if current_size == resolutions[i]:
			resolution_box.selected = i
		elif current_size > resolutions[i]:
			resolution_box.selected = resolutions.size() - 1


func setup_supported_resolutions():
	var viewport_rect = get_viewport_rect()
	var current_screen = DisplayServer.get_screen_from_rect(viewport_rect)
	os_resolution = DisplayServer.screen_get_size(current_screen)
	for res in resolutions:
		if os_resolution < res:
			resolutions.erase(res)


func apply_resolution():
	if DisplayServer.window_get_mode() != \
		DisplayServer.WINDOW_MODE_WINDOWED:
			return
	var desired = resolutions[resolution_box.selected]
	if desired >= DisplayServer.screen_get_size():
		desired = DisplayServer.screen_get_usable_rect().size # Without Taskbar
	var window = get_window()
	window.set_size(desired)
	window.move_to_center()
	Settings.save_config()


func add_resolutions():
	if resolution_box.has_selectable_items():
		return
	var screen = Rect2i(Vector2i.ZERO, DisplayServer.screen_get_size())
	for i in range(len(resolutions)):
		if screen.encloses(Rect2i(Vector2i.ZERO, resolutions[i])):
			var key = "  " + str(resolutions[i].x) + " x " + str(resolutions[i].y)
			resolution_box.add_item(key, i)


func setup_animation_speed_slider():
	var value = (2.0 - Settings.animation_time)
	set_animation_speed_label(value)


func set_animation_speed_label(value):
	var percent = 100 * value
	var text = str(percent) + " %"
	text = text.replace("-", "")
	$Options/AnimationSpeed/HBoxContainer/Label.text = text
	$Options/AnimationSpeed/HBoxContainer/HSlider.value = value


func _on_apply_button_up():
	apply_window_mode()
	apply_resolution()
	var value = $Options/AnimationSpeed/HBoxContainer/HSlider.value
	Settings.animation_time = 2.0 - value


func _on_visibility_changed():
	if visible:
		setup()


func _on_option_button_item_selected(index: int) -> void:
	$Options/WarningLabel.text = ""
	if window_mode_box.get_selected_id() != DisplayServer.WINDOW_MODE_WINDOWED:
		$Options/WarningLabel.text =\
		"[Borderless] and [Fullscreen] will use your device resolution instead. "\
		 + str(DisplayServer.screen_get_size())


func _on_h_slider_value_changed(value: float) -> void:
	set_animation_speed_label(value)
