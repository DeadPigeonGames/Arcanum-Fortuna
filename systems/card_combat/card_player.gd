class_name CardPlayer extends Control

signal card_drag_started
signal card_drag_ended(card)

@onready var hand : Hand = %Hand
@onready var card_stack : CardStack = %CardStack


## Cost of the first bonus draw
@export var bonus_draw_cost := 2
## Whenever a bonus card is redeemed the cost is multiplied by this
@export var bonus_draw_cost_scale := 2.0

@export_category("Animation")
@export var animation_delay = 1
@export var draw_delay = 0.5
@export var attacked_color : Color = Color.RED
@export var active_color : Color = Color.GRAY
@export var positive_effect_color : Color = Color.GREEN

@export_category("Debug")
@export var is_debug = false 
@export var debug_data : PlayerData 

var health : int : 
	get:
		return health
	set(value):
		health = value
		%HealthLabel.text = str(health)
		%HealthBar.value = health

var max_health : int
var karma : int


func init(data: PlayerData):
	card_stack.cardStack = data.cardStack
	card_stack.init(data.draw_rng_seed)
	card_stack.shuffle()
	health = data.health
	max_health = health
	%HealthBar.max_value = max_health
	%HealthBar.value = health
	karma = data.karma


func _ready():
	if is_debug:
		init(debug_data)


#region damagage functions
func heal(amount):
	if amount < 0:
		push_error("Heal must be positive!")
		return
	health += amount
	health = min(health, max_health)
	

func take_damage(amount):
	animate_take_damage_feedback(amount)
	
	%HealthLabel.text = str(health) + " (" + str(-amount) + ")"
	health -= amount
	%Health.modulate = attacked_color
	GlobalLog.add_entry("You took %d damage." % amount)


func animate_take_damage_feedback(amount):
	SfxOther._SFX_Damage()
	$ScreenshakeCamera2D.add_trauma(0.15 * amount)
	$HurtOverlay.add_cooldown(0.1 * amount)


func restore_default_color():
	%HealthLabel.text = str(health)
	%Health.modulate = Color.WHITE
	%Karma.modulate = Color.WHITE


func process_death() -> bool:
	if health < 0:
		GlobalLog.add_entry("You died! Rip.")
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
	%KarmaLabel.text = str(karma) + \
		" (" + ("+" if amount >= 0 else "") + str(amount) + ")"
	karma += amount


func process_karma_overflow() -> bool:
	%KarmaLabel.text = str(karma)
	if karma < 0:
		GlobalLog.add_entry("Applying karma overflow of %d." % -karma)
		take_damage(-karma)
		$ScreenshakeCamera2D.add_trauma(0.1)
		await get_tree().create_timer(animation_delay).timeout
		karma = 0
	var is_lethal = process_death()
	%KarmaLabel.text = str(karma)
	restore_default_color()
	return is_lethal
	

func set_karma(value):
	karma = value
	%KarmaLabel.text = str(karma)
#endregion


func _on_card_dragged():
	card_drag_started.emit()


func _on_card_released(card):
	card_drag_ended.emit(card)


func draw_card():
	var drawn_card = card_stack.draw_card(hand)
	if drawn_card != null:
		drawn_card.drag_started.connect(_on_card_dragged)
		drawn_card.drag_ended.connect(_on_card_released)
		await get_tree().create_timer(draw_delay).timeout
	if card_stack.cardStack.size() == 0:
		$BonusDrawButton.hide()


func set_active(value):
	set_process(value)
	%Hand.enabled = value
	$BonusDrawButton.disabled = !value && len(%CardStack.cardStack) > 0


func _on_bonus_draw_button_button_down():
	modify_karma(-bonus_draw_cost)
	bonus_draw_cost *= bonus_draw_cost_scale
	$BonusDrawButton.text = "-%d K" % bonus_draw_cost
	$BonusDrawButton.disabled = true
	await get_tree().create_timer(animation_delay).timeout
	await process_karma_overflow()
	restore_default_color()
	await draw_card()
	if len(%CardStack.cardStack) > 0 && %Hand.enabled:
		$BonusDrawButton.disabled = false

func _on_friendly_card_deleted(card : CombatCard):
	modify_karma(card.cost)
	await get_tree().create_timer(animation_delay).timeout
	await process_karma_overflow()
	restore_default_color()
