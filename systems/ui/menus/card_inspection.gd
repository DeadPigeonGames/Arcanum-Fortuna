class_name CardInspection
extends Control

signal inspection_closed

@export var default_icon : Texture
@export var switched_icon : Texture

var card : Card
var is_switched := false
var switch_keyword : SwitchKeyword


func init(card_to_display: Card):
	card = card_to_display
	var card_data = card_to_display.card_data
	%PreviewCard.load_from_data(card_to_display.card_data)
	%PreviewCard.scale = Vector2(2.56, 2.56)
	$CardFlavour/CardFlavourText.text = card_data.description
	$SwitchCondition.hide()
	update_keyword_labels()


func update_keyword_labels():
	for i in range(4):
		var keyword_label = get_node("KeywordDescriptions/VBoxContainer/Label%d" % (i+1))
		if i >= %PreviewCard.keywords.size():
			keyword_label.text = ""
			continue
		var keyword = %PreviewCard.keywords[i]
		if %PreviewCard.keywords[i] is SwitchKeyword:
			switch_keyword = %PreviewCard.keywords[i]
			$SwitchCondition/Label.text = "[b]%s -[/b] %s"
			$SwitchCondition.show()
			$SwitchCondition/Label.text = $SwitchCondition/Label.text % [keyword.title, keyword.description]
			keyword_label.text = ""
			continue
		keyword_label.text = "[b]%s -[/b] %s"
		keyword_label.text = keyword_label.text % [keyword.title, keyword.description]


func _on_close_window_button_button_down():
	inspection_closed.emit()
	queue_free()


func _on_switch_button_button_down():
	if not switch_keyword:
		return
	is_switched = not is_switched
	if is_switched:
		%SwitchButton.icon = switched_icon
		%PreviewCard.modify_keywords(switch_keyword.keywords_to_remove, switch_keyword.keywords_to_gain)
		%PreviewCard.set_transformed_visuals(switch_keyword.transformed_artwork_shader, \
				switch_keyword.transformed_keyword_slot_atlas)
	else:
		%PreviewCard.modify_keywords(switch_keyword.keywords_to_gain, switch_keyword.keywords_to_remove)
		%SwitchButton.icon = default_icon
		%PreviewCard.set_default_visuals()
	await get_tree().process_frame
	update_keyword_labels()
