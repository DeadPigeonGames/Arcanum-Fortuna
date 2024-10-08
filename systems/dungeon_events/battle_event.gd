class_name BattleEvent
extends EventBase

@export var potential_enemies: Array[EnemyData]
@export var battleField: PackedScene
@export var winEvent: PackedScene
@export var loseEvent: PackedScene

var pauseMovement := true
var hideMap := true
var seed := 0

func trigger(player_data: PlayerData, enemy_data: EnemyData):
	super(player_data, enemy_data)
	
	var field : CardBattle = battleField.instantiate()
	
	$CanvasLayer.set_layer(UIBase.UICLayerIndex.BATTLE)
	$CanvasLayer.add_child(field)
	SceneHandler.combat = field
	#field.is_debug = false
	field.init(player_data.duplicate(true), enemy_data.duplicate(true))
	
	## REMOVE AFTER DEMO!
	field.enemy.set_karma(enemy_data.demo_start_karma)
	field.start_combat()
	
	var remainingLife = await field.finished
	var won = remainingLife > 0
	
	if won:
		SteamService.try_unlock_achievement("Better than Noyan")
		Settings.set_died_prev_run(false)
	else:
		Settings.increase_death_count(1)
		Settings.set_died_prev_run(true)
	
	player_data.health = remainingLife
	
	var event = winEvent if won else loseEvent
	
	if event:
		var instance = event.instantiate()
		if instance is RunEndScreen:
			instance.queue_free()
			ScreenFade.fade_out(0.7, true, true)
			await ScreenFade.fade_out_complete
			field.queue_free()
			instance = SceneHandler.add_ui_element(loseEvent)
			instance.init(UIBase.UICLayerIndex.HIGH_PRIORITY, self)
			instance.setup()
			ScreenFade.fade_in(0.7, true, true)
			await ScreenFade.fade_in_complete
			queue_free()
			return
		if "seed" in instance:
			instance.seed = seed
		add_child(instance)
		instance.trigger(player_data, enemy_data)
		await instance.finished
		#battle_ends
		ScreenFade.fade_out(1.0)
		await ScreenFade.fade_out_complete
		ScreenFade.fade_in(1.0)
	
	field.queue_free()
	finished.emit()
	queue_free()
