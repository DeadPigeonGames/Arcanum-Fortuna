class_name EnemyPlacementPhase
extends CombatPhase


static func get_class_name():
	return "Enemy Placement Phase"


func get_corresponding_trigger():
	return CombatPhaseTrigger.SourcePhases.ENEMY_PLACEMENT


func process_effect() -> ExitState:
	if combat.is_debug:
		var column_idx = -1
		for card in combat.debug_enemy_data.fixed_placement_cards:
			column_idx += 1
			if column_idx >= GameBoard.width:
				return ExitState.DEFAULT
			if card == null or not combat.game_board.is_back_tile_empty(column_idx):
				continue
			combat.game_board.place_enemy_card_back(card, column_idx)
		return ExitState.DEFAULT
	
	var card_placements = combat.enemy.calc_card_placements()
	
	for placement in card_placements:
		combat.game_board.place_enemy_card_back(placement.card, placement.target_column)
	
	return ExitState.DEFAULT
