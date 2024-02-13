class_name ShopBuySection
extends UITabBase

@export var possible_cards: Array[CardData]
@export var confirm_pay_data : UIPopupData
@export var shop_card_1 : ShopPreviewCard
@export var shop_card_2 : ShopPreviewCard
@export var shop_card_3 : ShopPreviewCard
@export var card_prize := 5

var player_data : PlayerData


func setup():
	player_data = Player.instance.data
	player_data.currency = 30
	randomize()
	shop_card_1.card_data = possible_cards.pick_random()
	shop_card_2.card_data = possible_cards.pick_random()
	shop_card_3.card_data = possible_cards.pick_random()


func _on_pay_button_button_up():
	confirm_buy()


func confirm_buy():
	var cards : Array[ShopPreviewCard]
	if shop_card_1.selected:
		cards.append(shop_card_1)
	if shop_card_2.selected:
		cards.append(shop_card_2)
	if shop_card_3.selected:
		cards.append(shop_card_3)
	
	super.send_result(cards)
	process_buy(cards)


func process_buy(cards : Array[ShopPreviewCard]):
	var cost := cards.size() * card_prize
	if cost > player_data.currency:
		return
	player_data.currency -= cost
	for card in cards:
		player_data.cardStack.append(card.card_data)
		card.queue_free()
