class_name DeckPreviewHBox
extends HBoxContainer


func try_add_card(deck_card_instance):
	if get_child_count() > 4:
		return false
	
	add_child(deck_card_instance)
	
	return true
