class_name FriendlyAttackPhase
extends CombatPhase


static func get_class_name():
	return "Friendly Attack Phase"


func get_corresponding_trigger():
	return CombatPhaseTrigger.SourcePhases.FRIENDLY_ATTACKS


func process_effect() -> ExitState:
	for i in range(combat.game_board.player_tiles.get_child_count()):
		if combat.game_board.player_tiles.get_child(i).get_child_count() == 0:
			continue
		await combat.handle_attacks(combat.game_board.player_tiles.get_child(i).get_child(0), i, true)
		await trigger_enemy_hp_dialog()
		if combat.is_battle_over:
			return ExitState.ABORT
		if combat.is_blocked:
			await combat.block_lifted
	return ExitState.DEFAULT


func trigger_enemy_hp_dialog():
	var enemy_data : EnemyData = combat.enemy.data
	for dialog : EnemyDialog in enemy_data.dialog_data:
		if dialog.get_trigger_type() == EnemyDialog.TriggerType.ENEMY_HP:
			if combat.enemy.health <= dialog.hp:
				var screen = SceneHandler.add_ui_element(BattleDialog.file_path) as BattleDialog
				screen.init(0, self)
				screen.setup(dialog.dialogue_lines, dialog.character_image)
				await screen.dialog_finished
				enemy_data.dialog_data.erase(dialog)
