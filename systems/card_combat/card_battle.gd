class_name CardBattle
extends Control

signal player_turn_ended
signal block_lifted
signal finished(remaining_health : int)

var player_data : PlayerData


## Each turn consits of the phases in the order they appear here
@export var phases : Array[CombatPhase] = []

## Will be used as the intital phase
@export var phase_idx = 0
@export var phase_end_delay = 0.5

@export_category("Debug")
@export var show_current_phase_text := true
@export var is_debug : bool
@export var debug_player_data : PlayerData
@export var debug_enemy_data : DebugEnemyData

@onready var game_board : GameBoard = $GameBoard
@onready var player : CardPlayer = $CardPlayer
@onready var enemy : EnemyPlayer = $EnemyPlayer

#var enemy_board : Array[Array]
#var board_width : int = 5
var is_battle_over = false
var turn = 0
var is_blocked := false :
	set(value):
		if value == false:
			block_lifted.emit()
		is_blocked = value
	get:
		return is_blocked


func _ready():
	GlobalLog.set_context(GlobalLog.Context.COMBAT)
	GlobalLog.add_entry(name + " loaded.")
	lock_player_actions()
	if is_debug:
		await get_tree().process_frame # game_board needs to be ready first lol
		init(debug_player_data, debug_enemy_data)
		start_combat()


func _exit_tree():
	for phase : CombatPhase in phases:
		phase.reset()


func init(player_data, enemy_data):
	self.player_data = player_data
	player.init(player_data)
	if not enemy_data is OldEnemyData: 
		enemy_data.init()
		enemy_data.setup_brain(enemy, self)
	enemy.init(enemy_data)
	for phase in phases:
		phase.init(self)
	game_board.card_played.connect(_on_card_played)


func _input(event):
	if not OS.has_feature("no-cheat") && event.is_action_pressed("debug_quit"):
		finished.emit(player.health)


func _on_active_cards_changed(source, block = true):
	if block:
		is_blocked = true
	var active_cards = game_board.get_active_cards()
	for card : CombatCard in active_cards:
		for i in range(card.keywords.size()):
			if card.keywords[i] is ActivatedKeyword and card.keywords[i].triggers & 4:
				await card.keywords[i].trigger(source, card, card.keywords[i].get_target(source, card, self), \
						card.get_node("KeyWordSlots").get_child(i).get_child(0), {"active_cards": active_cards})
	if block:
		await get_tree().process_frame
		is_blocked = false


func _on_card_played(new_card : CombatCard):
	is_blocked = true
	await _on_active_cards_changed(new_card, false)
	var active_cards = game_board.get_active_cards()
	for card : CombatCard in active_cards:
		if card != new_card:
			continue
		for i in range(card.keywords.size()):
			if card.keywords[i] is ActivatedKeyword and card.keywords[i].triggers & 16:
				await card.keywords[i].trigger(card, card, card.keywords[i].get_target(card, card, self), \
						card.get_node("KeyWordSlots").get_child(i).get_child(0), {"active_cards": active_cards})
	await get_tree().process_frame
	is_blocked = false


func start_combat():
	process_next_phase()


func process_next_phase():
	if show_current_phase_text:
		$CurrentPhaseLabel.text = "Current Phase: \n" + \
		phases[phase_idx].get_class_name()
	phases[phase_idx].execute()
	match await phases[phase_idx].completed:
		CombatPhase.ExitState.ABORT:
			return
		_:
			pass
	_on_phase_completed()


func _on_phase_completed():
	if is_blocked:
		await block_lifted
	await get_tree().create_timer(phase_end_delay).timeout
	phase_idx += 1
	if phase_idx >= phases.size():
		turn += 1
		phase_idx = 0
	process_next_phase()


func lock_player_actions():
	player.set_active(false)
	#%CardDeletionButton.button_pressed = false
	#%CardDeletionButton.disabled = true
	%EndTurnButton.disabled = true


func unlock_player_actions():
	player.set_active(true)
	#%CardDeletionButton.disabled = false
	%EndTurnButton.disabled = false


func _on_end_turn_button_pressed():
	player_turn_ended.emit()


func handle_attacks(attacker, column, is_source_friendly):
	for offset in await attacker.get_target_offsets():
		await try_attack(attacker, column + offset, is_source_friendly)


func try_attack(attacker, column_idx, friendly = false) -> bool:
	var target = game_board.get_target(column_idx, friendly)
	var was_target_player = target is CardPlayer or target is EnemyPlayer
	if target == null:
		return false
	game_board.highlight_tile(column_idx, friendly)
	if await attacker.animate_attack(target, column_idx, game_board.get_tile(column_idx, friendly)):
		if was_target_player:
			finished.emit(player.health)
			is_battle_over = true
		else:
			await _on_active_cards_changed(target)
			await target.trigger_keywords(attacker, target, 8, self)
			await target.process_death()
	game_board.end_tile_highlight(column_idx, friendly)
	await get_tree().process_frame
	return true


#func move_enemies():
	#for y in range(enemy_board.size() - 1):
		#for x in range(enemy_board[y].size()):
			#if (enemy_board[y][x] != null || enemy_board[y+1][x] == null):
				#continue
			#if y == 1:
				#game_board.place_enemy_card_back(enemy_board[y+1][x], x)
			#elif y == 0:
				#if await game_board.try_move_enemy_card_to_front(x):
					#enemy_board[y+1][x] = null
				#continue
			#enemy_board[y][x] = enemy_board[y+1][x]
			#enemy_board[y+1][x] = null
#
#
#func update_enemy_card_placement():
	#for x in range(board_width):
		#if enemy_board.size() > 0 && enemy_board[0][x] != null:
			#game_board.place_enemy_card_front(enemy_board[0][x], x)
			#enemy_board[0][x] = null # front board row can only be set once via EnemyData
		#if enemy_board.size() > 1 && enemy_board[1][x] != null:
			#game_board.place_enemy_card_back(enemy_board[1][x], x)


func handle_enemy_attacks():
	#await move_enemies()
	for i in range(game_board.enemy_tiles_front.get_child_count()):
		if game_board.enemy_tiles_front.get_child(i).get_child_count() == 0:
			continue
		await handle_attacks(game_board.enemy_tiles_front.get_child(i).get_child(0), i, false)
		if is_battle_over:
			return


func handle_friendly_attacks():
	for i in range(game_board.player_tiles.get_child_count()):
		if game_board.player_tiles.get_child(i).get_child_count() == 0:
			continue
		await handle_attacks(game_board.player_tiles.get_child(i).get_child(0), i, true)
		if is_battle_over:
			return
