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
		if i >= card.keywords.size():
			get_node("KeywordDescriptions/VBoxContainer/Label%d" % (i+1)).text = ""
			continue
		var keyword = card.keywords[i]
		if card.keywords[i] is SwitchKeyword:
			$SwitchCondition.show()
			$SwitchCondition/Label.text = keyword.title + "\n" + keyword.description
			get_node("KeywordDescriptions/VBoxContainer/Label%d" % (i+1)).text = ""
			continue
		get_node("KeywordDescriptions/VBoxContainer/Label%d" % (i+1)).text = keyword.title + "\n"
		get_node("KeywordDescriptions/VBoxContainer/Label%d" % (i+1)).text += keyword.description

func _on_close_window_button_button_down():
	queue_free()
