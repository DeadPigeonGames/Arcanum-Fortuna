class_name LifestealKeyword
extends ActivatedKeyword

func trigger(source, owner, target, icon_to_animate, params={}):
	if not "damage_dealt" in params:
		push_error("Damage Switch cannot be triggered without dealt damage!")
		return
	await super(source, owner, target, icon_to_animate, params)
	owner.health += params["damage_dealt"]
