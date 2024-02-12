class_name DeckPreviewOverlay
extends UIBase


var player_data : PlayerData
var card_lookup = {}

@onready var animation_player = %AnimationPlayer

func setup_player_data(player_data : PlayerData):
	self.player_data = player_data
	get_cards()


func setup():
	animation_player.play("open_deck_preview")


func get_cards():
	self.card_lookup.clear()
	for card in player_data.cardStack:
		if card_lookup.keys().has(card):
			card_lookup[card] += 1
		else:
			card_lookup[card] = 1
	
	for card in card_lookup.keys():
		print("Card: ", card, " x ", card_lookup[card])


func _on_close_window_button_button_up():
	animation_player.play("close_deck_preview")
	await animation_player.animation_finished
	close()

