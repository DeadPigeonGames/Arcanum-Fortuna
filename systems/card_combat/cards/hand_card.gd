class_name HandCard extends Card

signal drag_started
signal drag_ended(card)

static var heldCard : HandCard

@export var drag_offset := Vector2(25, 25)

var isPickedUp = false

var move_around := true
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
	var target_scale = base_scale
	if is_hovered:
		target_scale = base_scale * 1.1
		z_index = 4
	else:
		z_index = 3
	
	if isPickedUp:
		z_index = 5
		var target_position = get_global_mouse_position() + drag_offset
		global_position = global_position.lerp(target_position, 0.5)
		%SFXCard._SFX_SetLoopProps((global_position - target_position).length(), global_position)
		target_scale = base_scale
	scale = scale.lerp(target_scale, 0.1)


func _input(event: InputEvent):
	if event.is_action_pressed("pickUpCard") and not isPickedUp:
		if is_hovered:
			pickup()
	
	if event.is_action_released("pickUpCard") and isPickedUp:
		put(null)
		emit_signal("drag_ended", self)


func pickup():
	show_card_tooltip.hide_tooltip()
	show_card_tooltip.set_process(false)
	$SFXCard._SFX_PickUp()
	
	isPickedUp = true
	if heldCard:
		# Edge case if you pick up multiple cards
		heldCard.put(null)
	heldCard = self
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	emit_signal("drag_started")


func put(dropNode):
	$SFXCard._SFX_PutDown()
	show_card_tooltip.set_process(true)
	isPickedUp = false
	mouse_filter = Control.MOUSE_FILTER_PASS
	heldCard = null
