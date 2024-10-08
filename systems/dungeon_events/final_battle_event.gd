@tool
class_name FinalBattleEvent
extends BattleEvent

var best_battle_one : EnemyData
@export var best_battle_two : EnemyData
@export var best_battle_three : EnemyData

@export var battle_1_win_dia : DialogicTimeline
@export var battle_1_lose_dia : DialogicTimeline

@export var battle_2_win_dia : DialogicTimeline
@export var battle_2_lose_dia : DialogicTimeline

@export var match_won : DialogicTimeline
@export var match_lose : DialogicTimeline

@export var reset_hp := 15

var battle_won_1 : bool = false
var battle_won_2 : bool = false
var battle_won_3 : bool = false


func trigger(player_data: PlayerData, enemy_data: EnemyData):
	if not is_inside_tree():
		SceneHandler.add_inactive_scenes_element(self)
	
	best_battle_one = enemy_data
	
	var field
	var remaining_life = await start_battle(field, player_data, best_battle_one)
	battle_won_1 = remaining_life > 0
	
	if battle_won_1:
		player_data.health = remaining_life
		await SceneHandler.trigger_dialog(battle_1_win_dia)
	else:
		player_data.health = reset_hp
		await SceneHandler.trigger_dialog(battle_1_lose_dia)
	
	await reset_battle(field)
	
	field = battleField.instantiate()
	remaining_life = await start_battle(field, player_data, best_battle_two)
	battle_won_2 = remaining_life > 0
	
	var is_match_3 = false
	
	if battle_won_2 == true:
		player_data.health = remaining_life
		if battle_won_1:
			await SceneHandler.trigger_dialog(match_won)
			await trigger_end(field, player_data, enemy_data)
			return # end
		else:
			await SceneHandler.trigger_dialog(battle_2_win_dia)
			is_match_3 = true # Trigger 3
	else: # == false
		if battle_won_1 == false:
			await SceneHandler.trigger_dialog(match_lose)
			await trigger_end(field, player_data, enemy_data)
			return
			# end
		await SceneHandler.trigger_dialog(battle_2_lose_dia)
		is_match_3 = true # Trigger 3
		player_data.health = reset_hp
	
	if not is_match_3:
		return
	
	await reset_battle(field)
	
	field = battleField.instantiate()
	remaining_life = await start_battle(field, player_data, best_battle_three)
	battle_won_3 = remaining_life > 0
	
	if battle_won_3:
		await SceneHandler.trigger_dialog(match_won)
		Settings.set_died_prev_run(false)
		await trigger_end(field, player_data, enemy_data)
	else:
		await SceneHandler.trigger_dialog(match_lose)
		Settings.increase_death_count(1)
		Settings.set_died_prev_run(true)
		await trigger_end(field, player_data, enemy_data)
	
	finished.emit()


func trigger_end(field, player_data: PlayerData, enemy_data: EnemyData):
	Player.instance.get_parent().combat_started.emit()
	ScreenFade.fade_out(0.7)
	await ScreenFade.fade_out_complete
	SceneHandler.combat.queue_free()
	var win_screen = SceneHandler.add_ui_element(winEvent) as RunEndScreen
	win_screen.init(UIBase.UICLayerIndex.HIGH_PRIORITY, self)
	win_screen.setup()
	ScreenFade.fade_in(0.7)
	await ScreenFade.fade_in_complete
	queue_free()


func start_battle(field, player_data : PlayerData, enemy_data : EnemyData) -> int:
	field = battleField.instantiate()
	$CanvasLayer.set_layer(UIBase.UICLayerIndex.BATTLE)
	$CanvasLayer.add_child(field)
	ScreenFade.fade_in(0.7, true, true)
	await ScreenFade.fade_in_complete
	SceneHandler.combat = field
	await SceneHandler.current_scene.get_tree().process_frame
	field.init(player_data.duplicate(true), enemy_data.duplicate(true))
	
	## REMOVE AFTER DEMO!
	field.enemy.set_karma(enemy_data.demo_start_karma)
	field.start_combat()
	
	var remainingLife = await field.finished
	return remainingLife


func reset_battle(field):
	Player.instance.get_parent().combat_started.emit()
	ScreenFade.fade_out(0.7, true, true)
	await ScreenFade.fade_out_complete
	SceneHandler.combat.queue_free()
	await SceneHandler.current_scene.get_tree().process_frame
