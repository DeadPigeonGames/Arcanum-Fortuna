class_name SettingsData extends Node

static var settingsDict : Dictionary:
	set(value):
		push_error("ERROR: Tried accessing SettingsData dict, not allowed!")

var fileExtension = ".json"
var savePath = "user://config" + fileExtension


func _ready():
	if load_test() == false:
		settingsDict["Audio"] = get_default_audio_dict()
		settingsDict["Video"] = get_default_video_dict()
		save_config()


func get_settings_dict():
	return settingsDict


func get_default_audio_dict():
	var dict : Dictionary
	var audio_busses = ["Master", "Music", "BackgroundFX", "UI", "VFX", "VFX Echo", "Voices"]
	
	for bus in audio_busses:
		var bus_idx = AudioServer.get_bus_index(bus)
		if bus_idx == -1:
			push_error("BUS %s NOT FOUND!!!" % bus)
			continue
		if not dict.has(bus_idx):
			dict[bus] = AudioServer.get_bus_volume_db(bus_idx)
	return dict


func get_default_video_dict():
	var dict : Dictionary
	
	dict["resolution"] = DisplayServer.window_get_size()
	dict["window_mode"] = DisplayServer.window_get_mode()
	dict["window_pos"] = DisplayServer.window_get_position()
	
	return dict


func save_config():
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	
	var json = JSON.stringify(settingsDict, "\n", true, false)
	file.store_string(json)
	file.close()


func load_test():
	if not FileAccess.file_exists(savePath):
		print("No config save file found, creating a new one")
		return false
	
	var file = FileAccess.open(savePath, FileAccess.READ)
	
	var json = JSON.new()
	var json_string = file.get_as_text()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
	var data = json.get_data()
	settingsDict.merge(data, true)
	file.close()
	
	var dict : Dictionary
	dict.merge(settingsDict["Audio"])
	
	for key in settingsDict["Audio"].keys():
		var bus_idx := AudioServer.get_bus_index(key)
		if bus_idx == -1:
			push_error("BUS %s NOT FOUND!!!" % bus_idx)
			continue
		AudioServer.set_bus_volume_db(bus_idx, dict[key] as float)
	return true


func set_video_resolution(resolution):
	if resolution is Vector2i:
		settingsDict["Video"]["resolution"] = resolution
	else:
		push_error("ERROR: resolution not Vector2i")


func get_video_resolution():
	return settingsDict["Video"]["resolution"] as Vector2i


func set_window_mode(mode):
	if mode is DisplayServer.WindowMode:
		settingsDict["Video"]["window_mode"] = mode
	else:
		push_error("ERROR: mode not DisplayServer.WindowMode")


func get_window_mode():
	return settingsDict["Video"]["window_mode"] as DisplayServer.WindowMode


func set_window_position(position):
	if position is Vector2i:
		settingsDict["Video"]["window_pos"] = position
	else:
		push_error("ERROR: position not Vector2i")


func get_window_position():
	return settingsDict["Video"]["window_pos"] as Vector2i


func set_audio_slider(bus_name, value):
	settingsDict["Audio"][bus_name] = value
	save_config()


func get_audio_slider(bus_name):
	return settingsDict["Audio"][bus_name] as float
