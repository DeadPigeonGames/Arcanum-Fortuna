class_name TutorialOverlay
extends Control

@export var is_show_next : bool

var background_dim
var tween : Tween
var tutorial_window : TutorialWindow


func _ready():
	background_dim = %BackgroundDim
	tutorial_window = %TutorialWindow
	background_dim.mouse_filter = MOUSE_FILTER_IGNORE


func fade_background(value, duration):
	var color := Color.BLACK
	color.a = value
	print(background_dim.color)
	tween = self.create_tween()
	tween.tween_property(background_dim, "color", color, duration).from_current()


func show_tutorial(window_position : Vector2, is_show_next, text):
	tutorial_window.visible = true
	tutorial_window.mouse_filter = MOUSE_FILTER_STOP
	tutorial_window.show_tutorial(window_position, is_show_next, text)
	background_dim.mouse_filter = MOUSE_FILTER_STOP


func hide_tutorial():
	tutorial_window.mouse_filter = MOUSE_FILTER_IGNORE
	tutorial_window.visible = false
	background_dim.mouse_filter = MOUSE_FILTER_IGNORE
