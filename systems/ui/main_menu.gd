extends Control

@export var node_map_scene : PackedScene
@export var tutorial_scene : PackedScene
@export var options_scene : PackedScene
var node_map : NodeMapGenerator
var seed := 0

func _ready():
	node_map = node_map_scene.instantiate()
	randomize()
	seed = randi()
	$SeedInput.text = str(seed)
	GlobalLog.set_context(GlobalLog.Context.MENU)
	GlobalLog.add_entry("Main Menu loaded.")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_seed_input_text_changed(new_text : String):
	seed = 0
	for i in range(new_text.length()):
		seed += new_text.unicode_at(i)


func _on_start_button_button_down():
	node_map.rng_seed = seed
	node_map.get_node("Generator").random_seed = false
	node_map.rng_seed_text = $SeedInput.text
	GlobalLog.add_entry("Seed used: " + $SeedInput.text)
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(node_map)
	get_tree().current_scene = node_map


func _on_tutorial_button_button_down():
	get_tree().change_scene_to_packed(tutorial_scene)


func _on_quit_button_pressed():
	get_tree().quit()


func _on_options_button_pressed():
	var options = options_scene.instantiate()
	add_child(options)
