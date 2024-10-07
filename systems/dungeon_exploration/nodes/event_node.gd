@tool
class_name EventNode extends Control

signal activated(EventNode)
signal completed(EventNode)

var isCurrent := false
@export var connectsTo: Array[EventNode]
var connectedFrom: Array[EventNode] = []
@export_range(0, 10) var lookahead := 2
var currentLookahead = 0

## REMOVE AFTER DEMO!
@export var demo_enemy_data : EnemyData
@export var demo_dialogic_begin : DialogicTimeline
@export var demo_dialogic_end : DialogicTimeline


@export_category("Gameplay Options")
@export var event: PackedScene
## How much the enemy level should increase after the event completed
@export var level_gain := 0.0
## Should the scene be switched to the event scene instead of awaiting the event?
@export var is_scene_switch := false

@export_category("Display Options")

@export var defaultColor := Color.WHITE
@export var pickedColor := Color.YELLOW
@export var disabledColor := Color.GRAY
@export var highlightedColor := Color.BLUE
@export var width := 5.0
@export var dashed_width := 3.0
@export var offset := 2.0

var selectable = false
var player: Player
var selectedNode: EventNode
var is_hovered = false
var eventInProgress := false
var passed = false
var seed = 0
static var nodes_counter := 0


func _ready():
	if Engine.is_editor_hint():
		return
	if get_parent().has_method("_on_node_activated"):
		activated.connect(get_parent()._on_node_activated)
	if get_parent().has_method("_on_node_completed"):
		completed.connect(get_parent()._on_node_completed)
		nodes_counter += 1
		name += "+" + str(nodes_counter)
	$background/icon.visible = false
	for n in connectsTo:
		n.connectedFrom.append(self)


func init(_level: int, _rng: RandomNumberGenerator):
	return


func _generated(node_index: int, _level: int, _rng: RandomNumberGenerator):
	init(_level, _rng)


func _on_mouse_entered():
	if selectable:
		SfxOther._SFX_UIButtonHover()
	is_hovered = true


func _on_mouse_exited():
	is_hovered = false


func _process(delta):
	if selectable or Engine.is_editor_hint() or true:
		$background/icon.visible = true
	
	for node in connectsTo:
		if not is_instance_valid(node):
			continue
		
		if isCurrent:
			selectable = false
			node.player = player
			node.selectable = not eventInProgress
		
		if passed:
			node.selectable = false
	
	if passed:
		passed = false
	
	queue_redraw()


func _input(event: InputEvent):
	if (
			is_hovered
			and event.is_action_pressed("ui_lmb")
			and selectable
		):
		click()


func get_required_color():
	if is_hovered and selectable:
		return pickedColor
	if selectable:
		return defaultColor
	return disabledColor


func click():
	SfxOther._SFX_UIButtonPress()
	activated.emit(self)
	GlobalLog.set_context(GlobalLog.Context.NODEMAP)
	GlobalLog.add_entry("went to " + name)
	selectable = false
	player.update_target(self)
	await player.nodemap_move_to(self)
	for c in connectedFrom:
		c.passed = true
	
	eventInProgress = true
	await _trigger_event()
	eventInProgress = false
	completed.emit(self)


func _trigger_event():
	await trigger_dialog(demo_dialogic_begin)
	
	var test_instance = event.instantiate()
	if test_instance is RunEndScreen:
		var end_screen = SceneHandler.add_ui_element(event) as RunEndScreen
		end_screen.init(UIBase.UICLayerIndex.HIGH_PRIORITY, self)
		end_screen.setup()
		return
	if not event:
		return
	if is_scene_switch:
		SceneHandler.change_scene(event)
		return
	
	var was_battle_event
	var instance = event.instantiate()
	if instance is FinalBattleEvent:
		was_battle_event = true
		demo_enemy_data.rng_seed = seed
		player.data.draw_rng_seed = seed
		
		ScreenFade.fade_out(1.0, true, true)
		get_parent().combat_started.emit()
		await ScreenFade.fade_out_complete
	if "seed" in instance:
		instance.seed = seed
	instance.trigger(player.data, demo_enemy_data)
	await instance.finished


func _draw():
	if connectsTo.size() == 0:
		return
	for node in connectsTo:
		var target = node.position + (node.get_rect().size * Vector2(1, -1)) / 2 - position
		var direction = target.normalized()
		draw_dashed_line(direction * offset, target - direction * offset, node.get_required_color(), node.width, node.dashed_width, true)


func trigger_dialog(dialog : DialogicTimeline):
	if not dialog:
		return
	SceneHandler.set_visibility_ui_container(false)
	ScreenFade.tint_screen(Color.BLACK, 0.8, 1.0)
	SceneHandler.current_ui_window =\
	Dialogic.start(dialog)
	await Dialogic.timeline_ended
	ScreenFade.reset_tint(0.2)
	await ScreenFade.tint_complete
	SceneHandler.set_visibility_ui_container(true)
