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


func _on_seed_input_text_changed(new_text : String):
	seed = 0
	for i in range(new_text.length()):
		seed += new_text.unicode_at(i)


func _on_start_button_button_down():
	node_map.rng_seed = seed
	node_map.get_node("Generator").random_seed = false
	node_map.rng_seed_text = $SeedInput.text
	GlobalLog.add_entry("Seed used: " + $SeedInput.text)
	SceneHandler.change_scene(node_map)


func _on_tutorial_button_button_down():
	SceneHandler.change_scene(tutorial_scene)
	var tutorial : CardBattle = SceneHandler.current_scene
	SceneHandler.combat = tutorial
	var player_data : PlayerData = load("res://data/player/basic_player.tres")
	var enemy_data : EnemyData = load("res://data/enemy/enemy_basic.tres")
	
	tutorial.init(player_data, enemy_data)
	tutorial.start_combat()


func _on_quit_button_pressed():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


func _on_options_button_pressed():
	var options = options_scene.instantiate()
	add_child(options)
