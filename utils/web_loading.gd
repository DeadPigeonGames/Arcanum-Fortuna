extends Control

@export var objects_paths_to_load : Array[String] = []
static var preloaded_objects : Array[Resource] = []
@export_file("*.tscn") var main_scene = ""

## The whole purpose of this scene is to preload assets that are going to be used later on in the game.
## After completing this scene should kill itself.

signal complete

func _ready():
	$VBoxContainer/ProgressBar.max_value = objects_paths_to_load.size()
	$VBoxContainer/ProgressBar.value = 0
	await get_tree().process_frame
	run()

func run():
	for i in range(objects_paths_to_load.size()):
		$VBoxContainer/ProgressBar.value = i
		preloaded_objects.push_back(load(objects_paths_to_load[i]))
	$KarmaParticle.visible = true
	await get_tree().create_timer(0.5).timeout
	complete.emit()
	await get_tree().process_frame
	queue_free()
