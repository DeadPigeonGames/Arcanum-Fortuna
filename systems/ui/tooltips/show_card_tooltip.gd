class_name ShowCardTooltip
extends ShowTooltip

var card_data : CardData

func _physics_process(delta: float) -> void:
	if get_parent() is HandCard:
		if SceneHandler.get_current_ui_window() or SceneHandler.get_current_dialogic():
			is_hovered = false
			return
		var value := false
		if instance and instance.card_data.name == get_parent().card_data.name:
			value = true
		if not tooltip_container:
			value = true
		if tooltip_container and tooltip_container.get_child_count() == 0:
			value = true
		if value:
			await get_tree().process_frame
			var rectangle = get_parent().get_global_rect()
			is_hovered = rectangle.has_point(get_global_mouse_position())
		else:
			is_hovered = false
			return


func init(data : CardData):
	card_data = data


func create_instance(value):
	if value == null:
		return null
	var new_instance = value as CardTooltip
	new_instance.setup(card_data)
	return new_instance


func _on_mouse_entered():
	if not get_parent() is HandCard:
		is_hovered = true


func _on_mouse_exited():
	if not get_parent() is HandCard:
		is_hovered = false
