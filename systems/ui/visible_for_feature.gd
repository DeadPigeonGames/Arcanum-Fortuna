extends Node

@export_enum("Show: 1", "Hide: 0") var show_or_hide = 1
@export var feature := "web"

func _ready():
	if OS.has_feature(feature):
		get_parent().visible = show_or_hide
