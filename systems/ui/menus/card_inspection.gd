extends Control

var card : Card

func init(card_to_display: Card):
	card = card_to_display
	var card_data = card_to_display.card_data 
	$Card.card_data = card_data
	$Card.scale = Vector2(2.56, 2.56)
	$CardFlavour/CardFlavourText.text = card_data.description
	$SwitchCondition.hide()
	
	for i in range(4):
		var keyword_label = get_node("KeywordDescriptions/VBoxContainer/Label%d" % (i+1))
		if i >= card.keywords.size():
			keyword_label.text = ""
			continue
		var keyword = card.keywords[i]
		if card.keywords[i] is SwitchKeyword:
			$SwitchCondition.show()
			$SwitchCondition/Label.text = $SwitchCondition/Label.text % [keyword.title, keyword.description]
			keyword_label.text = ""
			continue
		keyword_label.text = keyword_label.text % [keyword.title, keyword.description]

func _on_close_window_button_button_down():
	queue_free()
