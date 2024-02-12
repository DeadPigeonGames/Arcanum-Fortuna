extends Control

@export var node_map_scene : PackedScene
@export var tutorial_scene : PackedScene
@export var options_scene : PackedScene
@export var credits_scene : PackedScene
var node_map : NodeMapGenerator
var seed := 0


func _ready():
	node_map = node_map_scene.instantiate()
	randomize()
	seed = randi()
	#$SeedInput.text = str(seed)
	GlobalLog.set_context(GlobalLog.Context.MENU)
	GlobalLog.add_entry("Main Menu loaded.")


func _on_seed_input_text_changed(new_text : String):
	seed = 0
	for i in range(new_text.length()):
		seed += new_text.unicode_at(i)


func _on_start_button_button_up():
	node_map.rng_seed = seed
	node_map.get_node("Generator").random_seed = false
	#node_map.rng_seed_text = $SeedInput.text
	#GlobalLog.add_entry("Seed used: " + $SeedInput.text)
	SceneHandler.change_scene(node_map)


func _on_tutorial_button_button_up():
	SceneHandler.change_scene(tutorial_scene)
	var tutorial : CardBattle = SceneHandler.current_scene
	SceneHandler.combat = tutorial


func _on_options_button_button_up():
	var options = options_scene.instantiate() as OptionsMenu
	options.init(1, self)
	options.setup()
	SceneHandler.add_ui_element(options)


func _on_prepare_button_button_up():
	print("Nada!")


func _on_credits_button_button_up():
	var credits = credits_scene.instantiate() as CreditsScreen
	credits.init(1, self)
	credits.setup()
	SceneHandler.add_ui_element(credits)


func _on_quit_button_button_up():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
