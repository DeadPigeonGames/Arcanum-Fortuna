class_name CardPlayer extends Control

signal card_drag_started
signal card_drag_ended(card)

@onready var hand : Hand = %Hand
@onready var card_stack : CardStack = %CardStack

@export var animation_delay = 1
@export var draw_delay = 0.5
@export var attacked_color : Color = Color.RED
@export var active_color : Color = Color.GRAY
@export var positive_effect_color : Color = Color.GREEN

@export_category("Debug")
@export var is_debug = false 
@export var debug_data : PlayerData 

var health : int
var karma : int

func init(data: PlayerData):
	card_stack.cardStack = data.cardStack
	card_stack.init(data.draw_rng_seed)
	card_stack.shuffle()
	health = data.health
	karma = data.karma
	%Health/Label.text = "Health: " + str(health)


func _ready():
	if is_debug:
		init(debug_data)

#region damagage functions
func take_damage(amount):
	%Health/Label.text = "Health: " + str(health) + " (" + str(-amount) + ")"
	health -= amount
	%Health.modulate = attacked_color


func restore_default_color():
	%Health/Label.text = "Health: " + str(health)
	%Health.modulate = Color.WHITE
	%Karma.modulate = Color.WHITE


func proccess_death() -> bool:
	return health <= 0

#endregion


#region karma
func modify_karma(amount):
	if amount > 0:
		%Karma.modulate = positive_effect_color
	elif amount < 0:
		%Karma.modulate = attacked_color
	else:
		return
	%Karma/Label.text = "Karma: "+ str(karma) + \
		" (" + ("+" if amount >= 0 else "") + str(amount) + ")"
	karma += amount

func process_karma_overflow() -> bool:
	%Karma/Label.text = "Karma: " + str(karma)
	if karma < 0:
		take_damage(-karma)
		await get_tree().create_timer(animation_delay).timeout
		karma = 0
	var is_lethal = await proccess_death()
	%Karma/Label.text = "Karma: " + str(karma)
	restore_default_color()
	return is_lethal
	

func set_karma(value):
	karma = value
	%Karma/Label.text = "Karma: " + str(karma)
#endregion


func _on_card_dragged():
	emit_signal("card_drag_started")
	
func _on_card_released(card):
	emit_signal("card_drag_ended", card)

func draw_card():
	var drawn_card = card_stack.draw_card(hand)
	if drawn_card != null:
		drawn_card.drag_started.connect(_on_card_dragged)
		drawn_card.drag_ended.connect(_on_card_released)
	await get_tree().create_timer(draw_delay).timeout
	
func set_active(value):
	set_process(value)
	%Hand.enabled = value