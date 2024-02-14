class_name ShopBurnSection
extends UITabBase

@export var all_cards_resource : AllCards
@export var cost_label : Label
@export var burn_card : ShopPreviewCard
@export var deck_preview_overlay : PackedScene
@export var card_prize := 4

var deck_preview : DeckPreviewOverlay
var player_data : PlayerData
var burn_button
var cards_to_burn : Array[CardData]
var original_price_text : String

func setup():
	burn_card.visible = false
	player_data = Player.instance.data
	burn_button = $BurnButton
	burn_button.disabled = true
	original_price_text = cost_label.text
	set_label_gold(0)


func select_card():
	if player_data.cardStack.size() < 3:
		return
	if player_data.currency < card_prize:
		burn_button.disabled = true
		return
	
	if not deck_preview:
		deck_preview = SceneHandler.add_ui_element(deck_preview_overlay) as DeckPreviewOverlay
		deck_preview.init(75, self)
		deck_preview.is_selectable = true
		deck_preview.setup()
	else:
		await deck_preview.close()
		deck_preview = null


func receive_result(result):
	if result is bool and result == false:
		return
	if result is bool and result == true:
		execute_burn_card()
	if result is Array[CardData]:
		burn_card.visible = true
		cards_to_burn = result
		burn_card.load_from_data(cards_to_burn[0])
		burn_card.play_animation("RESET")
		burn_card.set_shader_value(-1.0)
		set_label_gold(cards_to_burn.size() * card_prize)
	if player_data.currency >= card_prize * cards_to_burn.size():
		burn_button.disabled = false


func execute_burn_card():
	for card in cards_to_burn:
		burn_card.load_from_data(card)
		await burn_card.animate_burn()
		erase_card_from_player(burn_card.card_data)
		player_data.currency -= card_prize
	
	cards_to_burn.clear()
	burn_card.visible = false
	burn_button.disabled = true


func erase_card_from_player(card_data : CardData):
	for card in player_data.cardStack:
		if card.name == card_data.name and card.attack == card_data.attack:
			player_data.cardStack.erase(card)
			return


func set_label_gold(amount : int):
	cost_label.text = original_price_text
	cost_label.text = cost_label.text.replace("[amount]", str(amount))


func _on_burn_button_button_up():
	execute_burn_card()


func _on_texture_button_button_up():
	select_card()
