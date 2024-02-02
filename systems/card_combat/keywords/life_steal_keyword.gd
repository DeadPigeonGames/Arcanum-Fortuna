class_name LifestealKeyword
extends ActivatedKeyword

var gained_health_lookup : Dictionary


func get_dynamic_description(owner: Card):
	if not owner in gained_health_lookup:
		return ""
	return " (Gained Health: %d)" % gained_health_lookup[owner]


func trigger(source, owner, target, icon_to_animate, params={}):
	if not "damage_dealt" in params:
		push_error("Damage Switch cannot be triggered without dealt damage!")
		return
	await super(source, owner, target, icon_to_animate, params)
	owner.health += params["damage_dealt"]
	if not owner in gained_health_lookup:
		gained_health_lookup[owner] = params["damage_dealt"]
	else:
		gained_health_lookup[owner] += params["damage_dealt"]
