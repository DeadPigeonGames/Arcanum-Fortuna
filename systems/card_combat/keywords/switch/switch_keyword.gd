class_name SwitchKeyword
extends ActivatedKeyword

@export_category("Reward")
@export var attack_difference := 0
@export var health_difference := 0
@export var keywords_to_gain : Array[Keyword]
@export var keywords_to_remove : Array[Keyword]
@export var tranform_delay := 1.0
@export var transformed_artwork_shader : ShaderMaterial = preload("res://shaders/gradient_shader.tres")
@export var transformed_keyword_slot_atlas : Texture = preload("res://assets/ui/icons/keyword_slots_reversed.png")
@export var chromatic_scene := preload("res://systems/card_combat/effects/chromatic_aberration.tscn")

@export_category("Animation Durations")
@export var rotation_time = 0.8
@export var icon_rotation_time = 1.0

var combat_ref : CardBattle


func init():
	icon = load("res://assets/sprites/keywords/kw_switch_1.png")
	emission_icon = load("res://assets/sprites/keywords/kw_switch_1.png")
	if not self in keywords_to_remove:
		keywords_to_remove.append(self)


func get_target(source, owner, combat = null):
	combat_ref = combat


func _on_completed(owner : CombatCard, icon_to_animate = null):
	if not self in owner.keywords:
		push_error("Tried to complete switch-keyword '%s'
				despite not being part if its owner '%s' keywords.")
		return
	# owner.keywords.erase(self)
	await animate_transform(owner, icon_to_animate)
	owner.modify_keywords(keywords_to_remove, keywords_to_gain)
	owner.try_add_buff(Buff.new(attack_difference, health_difference, self, owner))
	
	SceneHandler.combat.card_awakened.emit(owner)
	
	if not owner.is_enemy:
		SteamService.try_unlock_achievement("Awake " + owner.card_name)
	
	await owner.get_tree().create_timer(1.0  * Settings.animation_time).timeout
	await owner.trigger_keywords(owner, owner, ActivatedKeyword.Triggers.ON_ACTIVE_CARDS_CHANGED, combat_ref)


func animate_transform(target, icon_to_animate):
	if not target is Card:
		push_error("Can't animate a non-card!")
		return
	
	var card = target as Card
	
	if icon_to_animate is Control:
		var icon_tween = icon_to_animate.create_tween() as Tween
		icon_tween.set_ease(Tween.EASE_IN_OUT)
		icon_tween.set_trans(Tween.TRANS_BACK)
		icon_tween.tween_property(icon_to_animate, "rotation", deg_to_rad(360), icon_rotation_time * Settings.animation_time)
		icon_tween.play()
	
	var tween = card.create_tween()
	target.get_node("%SFXCard")._SFX_Flip()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_IN)
	var half_rotation_time = rotation_time / 2.0
	tween.tween_property(card, "scale", Vector2.RIGHT, half_rotation_time * Settings.animation_time)
	tween.set_parallel(false)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "scale", Vector2.ONE, half_rotation_time * Settings.animation_time)
	tween.finished.connect(func(): icon_to_animate.is_animating = false)
	tween.play()
	var chromatic = chromatic_scene.instantiate()
	SceneHandler.combat.add_child(chromatic)
	await card.get_tree().create_timer(half_rotation_time * Settings.animation_time).timeout
	target.set_transformed_visuals(transformed_artwork_shader, transformed_keyword_slot_atlas)
	await card.get_tree().create_timer(half_rotation_time * Settings.animation_time).timeout
	chromatic.queue_free()
