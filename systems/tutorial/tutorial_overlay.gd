class_name TutorialOverlay
extends Control

var background_dim
var tween : Tween
var tutorial_windows : Array[TutorialPopup]


func _ready():
	background_dim = %BackgroundDim
	get_all_tutorial_windows()
	for node in tutorial_windows:
		print(node)
	background_dim.mouse_filter = MOUSE_FILTER_IGNORE


func get_all_tutorial_windows():
	for node in get_children():
		if node.has_method("hide_tutorial"):
			node.hide_tutorial()
			tutorial_windows.append(node)


func fade_background(value, duration):
	var color := Color.BLACK
	color.a = value
	print(background_dim.color)
	tween = self.create_tween()
	tween.tween_property(background_dim, "color", color, duration).from_current()
	tween.finished.emit()


func get_tutorial_window_by_name(name : String):
	for node in tutorial_windows:
		if node.tutorial_name == name:
			return node
