class_name TutorialWindow
extends TextureRect

signal condition_met

@export var exclude_areas : Array


func show_hide_exclude(value : bool):
	for exclude in exclude_areas:
		exclude.visible = value


func show_tutorial(window_position : Vector2, is_show_next, text):
	position = window_position
	visible = true
	mouse_filter = MOUSE_FILTER_STOP
	%RichTextLabel.text = text
	%NextIndicator.visible = is_show_next


func hide_tutorial():
	visible = false
	mouse_filter = MOUSE_FILTER_IGNORE


func send_condition_met():
	condition_met.emit()


func _on_button_pressed():
	if %NextIndicator.visible == true:
		send_condition_met()
