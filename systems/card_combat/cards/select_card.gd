class_name SelectCard
extends Card

signal clicked

@export var selected_shader : ColorRect

var selected := false

@onready var base_scale = scale


func _input(event):
	if is_hovered and event.is_action_pressed("open_inspection"):
		var new_inspection = inspection.instantiate() as CardInspection
		new_inspection.init(75, self)
		new_inspection.inspection_init(self)
		SceneHandler.add_ui_element(new_inspection)
	
	if is_hovered and event.is_action_pressed("pickUpCard"):
		clicked.emit(self)
		self.selected = not selected
		self.selected_shader.visible = selected


func _process(delta):
	if is_hovered:
		scale = scale.lerp(base_scale * 1.1, 0.2)
	elif selected:
		scale = scale.lerp(base_scale * 1.05, 0.2)
	else:
		scale = scale.lerp(base_scale, 0.2)
