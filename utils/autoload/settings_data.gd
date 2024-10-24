class_name SettingsData
extends Node

## 1.0 is 100 %, 0.5 is 150% speed and 2.0 is 50% speed.
## For animation players, this will increase the playback time
var animation_time := 1.0


var settings_dict : Dictionary:
	set(value):
		push_error("[SettingsData] ERROR: Tried accessing SettingsData dict, not allowed!")


var fileExtension = ".json"
var savePath = "user://config" + fileExtension


func _ready():
	if load_config() == false:
		save_config()
	animation_time = get_anim_speed()


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_DRAG_END:
		await save_config()


func get_settings_dict():
	return settings_dict


func get_current_audio_dict():
	var dict : Dictionary
	var audio_busses = ["Master", "Music", "Ambience", "SFX", "Diagetics", "SFXOther", "Signature", "UI"]
	
	for bus in audio_busses:
		var bus_idx = AudioServer.get_bus_index(bus)
		if bus_idx == -1:
			push_error("[SettingsData] BUS %s NOT FOUND!!!" % bus)
			continue
		if not dict.has(bus_idx):
			dict[bus] = AudioServer.get_bus_volume_db(bus_idx)
	return dict


func get_current_video_dict():
	var dict : Dictionary
	
	var resolution = DisplayServer.window_get_size()
	dict["resolution"] = resolution
	dict["window_mode"] = DisplayServer.window_get_mode()
	var pos = DisplayServer.window_get_position_with_decorations()
	dict["window_pos"] = pos
	dict["screen_index"] = DisplayServer.window_get_current_screen()
	
	return dict


func save_config():
	settings_dict["Audio"] = get_current_audio_dict()
	settings_dict["Video"] = get_current_video_dict()
	set_anim_speed(Settings.animation_time)
	
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	
	var json = JSON.stringify(settings_dict, "\n", true, false)
	file.store_string(json)
	file.close()


func load_config():
	if not FileAccess.file_exists(savePath):
		print("[SettingsData] No config save file found, creating a new one")
		return false
	
	var file = FileAccess.open(savePath, FileAccess.READ)
	
	var json = JSON.new()
	var json_string = file.get_as_text()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("[SettingsData] JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
	var data = json.get_data()
	settings_dict.merge(data, true)
	file.close()
	return true


func get_loaded_audiosettings():
	return settings_dict["Audio"]


func get_loaded_videosettings():
	return settings_dict["Video"]


func set_video_resolution(resolution):
	if resolution is Vector2i:
		settings_dict["Video"]["resolution"] = resolution
	else:
		push_error("[SettingsData] ERROR: resolution not Vector2i")


func get_video_resolution():
	var retVal := Vector2i.ZERO
	var resolution
	if settings_dict["Video"].keys().has("resolution") == false:
		resolution = DisplayServer.window_get_size()
		set_video_resolution(resolution)
	resolution = settings_dict["Video"]["resolution"]
	if resolution is Vector2i:
		retVal = resolution
	elif resolution is String:
		var chars = ["(",")",","]
		for char in chars:
			resolution = resolution.replace(char, "")
		retVal.x = resolution.split(" ")[0] as int
		retVal.y = resolution.split(" ")[1] as int
	return retVal


func set_window_mode(mode):
	if mode is DisplayServer.WindowMode:
		settings_dict["Video"]["window_mode"] = mode
	else:
		push_error("[SettingsData] ERROR: mode not DisplayServer.WindowMode")


func get_window_mode():
	var window_mode
	if settings_dict["Video"].keys().has("window_mode") == false:
		set_window_mode(DisplayServer.window_get_mode())
	window_mode = settings_dict["Video"]["window_mode"]
	return window_mode


func set_window_position(position):
	if position is Vector2i:
		settings_dict["Video"]["window_pos"] = position
	else:
		push_error("[SettingsData] ERROR: position not Vector2i")


func get_window_position():
	var retVal := Vector2i.ZERO
	var window_pos
	if settings_dict["Video"].keys().has("window_pos") == false:
		window_pos = DisplayServer.window_get_position()
		set_window_position(window_pos)
	window_pos = settings_dict["Video"]["window_pos"]
	if window_pos is Vector2i:
		retVal = window_pos
	elif window_pos is String:
		var chars = ["(",")",","]
		for char in chars:
			window_pos = window_pos.replace(char, "")
		retVal.x = window_pos.split(" ")[0] as int
		retVal.y = window_pos.split(" ")[1] as int
	return retVal


func set_screen_index(index):
	if index is int:
		settings_dict["Video"]["screen_index"] = index
	else:
		push_error("[SettingsData] ERROR: screen_index not int")


func get_screen_index():
	if settings_dict["Video"].has("screen_index") == false:
		set_screen_index(DisplayServer.window_get_current_screen())
		var window = get_window()
		window.move_to_center()
	return settings_dict["Video"]["screen_index"] as int


func set_audio_slider(bus_name, value):
	settings_dict["Audio"][bus_name] = value
	save_config()


func get_audio_slider(bus_name):
	return settings_dict["Audio"][bus_name] as float


func get_anim_speed() -> float:
	if settings_dict.has("animation_time"):
		return settings_dict["animation_time"] as float
	else:
		return animation_time


func set_anim_speed(value):
	settings_dict["animation_time"] = value


func get_trigger_tutorial(class_name_string : String) -> bool:
	if settings_dict.has(class_name_string):
		return settings_dict[class_name_string]
	return false


func set_trigger_tutorial(class_name_string : String, value : bool):
	settings_dict[class_name_string] = value
	await save_config()


func get_death_count() -> int:
	return settings_dict["death_count"]


func increase_death_count(amount : int):
	if settings_dict.has("death_count"):
		settings_dict["death_count"] += amount
	else:
		settings_dict["death_count"] = amount
	await save_config()


func has_died_prev_run() -> bool:
	if settings_dict.has("death_prev_run"):
		return settings_dict["death_prev_run"]
	return false


func set_died_prev_run(value : bool):
	settings_dict["death_prev_run"] = value
	await save_config()


func apply_player_anim_speed(anim_player : AnimationPlayer):
	var add_time := 1 - animation_time
	anim_player.speed_scale += add_time
