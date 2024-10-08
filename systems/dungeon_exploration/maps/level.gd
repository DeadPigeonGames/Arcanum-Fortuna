extends Node

@export var node_map_path : NodePath


func init(rng_seed, rng_text):
	get_node(node_map_path).init(rng_seed, rng_text)


func _process(delta: float) -> void:
	%SnowParticles.global_position.y = 0
	%SnowParticles.global_position.x = %LimitedCamera.global_position.x + %LimitedCamera.offset.x
