class_name DeckPreviewOverlay
extends UIBase

@export var deck_card_template : PackedScene

var player_data : PlayerData
var card_data_lookup = {}

@onready var animation_player = %AnimationPlayer
@onready var player_deck : PlayerDeckPreview = %PlayerDeck

func setup_player_data(player_data : PlayerData):
	self.player_data = player_data
	get_cards()
	sort_karma()
	%SortByKarmaButton.grab_focus()


func setup():
	animation_player.play("open_deck_preview")


func get_cards():
	self.card_data_lookup.clear()
	for card in player_data.cardStack:
		if card_data_lookup.keys().has(card):
			card_data_lookup[card] += 1
		else:
			card_data_lookup[card] = 1


func get_deck_preview_cards():
	var deck_cards : Array[DeckPreviewCard]
	for card_data in card_data_lookup.keys():
		var deck_card_instance = deck_card_template.instantiate() as DeckPreviewCard
		deck_card_instance.setup(card_data, card_data_lookup[card_data])
		deck_cards.append(deck_card_instance)
	return deck_cards


func clear():
	player_deck.clear()
	card_data_lookup.clear()
	get_cards()


func sort_karma():
	clear()
	var deck_cards = get_deck_preview_cards()
	card_data_lookup.keys()
	deck_cards.sort_custom(
		func(a, b): return a.card.card_data.cost > b.card.card_data.cost
	)
	player_deck.populate_with_cards(deck_cards)


func sort_attack():
	clear()
	var deck_cards = get_deck_preview_cards()
	deck_cards.sort_custom(
		func(a, b): return a.card.card_data.attack > b.card.card_data.attack
	)
	player_deck.populate_with_cards(deck_cards)


func sort_health():
	clear()
	var deck_cards = get_deck_preview_cards()
	deck_cards.sort_custom(
		func(a, b): return a.card.card_data.health > b.card.card_data.health
	)
	player_deck.populate_with_cards(deck_cards)


func close():
	animation_player.play("close_deck_preview")
	await animation_player.animation_finished
	super.close()


func _on_close_window_button_button_up():
	close()


func _on_sort_by_karma_button_button_up():
	sort_karma()


func _on_sort_by_attack_button_button_up():
	sort_attack()


func _on_sort_by_health_button_button_up():
	sort_health()
