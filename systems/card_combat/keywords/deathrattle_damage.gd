class_name DeathrattleDamage
extends ActivatedKeyword

enum TargetType {
	OpposingCard,
	OpposingPlayer
}

@export var damage_amount := 3
@export var target_type := TargetType.OpposingPlayer


func init():
	if title.count('%d') == 1:
		title = title % [damage_amount]
	if description.count('%d') == 1:
		description = description % [damage_amount]
	super.init()


func get_target(source, owner, combat = null):
	if combat == null:
		push_error("Cannot trigger DeathrattleDamage: Combat must be provided!")
		return null
	var opposing_row = combat.game_board.get_enemy_front_row() if not owner.is_enemy \
			else combat.game_board.get_friendly_row()
	match target_type:
		TargetType.OpposingCard:
			return opposing_row[owner.tile_coordinate.x]
		TargetType.OpposingPlayer:
			return combat.enemy if not owner.is_enemy else combat.player


func trigger(source, owner, target, icon_to_animate, params={}):
	if target == null:
		return
	if not target.has_method("take_damage"):
		push_error("Cannot apply DeathrattleDamage: target '" + str(target) + "' has no take_damge method!")
		return
	await super.trigger(source, owner, target, icon_to_animate, params)
	await target.take_damage(damage_amount)
	if target is CombatCard:
		await target.process_death()
