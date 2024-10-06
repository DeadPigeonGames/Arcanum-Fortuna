class_name SelectCard
extends Card

signal clicked

@export var selected_shader : ColorRect

var selected := false
var is_selectable = true

@onready var base_scale = scale


func _input(event):
	if is_hovered and event.is_action_released("ui_rmb"):
		var new_inspection = inspection.instantiate() as CardInspection
		new_inspection.init(UIBase.UICLayerIndex.GAME_ELEMENT + 5, self)
		new_inspection.setup(self)
		SceneHandler.add_ui_element(new_inspection)
	
	if is_selectable and is_hovered and event.is_action_pressed("ui_lmb"):
		self.selected = not selected
		self.selected_shader.visible = selected
		clicked.emit(self)


func select():
	self.selected = true
	self.selected_shader.visible = true


func deselect():
	self.selected = false
	self.selected_shader.visible = false


func _process(delta):
	if is_hovered:
		scale = scale.lerp(base_scale * 1.1, 0.2)
	elif selected:
		scale = scale.lerp(base_scale * 1.05, 0.2)
	else:
		scale = scale.lerp(base_scale, 0.2)
