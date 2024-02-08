class_name EnemyPlayer extends Control

@export_category("Animation")
@export var animation_delay = 1
@export var attacked_color : Color = Color.RED
@export var active_color : Color = Color.GRAY
@export var positive_effect_color : Color = Color.GREEN

var data
var health := 20 : 
	get:
		return health
	set(value):
		health = value
		%HealthLabel.text = str(health)
		%HealthBar.value = health
		if !max_health or max_health <= 0:
			return
		$ResourceContainer/Health/HealthIcon/AnimationPlayer.speed_scale = 1.0 / (float(health) / float(max_health))
var max_health
var karma = 0

var stored_health_buff := 0
var stored_attack_buff := 0


func init(enemy_data):
	data = enemy_data
	if data is OldEnemyData:
		health = data.health
	else:
		set_health(data.get_random_health())
	max_health = health
	%HealthBar.value = health
	%HealthBar.max_value = max_health
	var name_label = get_node_or_null("Title")
	if (name_label):
		name_label.text = name_label.text % enemy_data.title


func set_health(value):
	health = value
	%HealthLabel.text = str(health)


func get_rows():
	return data.get_rows()


func calc_card_placements() -> Array[EnemyBrain.CardPlacement]:
	return data.brain.calc_card_placements()


func transfer_stored_buffs(card: CombatCard):
	card.health += stored_health_buff
	card.attack += stored_attack_buff
	stored_attack_buff = 0
	stored_health_buff = 0


#region damage function
func heal(amount):
	if amount < 0:
		push_error("Heal must be positive!")
		return
	health += amount
	health = min(health, max_health)


func take_damage(amount, _source = null):
	SfxOther._SFX_Damage()
	%HealthLabel.text = str(health) + " (" + str(-amount) + ")"
	health -= amount
	%Health.modulate = attacked_color
	GlobalLog.add_entry("The enemy took %d damage." % amount)
	return amount


func restore_default_color():
	%HealthLabel.text = str(health)
	%Health.modulate = Color.WHITE
	%Karma.modulate = Color.WHITE

func process_death() -> bool:
	if health < 0:
		GlobalLog.add_entry("The enemy died!")
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
		take_damage(-karma, self)
		await get_tree().create_timer(animation_delay).timeout
		karma = 0
	var was_lethal = process_death()
	%KarmaLabel.text = str(karma)
	restore_default_color()
	return was_lethal
	

func set_karma(value):
	karma = value
	%KarmaLabel.text = str(karma)
#endregion

