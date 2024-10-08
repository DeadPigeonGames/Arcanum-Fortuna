extends Node

@onready var scene_container = $CurrentScene
@onready var inactive_scenes = $InactiveScenes
@onready var ui_container = $UIContainer

var current_scene
var combat : CardBattle
var current_ui_window
var current_dialogic : DialogicLayoutBase

func _ready():
	await get_tree().root.ready
	get_tree().current_scene.reparent(scene_container)
	current_scene = get_tree().current_scene

	#Dialogic.Text.about_to_show_text.connect(SceneHandler.on_upcoming_text)


func change_scene(new_scene):
	for child in scene_container.get_children():
		child.queue_free()
	
	for child in inactive_scenes.get_children():
		child.queue_free()
	
	for child in ui_container.get_children():
		child.queue_free()
	
	var scene_to_change = get_instantiated_scene(new_scene)
	current_scene = scene_to_change
	scene_container.add_child(current_scene)


func add_inactive_scenes_element(element):
	var element_to_add = get_instantiated_scene(element)
	inactive_scenes.add_child(element_to_add)


func add_ui_element(element):
	var element_to_add = get_instantiated_scene(element)
	ui_container.add_child(element_to_add)
	return element_to_add


func set_visibility_ui_container(value : bool):
	for canvas_layer in ui_container.get_children():
		if value:
			canvas_layer.show()
		else:
			canvas_layer.hide()


func get_instantiated_scene(element):
	var element_to_add
	if element is PackedScene:
		element_to_add = element.instantiate()
	elif element is Node:
		element_to_add = element
	elif element is String:
		element_to_add = load(element).instantiate()
	
	return element_to_add


static func trigger_dialog(dialog : DialogicTimeline):
	if not dialog:
		return
	SceneHandler.set_visibility_ui_container(false)
	ScreenFade.tint_screen(Color.BLACK, 0.8, 1.0)
	var scene = Dialogic.start(dialog)
	SceneHandler.set_current_dialogic(scene)
	await SceneHandler.get_tree().process_frame
	Dialogic.paused = false
	await Dialogic.timeline_ended
	ScreenFade.reset_tint(0.2)
	await ScreenFade.tint_complete
	SceneHandler.set_visibility_ui_container(true)
	SceneHandler.set_current_dialogic(null)


static func on_upcoming_text(info: Dictionary):
	if (info["character"].display_name == "You"):
		Dialogic.get_subsystem("Styles").change_style("arcanum_fortuna_style_backup")
	else:
		Dialogic.get_subsystem("Styles").change_style("StyleOtherSpeaker")
	Dialogic.get_subsystem("Styles").reload_current_info_into_new_style()
	Dialogic.paused = false 


func get_current_ui_window():
	return current_ui_window


func set_current_ui_window(ui_window : UIBase):
	current_ui_window = ui_window


func get_current_dialogic():
	return current_dialogic


func set_current_dialogic(dialogic_scene : DialogicLayoutBase):
	current_dialogic = dialogic_scene
