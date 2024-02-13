class_name NodeMap
extends Control

var rng: RandomNumberGenerator
var level := 0.0


func init(rng_seed, rng_text):
	rng = RandomNumberGenerator.new()
	rng.seed = rng_seed
	$CanvasLayer/SeedLabel.set_seed(rng_text)
	setup_ui()


func setup_ui():
	var deck_in_menu = SceneHandler.add_ui_element("res://systems/ui/menus/deck_in_menu.tscn") as DeckInMenu
	deck_in_menu.init(50, self)
	deck_in_menu.setup()


func _on_node_activated(node : EventNode):
	node.init(level, rng)


func _on_node_completed(node : EventNode):
	level += node.level_gain
