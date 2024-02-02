class_name TutorialWindow
extends TextureRect

signal condition_met

@export var tutorial_name : String
@export var exclude_areas : Array[ColorRect]
@export var is_show_next : bool

func _ready():
	if is_show_next:
		%NextIndicator.visible = true


func show_hide_exclude(value : bool):
	for exclude in exclude_areas:
		exclude.visible = value
		exclude.mouse_filter == MOUSE_FILTER_IGNORE
		if value:
			exclude.mouse_filter == MOUSE_FILTER_STOP


func show_tutorial():
	visible = true
	mouse_filter = MOUSE_FILTER_STOP


func hide_tutorial():
	visible = false
	mouse_filter = MOUSE_FILTER_IGNORE


func send_condition_met():
	condition_met.emit()


func _on_button_pressed():
	if is_show_next == true:
		send_condition_met()
