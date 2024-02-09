class_name SelectCard
extends Card

signal clicked


var isHovered := false
var selected := false

@onready var base_scale = scale
@export var inspection := preload("res://systems/ui/menus/card_inspection.tscn")

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
		var new_inspection = inspection.instantiate()
		new_inspection.init(self)
		get_parent().get_parent().get_parent().add_child(new_inspection)
	
	if isHovered and event.is_action_pressed("pickUpCard"):
		clicked.emit(self)
