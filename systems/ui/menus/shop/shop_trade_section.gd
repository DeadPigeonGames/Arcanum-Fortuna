class_name ShopTradeSection
extends UITabBase

@export var card_prize := 3
@export var all_cards_resource : AllCards
@export var shop_card_1 : ShopPreviewCard
@export var shop_card_2 : ShopPreviewCard
@export var shop_card_3 : ShopPreviewCard
@export var hand_card_1 : ShopPreviewCard
@export var hand_card_2 : ShopPreviewCard
@export var hand_card_3 : ShopPreviewCard

var player_data : PlayerData
var trade_button


func setup():
	trade_button = $TradeButton
	player_data = Player.instance.data
	player_data.currency = 30
	randomize_shop_cards()
	randomize_hand_cards()
	hand_card_1.selected_shader.color = Color.DARK_BLUE
	hand_card_2.selected_shader.color = Color.DARK_BLUE
	hand_card_3.selected_shader.color = Color.DARK_BLUE
	set_trade_button_enabled()
	


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


func process_trade():
	var s_cards : Array[ShopPreviewCard] = get_shop_cards()
	var h_cards : Array[ShopPreviewCard] = get_hand_cards()
	
	for card in h_cards:
		await card.animate_burn()



func get_shop_cards():
	var s_cards : Array[ShopPreviewCard]
	
	if shop_card_1.selected == true:
		s_cards.append(shop_card_1)
	if shop_card_2.selected == true:
		s_cards.append(shop_card_2)
	if shop_card_3.selected == true:
		s_cards.append(shop_card_3)
	
	return s_cards


func get_hand_cards():
	var h_cards : Array[ShopPreviewCard]
	
	if hand_card_1.selected == true:
		h_cards.append(hand_card_1)
	if hand_card_2.selected == true:
		h_cards.append(hand_card_2)
	if hand_card_3.selected == true:
		h_cards.append(hand_card_3)
	
	return h_cards


func is_card_count_matched():
	return get_selected_shop_card_count() == get_selected_hand_card_count()


func get_selected_shop_card_count():
	var shop_count := 0
	for card in get_shop_cards():
		if card.selected:
			shop_count += 1
	return shop_count


func get_selected_hand_card_count():
	var hand_count := 0
	for card in get_hand_cards():
		if card.selected:
			hand_count += 1
	return hand_count


func set_trade_button_enabled():
	await SceneHandler.scene_container.get_tree().process_frame
	
	if get_selected_shop_card_count() == 0:
		trade_button.disabled = true
		return
	if is_card_count_matched() == false:
		trade_button.disabled = true
		return
	if get_selected_shop_card_count() * card_prize > player_data.currency:
		trade_button.disabled = true
		return
	trade_button.disabled = false


func _on_shop_card_clicked():
	set_trade_button_enabled()


func _on_hand_card_clicked():
	set_trade_button_enabled()


func _on_trade_button_button_up():
	process_trade()
