extends Control

@export var card_template: PackedScene

@export var player_data: PlayerData


func _ready():
	show_cards(player_data.cardStack)


func filter_cards(cards: Array[CardData], filter_opts: FilterOptions) -> Array[CardData]:
	var result = cards.filter(func(card: CardData):
		if not filter_opts.attack_min == null:
			if card.attack < filter_opts.attack_min:
				return false
		if not filter_opts.attack_max == null:
			if card.attack >= filter_opts.attack_max:
				return false
		
		if not filter_opts.karma_min == null:
			if card.cost < filter_opts.karma_min:
				return false
		if not filter_opts.karma_max == null:
			if card.cost >= filter_opts.karma_max:
				return false
		
		if not filter_opts.health_min == null:
			if card.health < filter_opts.health_min:
				return false
		if not filter_opts.health_max == null:
			if card.health >= filter_opts.health_max:
				return false
		
		for _keyword in filter_opts.keywords:
			var found = false
			for keyword in card.keywords:
				if is_instance_of(keyword, _keyword):
					found = true
			if not found:
				return false
		
		return true
	)
	
	return result


func show_cards(cards: Array[CardData]):
	for child in %CardsContainer.get_children():
		child.queue_free()
	
	for card in cards:
		var instance = card_template.instantiate() as Card
		instance.load_from_data(card)
		instance.setup()
		%CardsContainer.add_child(instance)


func _on_confirm_filter_pressed():
	var options = %FilterOptions.get_filter_options()
	show_cards(filter_cards(player_data.cardStack, options))


func refresh():
	var options = %FilterOptions.get_filter_options()
	show_cards(filter_cards(player_data.cardStack, options))
