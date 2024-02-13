class_name ShopBurnSection
extends UITabBase

@export var card_prize := 4
@export var all_cards_resource : AllCards
@export var burn_card_1 : ShopPreviewCard

var player_data : PlayerData
var burn_button
 

func setup():
	player_data = Player.instance.data
	burn_button = $BurnButton
	burn_card_1.card_data = all_cards_resource.all_cards.pick_random()
	burn_button.disabled = player_data.currency < card_prize


func bla():
	pass
