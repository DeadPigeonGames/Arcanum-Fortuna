class_name ShopTradeSection
extends UITabBase


@export var all_cards_resource : AllCards
@export var shop_card_1 : ShopPreviewCard
@export var shop_card_2 : ShopPreviewCard
@export var shop_card_3 : ShopPreviewCard
@export var hand_card_1 : ShopPreviewCard
@export var hand_card_2 : ShopPreviewCard
@export var hand_card_3 : ShopPreviewCard


var player_data : PlayerData


func setup():
	player_data = Player.instance.data
	player_data.currency = 30
	randomize_shop_cards()
	randomize_hand_cards()
	hand_card_1.selected_shader.color = Color.DARK_BLUE
	hand_card_2.selected_shader.color = Color.DARK_BLUE
	hand_card_3.selected_shader.color = Color.DARK_BLUE
	


func randomize_shop_cards():
	randomize()
	var possible_cards = all_cards_resource.all_cards
	shop_card_1.card_data = possible_cards.pick_random()
	shop_card_2.card_data = possible_cards.pick_random()
	shop_card_3.card_data = possible_cards.pick_random()
	


func randomize_hand_cards():
	var card_stack = player_data.cardStack.duplicate()
	var card = card_stack.pick_random()
	hand_card_1.card_data = card.duplicate()
	card_stack.erase(card)
	card = card_stack.pick_random()
	hand_card_2.card_data = card.duplicate()
	card_stack.erase(card)
	card = card_stack.pick_random()
	hand_card_3.card_data = card.duplicate()
	card_stack.erase(card)


func on_card_clicked():
	pass


func _on_trade_button_button_up():
	pass #call_ui_popup_by_caller(confirm_trade_data)


func _on_shop_card_1_clicked():
	on_card_clicked()


func _on_shop_card_2_clicked():
	on_card_clicked()


func _on_shop_card_3_clicked():
	on_card_clicked()


func _on_hand_card_1_clicked():
	on_card_clicked()


func _on_hand_card_2_clicked():
	on_card_clicked()


func _on_hand_card_3_clicked():
	on_card_clicked()
