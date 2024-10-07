@tool
extends EventNode

@export var potential_events : Array[RandomScene]


var level := 0

var index
var rng : RandomNumberGenerator
var combat_seed := 0
var draw_seed := 0


func init(level: int, rng: RandomNumberGenerator):
	self.rng = rng
	self.level = level
	combat_seed = rng.randi()
	draw_seed = rng.randi()


func _generated(node_index: int, _level: int, _rng: RandomNumberGenerator):
	index = node_index
	init(_level, _rng)


func _ready():
	super._ready()
	if Engine.is_editor_hint():
		return
	var replacement_event := RandomScene.get_random_from(potential_events)
	if not replacement_event:
		return
	event = replacement_event.scene
	$background/icon.texture = replacement_event.placeholder_icon_texture


func _trigger_event():
	await trigger_dialog(demo_dialogic_begin)
	
	var selected_enemy = null
	var was_battle_event = false
	
	if not event:
		return
	if is_scene_switch:
		SceneHandler.change_scene(event)
		return
	var instance = event.instantiate()
	if instance is BattleEvent:
		was_battle_event = true
		instance.seed = combat_seed
		if demo_enemy_data != null:
			selected_enemy = demo_enemy_data
		else:
			var enemy_pool = instance.potential_enemies.filter(func(enemy): 
				return (enemy.max_level < 0 or level <= enemy.max_level) and level >= enemy.min_level)
			selected_enemy = enemy_pool[rng.randi_range(0, len(enemy_pool) - 1)]
		selected_enemy.level = level
		selected_enemy.rng_seed = combat_seed
		player.data.draw_rng_seed = draw_seed
		
		ScreenFade.fade_out(1.0, true, true)
		get_parent().combat_started.emit()
		await ScreenFade.fade_out_complete
		
	elif "seed" in instance:
		instance.seed = combat_seed
	if instance.has_method("trigger"):
		instance.trigger(player.data, selected_enemy)
	await instance.finished
	if was_battle_event:
		get_parent().combat_ended.emit()
	await trigger_dialog(demo_dialogic_end)
