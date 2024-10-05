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
		await trigger_keycard_attack_dialog(attacking_card)
		await combat.handle_attacks(attacking_card, i, false)
		await trigger_player_hp_dialog()
		if combat.is_battle_over:
			return ExitState.ABORT
	if combat.is_blocked:
		await combat.block_lifted
	return ExitState.DEFAULT


func trigger_keycard_attack_dialog(attacking_card : CombatCard):
	var enemy_data : EnemyData = combat.enemy.data
	for dialog : EnemyDialog in enemy_data.dialog_data:
		if dialog.get_trigger_type() == EnemyDialog.TriggerType.KEYCARD_ATTACK:
			if dialog.card_data.name == attacking_card.card_data.name:
				var screen = SceneHandler.add_ui_element(BattleDialog.file_path) as BattleDialog
				screen.init(0, self)
				screen.setup(dialog.dialogue_lines, dialog.character_image)
				await screen.dialog_finished
				enemy_data.dialog_data.erase(dialog)


func trigger_player_hp_dialog():
	var enemy_data : EnemyData = combat.enemy.data
	for dialog : EnemyDialog in enemy_data.dialog_data:
		if dialog.get_trigger_type() == EnemyDialog.TriggerType.PLAYER_HP:
			if combat.player.health <= dialog.hp:
				var screen = SceneHandler.add_ui_element(BattleDialog.file_path) as BattleDialog
				screen.init(0, self)
				screen.setup(dialog.dialogue_lines, dialog.character_image)
				await screen.dialog_finished
				enemy_data.dialog_data.erase(dialog)
