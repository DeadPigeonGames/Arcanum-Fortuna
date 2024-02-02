extends Control

@export var scenes_to_preload : Array[PackedScene]
@export_file("*.tscn") var main_scene = ""

## The whole purpose of this scene is to preload assets that are going to be used later on in the game.
## After completing this scene should kill itself.

signal complete

func _ready():
	$VBoxContainer/ProgressBar.max_value = scenes_to_preload.size()
	$VBoxContainer/ProgressBar.value = 0
	await get_tree().create_timer(0.5).timeout
	run()

func run():
	$VBoxContainer/LoadInfo.show()
	for i in range(scenes_to_preload.size()):
		$VBoxContainer/LoadInfo.text = "Loading " + \
				scenes_to_preload[i].resource_path + "..."
		await get_tree().create_timer(1).timeout
		$LoadedStorage.add_child(scenes_to_preload[i].instantiate())
		$VBoxContainer/ProgressBar.value = i + 1
	await get_tree().create_timer(0.5).timeout
	complete.emit()
	await get_tree().process_frame
	queue_free()
