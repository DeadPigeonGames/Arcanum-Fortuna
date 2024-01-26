class_name DamageSwitch
extends SwitchKeyword


@export_category("Condition")

## The Condition is met when this much attack damage was dealt by this card in total
@export var required_damage := 5

var dealt_damage_lookup : Dictionary

func init(id = 4):
	if title.count('%d') == 1:
		title = title % required_damage
	if description.count('%d') == 1:
		description = description % required_damage
	elif description.count('%d') == 2:
		description = description % [required_damage, required_damage]
	super.init(id)


func trigger(source, owner, target, icon_to_animate, params={}):
	if not "damage_dealt" in params:
		push_error("Damage Switch cannot be triggered without dealt damage!")
		return
	await super(source, owner, target, icon_to_animate, params)
	if not owner in dealt_damage_lookup:
		dealt_damage_lookup[owner] = required_damage
	dealt_damage_lookup[owner] -= params["damage_dealt"]
	if dealt_damage_lookup[owner] <= 0:
		await _on_completed(owner, icon_to_animate)
	
