class_name FriendlyAttackPhase
extends CombatPhase


static func get_class_name():
	return "Friendly Attack Phase"


func get_corresponding_trigger():
	return CombatPhaseTrigger.SourcePhases.FRIENDLY_ATTACKS


func process_effect():
	for i in range(combat.gameBoard.player_tiles.get_child_count()):
		if combat.gameBoard.player_tiles.get_child(i).get_child_count() == 0:
			continue
		await combat.handle_attacks(combat.gameBoard.player_tiles.get_child(i).get_child(0), i, true)
		if combat.is_battle_over:
			return

