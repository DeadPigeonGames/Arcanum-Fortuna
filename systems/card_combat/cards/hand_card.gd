class_name HandCard extends Card

signal drag_started
signal drag_ended(card)


@export var drag_offset := Vector2(25, 25)
@export var is_auto_drag_offset := false

static var held_card : HandCard
var is_picked_up = false
var is_hoverable := true
var base_scale = 1.0
var hand : Hand


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


func _input(event: InputEvent):
	if is_hovered and event.is_action_released("ui_rmb"):
		var new_inspection = inspection.instantiate() as CardInspection
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
	if is_hoverable:
		var mouse_pos = get_global_mouse_position()
		is_hovered = get_global_rect().has_point(mouse_pos)


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


func set_hand(hand : Hand):
	self.hand = hand
	if not hand.hand_hovered.is_connected(set_hand_card_hovered):
		hand.hand_hovered.connect(set_hand_card_hovered)


func set_hand_card_hovered(value : bool):
	if get_parent() != hand: # Is on board
		if value:
			is_hovered = false
		is_hoverable = !value


func _on_mouse_entered():
	return # Deny base behavior


func _on_mouse_exited():
	return # Deny base behavior
