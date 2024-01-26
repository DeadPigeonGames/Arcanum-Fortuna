class_name DeathrattleHeal
extends ActivatedKeyword

@export var health_gain_amount := 2


func init():
	if title.count('%d') == 1:
		title = title % [health_gain_amount]
	if description.count('%d') == 1:
		description = description % [health_gain_amount]
	super.init()


func get_target(source, owner, combat = null):
	if combat == null:
		push_error("Cannot trigger DeathrattleHeal: Combat must be provided!")
		return
	var targets : Array[CombatCard] = []
	var cards = combat.game_board.get_front_enemies() if owner.is_enemy \
			else combat.game_board.get_friendly_cards()
	for i in range(cards.size()):
		if cards[i] != owner:
			continue
		if i > 0 && cards[i-1] != null:
			targets.append(cards[i-1])
		if i < cards.size() - 1 && cards[i+1] != null:
			targets.append(cards[i+1])
		break
	return targets


func trigger(source, owner, target, icon_to_animate, params={}):
	await super(source, owner, target, icon_to_animate, params)
	if target == null:
		return
	for card : CombatCard in target:
		card.health += health_gain_amount
