class_name HealthDrain
extends ActivatedKeyword

@export var health_gain = 1
@export var enable_debug_print = false

var base_decription := ""


func init(id = 4):
	if description.count('%d') == 2:
		base_decription = description
		description = description % [health_gain, 0]
	super.init(id)

func trigger(source, target, params={}):
	super(source, target, params)
	if not target is CombatCard:
		push_error("Cannot apply HealthDrain. Invalid target ", target, ".")
	GlobalLog.add_entry("Card '%s' at position %d-%d triggered Healthdrain." % [target.card_data.name, target.tile_coordinate.x, target.tile_coordinate.y])
	target.health = target.base_health
	if enable_debug_print:
		print("Health Drain triggered on ", target.card_name)
	var hit_count = 0
	for card : CombatCard in params.active_cards:
		if enable_debug_print:
			print("Card " + card.card_name + " costs " + str(card.cost))
		if card.cost > 0:
			hit_count += 1
			var print_str = str(target.attack)
			target.health += health_gain
			if enable_debug_print:
				print(print_str + " + " + str(health_gain) + " = " + str(target.health))
	if enable_debug_print:
		print(str(target.base_health) + " => " + str(target.health))
	target.update_texts()
	description = base_decription % [health_gain, hit_count]
