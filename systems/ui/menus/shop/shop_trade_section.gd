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
	trade_button.disabled = true
	
	var s_cards : Array[ShopPreviewCard] = get_shop_cards()
	var h_cards : Array[ShopPreviewCard] = get_hand_cards()
	var tree = SceneHandler.current_scene.get_tree()
	var deck
	for node in SceneHandler.ui_container.get_children():
		if node is DeckInMenu:
			deck = node.get_child(0).get_child(0)
	for h_card in h_cards:
		h_card.selected_shader.visible = false
		await h_card.animate_burn()
		erase_card_from_player(h_card.card_data)
		h_card.queue_free()
		for s_card in s_cards:
			var tween : Tween = tree.create_tween()
			tween.set_trans(Tween.TRANS_CUBIC)
			tween.set_ease(Tween.EASE_IN_OUT)
			s_card.selected_shader.visible = false
			s_card.play_cardflip(false)
			tween.tween_property(s_card, "global_position", deck.global_position, 0.5)
			await tween.finished
			player_data.cardStack.append(s_card.card_data)
			s_card.queue_free()
	
	trade_button.disabled = false


func erase_card_from_player(card_data : CardData):
	for card in player_data.cardStack:
		if card.name == card_data.name and card.attack == card_data.attack:
			player_data.cardStack.erase(card)
			return


func get_shop_cards():
	var s_cards : Array[ShopPreviewCard]
	
	if shop_card_1 != null and shop_card_1.selected == true:
		s_cards.append(shop_card_1)
	if shop_card_2 != null and shop_card_2.selected == true:
		s_cards.append(shop_card_2)
	if shop_card_3 != null and shop_card_3.selected == true:
		s_cards.append(shop_card_3)
	
	return s_cards


func get_hand_cards():
	var h_cards : Array[ShopPreviewCard]
	
	if hand_card_1 != null and hand_card_1.selected == true:
		h_cards.append(hand_card_1)
	if hand_card_2 != null and hand_card_2.selected == true:
		h_cards.append(hand_card_2)
	if hand_card_3 != null and hand_card_3.selected == true:
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
