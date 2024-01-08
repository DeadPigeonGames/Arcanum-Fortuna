extends Node

@export var track = "the_wanderer_day"

func _ready():
	if not AudioManager.is_node_ready():
		await AudioManager.ready
	AudioManager.play_music(track)
