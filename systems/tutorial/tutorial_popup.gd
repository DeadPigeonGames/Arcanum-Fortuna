class_name TutorialPopup
extends Control

signal completed

var highlighted_elements : Array[Node]
var clickable_rects : Array[Rect2]
var data : TutorialPopupData
var combat : CardBattle

@onready var container := %MarginContainer
@onready var arrow := %Arrow
@onready var title := %Title
@onready var text := %Text

#region override functions


func init(data : TutorialPopupData, combat : CardBattle):
	self.data = data
	self.combat = combat
	title.text = data.title
	text.text = data.text
	
	for node_path in data.highlighted_elements:
		highlighted_elements.append(combat.get_node(node_path))
	for node in highlighted_elements:
		clickable_rects.append((node as Control).get_global_rect())
	await get_tree().process_frame
	var position = get_viewport_rect().get_center()
	if highlighted_elements.size() > 0:
		position = highlighted_elements[0].get_global_rect().get_center()
		setup_arrow_position()
	setup_window_position(position)
	highlight_elements(true)


func execute():
	push_error("ERROR: NO IMPLEMENTATION! (USED BASE POPUP)")
	pass


#endregion


func highlight_elements(value : bool):
	for node in highlighted_elements:
		node.set_z_index(100 if value else 0)



func get_offset_type_rotation(offset_type : TutorialPopupData.OffsetType):
	var rotation
	
	match offset_type:
		TutorialPopupData.OffsetType.UP:
			rotation = 90
		TutorialPopupData.OffsetType.DOWN:
			rotation = 270
		TutorialPopupData.OffsetType.LEFT:
			rotation = 0
		TutorialPopupData.OffsetType.RIGHT:
			rotation = 180
	
	return rotation


func get_offset_type_position(offset_type : TutorialPopupData.OffsetType, distance : float):
	var offset = Vector2.ZERO
	
	match offset_type:
		TutorialPopupData.OffsetType.UP:
			offset.y = -distance
		TutorialPopupData.OffsetType.DOWN:
			offset.y = distance
		TutorialPopupData.OffsetType.LEFT:
			offset.x = -distance
		TutorialPopupData.OffsetType.RIGHT:
			offset.x = distance
	
	return offset


func setup_window_position(position : Vector2):
	global_position = position
	#global_position = highlighted_elements[0].get_global_rect().get_center()
	var center = container.size / 2
	position.x -= center.x
	position.y -= center.y
	var offset = get_offset_type_position(data.offset_type, data.distance)
	position += offset


func setup_arrow_position():
	arrow.visible = true
	arrow.position = container.size / 2
	var internal_offset = (container.size.x / 2) + 20
	arrow.position.x += internal_offset
	arrow.pivot_offset.x -= internal_offset
	arrow.rotation_degrees = get_offset_type_rotation(data.offset_type)
