extends Control


@export var potential_node_maps : Array[RandomScene]

var rng: RandomNumberGenerator
var rng_seed_text : String

func init(rng_seed, rng_text):
	rng = RandomNumberGenerator.new()
	rng.seed = rng_seed
	rng_seed_text = rng_text
	RandomScene.init(rng)


func _ready():
	var chosen_map = RandomScene.get_random_from(potential_node_maps).scene.instantiate()
	var player = chosen_map.get_node("Player")
	var remote_transform = RemoteTransform2D.new()
	remote_transform.remote_path = $"../LimitedCamera".get_path()
	player.add_child(remote_transform)
	chosen_map.init(rng.seed, rng_seed_text)
	add_child(chosen_map)
