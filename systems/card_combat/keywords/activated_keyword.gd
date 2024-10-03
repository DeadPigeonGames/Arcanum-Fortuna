class_name  ActivatedKeyword
extends Keyword


enum Triggers {
	ON_KILL = 1,
	ON_KARMA_DECREASE = 2,
	ON_ACTIVE_CARDS_CHANGED = 4,
	ON_DEATH = 8,
	ON_PLAYED = 16,
	ON_ATTACK = 32,
	ON_TAKE_DAMAGE = 64,
	ON_ATTACK_ATTEMPTED = 128
}

## Setup combat phases that should trigger this keyword
@export var combat_phase_triggers : Array[CombatPhaseTrigger] = []
## Setup other events that should trigger this keyword
@export_flags("OnKill", "OnKarmaDecrease", "OnActiveCardsChanged", "OnDeath", \
		"OnPlayed", "OnAttack", "OnTakeDamage", "OnAttackAttempted") var triggers := 0

@export_category("Animation")
@export var is_animated := true
@export var scale_speed = 0.6
@export var animate_scale := false
@export var animate_particle := true

func get_target(source, owner, combat = null):
	return owner


func trigger(source, owner, target, icon_to_animate, params={}):
	if not is_animated:
		return
	await animate(source, owner, icon_to_animate, params)


func animate(source, owner: CombatCard, icon_to_animate, params):
	var duration = scale_speed * Settings.animation_time
	if icon_to_animate and animate_scale:
		var tween = icon_to_animate.create_tween()
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.set_ease(Tween.EASE_IN)
		tween.set_parallel(true)
		tween.tween_property(icon_to_animate, "scale", Vector2.ONE * 5.0, duration * Settings.animation_time)
		tween.tween_property(icon_to_animate, "position", Vector2(14, -85), duration * Settings.animation_time)
		tween.set_ease(Tween.EASE_OUT)
		tween.set_parallel(false)
		tween.tween_property(icon_to_animate, "scale", Vector2.ONE, duration)
		tween.set_parallel(true)
		tween.tween_property(icon_to_animate, "position", icon_to_animate.origin_position, duration * Settings.animation_time)
		tween.finished.connect(func(): icon_to_animate.is_animating = false)
		tween.play()
		await icon_to_animate.get_tree().create_timer(duration).timeout
	if animate_particle:
		await owner.animate_icon(icon)
