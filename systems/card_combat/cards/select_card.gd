class_name SelectCard
extends Card

signal clicked


var isHovered := false
var selected := false

@onready var base_scale = scale

func _ready():
	mouse_entered.connect(mouse_entered_event)
	mouse_exited.connect(mouse_exited_event)


func _process(delta):
	%selected.visible = selected
	if isHovered:
		scale = scale.lerp(base_scale * 1.1, 0.2)
	elif selected:
		scale = scale.lerp(base_scale * 1.05, 0.2)
	else:
		scale = scale.lerp(base_scale, 0.2)


func mouse_entered_event():
	isHovered = true


func mouse_exited_event():
	isHovered = false


func _input(event):
	if is_hovered and event.is_action_pressed("open_inspection"):
		var new_inspection = inspection.instantiate() as CardInspection
		new_inspection.init(75, self)
		new_inspection.inspection_init(self)
		SceneHandler.add_ui_element(new_inspection)
	
	if isHovered and event.is_action_pressed("pickUpCard"):
		clicked.emit(self)
