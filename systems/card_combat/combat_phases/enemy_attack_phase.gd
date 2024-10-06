class_name EnemyAttackPhase
extends CombatPhase


static func get_class_name():
	return "Enemy Attack Phase"


func get_corresponding_trigger():
	return CombatPhaseTrigger.SourcePhases.ENEMY_ATTACKS


func process_effect() -> ExitState:
	for i in range(combat.game_board.enemy_tiles_front.get_child_count()):
		if combat.game_board.enemy_tiles_front.get_child(i).get_child_count() == 0:
			continue
		var attacking_card = combat.game_board.enemy_tiles_front.get_child(i).get_child(0)
		await EnemyDialog.trigger_keycard_attack_dialog(combat, attacking_card, self)
		await combat.handle_attacks(attacking_card, i, false)
		await EnemyDialog.trigger_player_hp_dialog(combat, self)
		if combat.is_battle_over:
			return ExitState.ABORT
	if combat.is_blocked:
		await combat.block_lifted
	return ExitState.DEFAULT
