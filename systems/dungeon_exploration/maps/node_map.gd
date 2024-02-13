class_name NodeMap
extends Control

var rng: RandomNumberGenerator
var level := 0.0


func init(rng_seed, rng_text):
	rng = RandomNumberGenerator.new()
	rng.seed = rng_seed
	$CanvasLayer/SeedLabel.set_seed(rng_text)


func _on_node_activated(node : EventNode):
	node.init(level, rng)


func _on_node_completed(node : EventNode):
	level += node.level_gain
