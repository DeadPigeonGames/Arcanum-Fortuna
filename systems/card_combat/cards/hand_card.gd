class_name HandCard
extends Card

signal drag_started
signal drag_ended(card)


@export var drag_offset := Vector2(25, 25)
@export var is_auto_drag_offset := false
@export var max_offset_shadow := 50.0

static var held_card : HandCard
var is_picked_up = false
var base_scale = 1.0


@onready var show_card_tooltip = %ShowCardTooltip

func _ready():
	super._ready()
	base_scale = scale


func _notification(what):
	if what == NOTIFICATION_PARENTED:
		rotation = 0
		if get_parent().has_method("_on_card_added"):
			get_parent()._on_card_added(self)


func setup():
	super()


func _process(delta):
	if mouse_filter == MOUSE_FILTER_PASS:
		check_hand_is_hovered()
	
	%CardShadow.visible = is_picked_up
	
	var target_scale = base_scale
	if is_hovered:
		target_scale = base_scale * 1.1
		z_index = 4
	else:
		z_index = 3
	
	mouse_filter = Control.MOUSE_FILTER_IGNORE if is_picked_up else Control.MOUSE_FILTER_PASS
	$ShowCardTooltip.mouse_filter = mouse_filter
	
	if is_picked_up:
		z_index = 5
		var target_position = get_global_mouse_position() + drag_offset
		%SFXCard._SFX_SetLoopProps((global_position - target_position).length(), global_position)
		global_position = target_position # global_position.lerp(target_position, 0.5)
		target_scale = base_scale
	scale = scale.lerp(target_scale, 0.1)
	
	move_shadow()


func _input(event: InputEvent):
	if SceneHandler.get_current_ui_window() or\
	SceneHandler.get_current_dialogic():
		return
	
	if is_hovered and event.is_action_released("ui_rmb"):
		var new_inspection = load(inspection).instantiate() as CardInspection
		new_inspection.init(UIBase.UICLayerIndex.GAME_ELEMENT + 5, self)
		new_inspection.setup(self)
		SceneHandler.add_ui_element(new_inspection)
	
	if event.is_action_pressed("ui_lmb") and not is_picked_up:
		if is_hovered:
			pickup()
	
	if event.is_action_released("ui_lmb") and is_picked_up:
		put(null)
		emit_signal("drag_ended", self)


func check_hand_is_hovered():
	if SceneHandler.get_current_ui_window() or\
	SceneHandler.get_current_dialogic():
		is_hovered = false
		return
	
	if is_hoverable:
		var mouse_pos = get_global_mouse_position()
		is_hovered = get_global_rect().has_point(mouse_pos)
	else:
		is_hovered = false
	
	if hand and not (get_parent() == hand) and hand.is_card_dragged:
		is_hoverable = false


func move_shadow():
	var screen_center: Vector2 = get_viewport_rect().get_center()
	var distance: float = global_position.x - screen_center.x
	
	%CardShadow.position.x = lerp(0.0, -sign(distance) * max_offset_shadow, abs(distance/(screen_center.x)))
	%CardShadow.position.y = max_offset_shadow / 2.0


func pickup():
	show_card_tooltip.hide_tooltip()
	show_card_tooltip.set_process(false)
	$SFXCard._SFX_PickUp()
	
	is_picked_up = true
	if held_card:
		# Edge case if you pick up multiple cards
		held_card.put(null)
	held_card = self
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	if is_auto_drag_offset:
		drag_offset = global_position - get_global_mouse_position()
	emit_signal("drag_started")


func put(dropNode):
	show_card_tooltip.set_process(true)
	is_picked_up = false
	mouse_filter = Control.MOUSE_FILTER_PASS
	held_card = null


func set_hoverable(value : bool):
	if get_parent() == hand:
		is_hoverable = value
	else:
		is_hoverable = !value
