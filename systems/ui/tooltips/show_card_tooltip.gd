class_name ShowCardTooltip
extends ShowTooltip

var card_data : CardData

func _physics_process(delta: float) -> void:
	await get_tree().process_frame
	var rectangle = get_parent().get_global_rect()
	is_hovered = rectangle.has_point(get_global_mouse_position())


func init(data : CardData):
	card_data = data


func create_instance(value):
	if value == null:
		return null
	var new_instance = value as CardTooltip
	new_instance.setup(card_data)
	return new_instance


func _on_mouse_entered():
	is_hovered = true


func _on_mouse_exited():
	is_hovered = false
